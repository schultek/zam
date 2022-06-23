part of split_module;

@MappableClass()
class BalancesListParams {
  final bool showZeroBalances;
  final bool showPots;

  BalancesListParams({this.showZeroBalances = true, this.showPots = true});
}

@MappableClass()
class BalanceFocusParams {
  final SplitSource? source;
  final bool currentUser;

  BalanceFocusParams({this.source, this.currentUser = true});

  SplitSource? getSource(BuildContext context) {
    if (currentUser) {
      var id = context.read(userIdProvider);
      if (id != null) return SplitSource.user(id);
    }
    return source;
  }
}

@MappableEnum()
enum Currency { euro, dollar, kuna }

extension CurrencySymbol on Currency {
  String get symbol {
    switch (this) {
      case Currency.euro:
        return '€';
      case Currency.dollar:
        return r'$';
      case Currency.kuna:
        return 'kn';
    }
  }
}

@MappableClass()
class SplitState {
  final Map<String, SplitPot> pots;
  final Map<String, SplitEntry> entries;
  final List<SplitTemplate> templates;
  final bool showBilling;
  final BillingRates? billingRates;

  SplitState({
    this.pots = const {},
    this.entries = const {},
    this.showBilling = false,
    this.templates = const [],
    this.billingRates,
  }) {
    balances = calcBalances();
    billing = calcBilling();
    stats = calcStats();
  }

  late final Map<SplitSource, SplitBalance> balances;
  late final List<BillingEntry> billing;
  late final BillingStats stats;

  Map<SplitSource, SplitBalance> calcBalances() {
    var balances = <SplitSource, SplitBalance>{
      ...pots.map((k, v) => MapEntry(SplitSource(k, SplitSourceType.pot), SplitBalance({Currency.euro: 0})))
    };
    var entries = [...this.entries.values]..sort();

    void addToBalance(SplitSource source, double amount, Currency currency) {
      var balance = balances[source] ??= SplitBalance({});
      balance.amounts[currency] = (balance.amounts[currency] ?? 0) + amount;
    }

    for (var entry in entries) {
      if (entry is ExpenseEntry) {
        if (entry.source.isUser) {
          addToBalance(entry.source, entry.amount, entry.currency);
        } else {
          addToBalance(entry.source, -entry.amount, entry.currency);
        }

        var target = entry.target;
        if (target.type == ExpenseTargetType.percent) {
          for (var e in target.amounts.entries) {
            addToBalance(SplitSource.user(e.key), -entry.amount * e.value / 100, entry.currency);
          }
        } else if (target.type == ExpenseTargetType.shares) {
          var sumShares = target.amounts.values.reduce((a, b) => a + b);
          for (var e in target.amounts.entries) {
            addToBalance(SplitSource.user(e.key), -entry.amount * e.value / sumShares, entry.currency);
          }
        } else if (target.type == ExpenseTargetType.amount) {
          for (var e in target.amounts.entries) {
            addToBalance(SplitSource.user(e.key), -entry.amount, entry.currency);
          }
        }
      } else if (entry is PaymentEntry) {
        if (entry.source.isUser) {
          addToBalance(entry.source, entry.amount, entry.currency);
        } else {
          addToBalance(entry.source, -entry.amount, entry.currency);
        }
        if (entry.target.isUser) {
          addToBalance(entry.target, -entry.amount, entry.currency);
        } else {
          addToBalance(entry.target, entry.amount, entry.currency);
        }
      } else if (entry is ExchangeEntry) {
        addToBalance(SplitSource(entry.potId, SplitSourceType.pot), -entry.sourceAmount, entry.sourceCurrency);
        addToBalance(SplitSource(entry.potId, SplitSourceType.pot), entry.targetAmount, entry.targetCurrency);
      }
    }

    return balances;
  }

  List<BillingEntry> calcBilling() {
    var usedCurrencies = balances.values.expand((b) => b.amounts.keys.where((c) => b.amounts[c] != 0)).toSet();
    var allUsers = balances.keys.where((s) => s.isUser).map((s) => s.id).toList();
    var entries = <BillingEntry>[];

    if (billingRates != null) {
      usedCurrencies.removeAll(billingRates!.rates.keys);
    }

    for (var currency in usedCurrencies) {
      var currBalances = balances.entries.map((e) {
        var amount = e.value.amounts[currency] ?? 0;
        if (billingRates != null && currency == billingRates!.target) {
          for (var rate in billingRates!.rates.entries) {
            amount += (e.value.amounts[rate.key] ?? 0) / rate.value;
          }
        }
        return BalanceEntry(e.key, amount * (e.key.isUser ? 1 : -1));
      }).toList();

      var balanceSum = currBalances.fold<double>(0.0, (sum, b) => sum + b.value);
      var targetBalance = balanceSum / allUsers.length;

      var positives = currBalances
          .map((b) => b.key.isUser ? BalanceEntry(b.key, b.value - targetBalance) : b)
          .where((b) => b.value > 0)
          .toList()
        ..sort((a, b) => a.value - b.value < 0 ? -1 : 1);
      var negatives = currBalances
          .map((b) => b.key.isUser ? BalanceEntry(b.key, b.value - targetBalance) : b)
          .where((b) => b.value < 0)
          .toList()
        ..sort((a, b) => a.value - b.value < 0 ? 1 : -1);

      while (positives.isNotEmpty) {
        var posLast = positives.last;

        if (negatives.isEmpty) break;
        var negLast = negatives.last;

        if (-negLast.value >= posLast.value) {
          entries.add(BillingEntry(negLast.key, posLast.key, currency, posLast.value));
          negLast.value += posLast.value;
          posLast.value = 0;
        } else {
          entries.add(BillingEntry(negLast.key, posLast.key, currency, -negLast.value));
          posLast.value += negLast.value;
          negLast.value = 0;
        }

        if (posLast.value == 0) {
          positives.removeLast();
        }
        if (negLast.value == 0) {
          negatives.removeLast();
        }
      }
    }

    return entries;
  }

  BillingStats calcStats() {
    var entries = [...this.entries.values]..sort();

    var totalSpendings = <Currency, double>{};
    var userSpendings = <String, SplitSpendings>{};

    void addSpending(String id, String title, Currency currency, double amount) {
      var spending = userSpendings[id] ??= SplitSpendings({}, []);
      spending.totalAmounts[currency] = (spending.totalAmounts[currency] ?? 0) + amount;
      spending.spendings.add(SplitSpending(title, currency, amount));
    }

    for (var entry in entries) {
      if (entry is ExpenseEntry) {
        Currency currency = entry.currency;
        double amount = entry.amount;

        if (billingRates?.rates[entry.currency] != null) {
          currency = billingRates!.target;
          amount = entry.amount / billingRates!.rates[entry.currency]!;
        }

        totalSpendings[currency] = (totalSpendings[currency] ?? 0) + amount;

        var target = entry.target;
        if (target.type == ExpenseTargetType.percent) {
          for (var e in target.amounts.entries) {
            addSpending(e.key, entry.title, currency, amount * e.value / 100);
          }
        } else if (target.type == ExpenseTargetType.shares) {
          var sumShares = target.amounts.values.reduce((a, b) => a + b);
          for (var e in target.amounts.entries) {
            addSpending(e.key, entry.title, currency, amount * e.value / sumShares);
          }
        } else if (target.type == ExpenseTargetType.amount) {
          for (var e in target.amounts.entries) {
            addSpending(e.key, entry.title, currency, amount);
          }
        }
      }
    }

    return BillingStats(SplitBalance(totalSpendings), userSpendings);
  }
}

@MappableClass()
class BillingStats with Mappable {
  final SplitBalance totalSpendings;
  final Map<String, SplitSpendings> userSpendings;

  BillingStats(this.totalSpendings, this.userSpendings);
}

@MappableClass()
class SplitSpendings with Mappable {
  Map<Currency, double> totalAmounts;
  List<SplitSpending> spendings;

  SplitSpendings(this.totalAmounts, this.spendings);

  String toPrintString() {
    return SplitBalance(totalAmounts).toPrintString();
  }
}

@MappableClass()
class SplitSpending with Mappable {
  final String title;
  final Currency currency;
  final double amount;

  SplitSpending(this.title, this.currency, this.amount);
}

@MappableClass()
class BillingRates with Mappable {
  final Currency target;
  final Map<Currency, double> rates;

  BillingRates(this.target, this.rates);
}

@MappableClass()
class SplitTemplate with Mappable {
  final String name;
  final ExpenseTarget target;

  SplitTemplate(this.name, this.target);
}

@MappableClass()
class BalanceEntry with Mappable {
  final SplitSource key;
  double value;

  BalanceEntry(this.key, this.value);
}

class SplitBalance {
  Map<Currency, double> amounts;

  SplitBalance(this.amounts);

  static final zeroEuros = SplitBalance({Currency.euro: 0});

  String toPrintString() {
    var entries = amounts.entries.where((e) => e.value != 0);
    if (entries.isEmpty && amounts.entries.isNotEmpty) entries = amounts.entries.take(1);
    return entries.map((e) => '${e.value.toStringAsFixed(2)}${e.key.symbol}').join(', ');
  }
}

@MappableClass()
class BillingEntry with Mappable {
  final SplitSource from;
  final SplitSource to;
  final Currency currency;
  final double amount;

  BillingEntry(this.from, this.to, this.currency, this.amount);
}

@MappableClass()
class SplitPot {
  String name;
  String? icon;

  SplitPot({required this.name, this.icon});
}

@MappableClass(discriminatorKey: 'type')
class SplitEntry with Comparable<SplitEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime? transactedAt;

  SplitEntry({required this.id, required this.createdAt, this.transactedAt});

  @override
  int compareTo(SplitEntry other) {
    var selfTime = transactedAt ?? createdAt;
    var otherTime = other.transactedAt ?? other.createdAt;
    return selfTime.compareTo(otherTime);
  }
}

@MappableEnum()
enum SplitSourceType { user, pot }

@MappableClass(hooks: SplitSourceHooks())
class SplitSource with Mappable {
  final String id;
  final SplitSourceType type;

  const SplitSource(this.id, this.type);

  const SplitSource.user(this.id) : type = SplitSourceType.user;
  const SplitSource.pot(this.id) : type = SplitSourceType.pot;

  bool get isUser => type == SplitSourceType.user;
  bool get isPot => type == SplitSourceType.pot;
}

class SplitSourceHooks extends MappingHooks {
  const SplitSourceHooks();

  @override
  beforeDecode(value) {
    if (value is String) {
      var parts = value.split('/');
      return {'type': parts[0], 'id': parts[1]};
    }
    return value;
  }

  @override
  afterEncode(value) {
    return '${value['type']}/${value['id']}';
  }
}

@MappableClass(discriminatorValue: 'expense')
class ExpenseEntry extends SplitEntry {
  String title;

  final double amount;
  final Currency currency;

  final SplitSource source;
  final ExpenseTarget target;

  final String? photoUrl;

  ExpenseEntry({
    required String id,
    required this.title,
    required this.amount,
    this.currency = Currency.euro,
    required this.source,
    required this.target,
    this.photoUrl,
    required DateTime createdAt,
    DateTime? transactedAt,
  }) : super(id: id, createdAt: createdAt, transactedAt: transactedAt);
}

@MappableClass(discriminatorValue: 'payment')
class PaymentEntry extends SplitEntry {
  final String title;

  final double amount;
  final Currency currency;

  final SplitSource source;
  final SplitSource target;

  PaymentEntry({
    required String id,
    required this.title,
    required this.amount,
    this.currency = Currency.euro,
    required this.source,
    required this.target,
    required DateTime createdAt,
    DateTime? transactedAt,
  }) : super(id: id, createdAt: createdAt, transactedAt: transactedAt);
}

@MappableClass(discriminatorValue: 'exchange')
class ExchangeEntry extends SplitEntry {
  final String title;

  final double sourceAmount;
  final Currency sourceCurrency;

  final double targetAmount;
  final Currency targetCurrency;

  final String potId;

  ExchangeEntry({
    required String id,
    required this.title,
    required this.sourceAmount,
    required this.sourceCurrency,
    required this.targetAmount,
    required this.targetCurrency,
    required this.potId,
    required DateTime createdAt,
    DateTime? transactedAt,
  })  : assert(sourceCurrency != targetCurrency),
        super(id: id, createdAt: createdAt, transactedAt: transactedAt);
}

@MappableEnum()
enum ExpenseTargetType { percent, shares, amount }

@MappableClass(discriminatorKey: 'type')
class ExpenseTarget {
  final ExpenseTargetType type;
  final Map<String, double> amounts;

  const ExpenseTarget({this.amounts = const {}, required this.type});

  const ExpenseTarget.percent(Map<String, double> percentages)
      : amounts = percentages,
        type = ExpenseTargetType.percent;

  const ExpenseTarget.shares(Map<String, double> shares)
      : amounts = shares,
        type = ExpenseTargetType.shares;

  const ExpenseTarget.amounts(Map<String, double> amounts)
      // ignore: prefer_initializing_formals
      : amounts = amounts,
        type = ExpenseTargetType.amount;
}
