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

  SplitState({this.pots = const {}, this.entries = const {}}) {
    balances = calcBalances();
  }

  late final Map<SplitSource, SplitBalance> balances;

  Map<SplitSource, SplitBalance> calcBalances() {
    var balances = <SplitSource, SplitBalance>{
      ...pots.map((k, v) => MapEntry(SplitSource(k, SplitSourceType.pot), SplitBalance.zeroEuros))
    };
    var entries = [...this.entries.values]..sort();

    void addToBalance(SplitSource source, double amount, Currency currency) {
      var balance = balances[source] ??= SplitBalance({});
      balance.amounts[currency] = (balance.amounts[currency] ?? 0) + amount;
    }

    for (var entry in entries) {
      if (entry is ExpenseEntry) {
        if (entry.source.type == SplitSourceType.user) {
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
        if (entry.source.type == SplitSourceType.user) {
          addToBalance(entry.source, entry.amount, entry.currency);
        } else {
          addToBalance(entry.source, -entry.amount, entry.currency);
        }
        if (entry.target.type == SplitSourceType.user) {
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
}

class SplitBalance {
  Map<Currency, double> amounts;

  SplitBalance(this.amounts);

  static final zeroEuros = SplitBalance({Currency.euro: 0});

  String toPrintString() {
    var entries = amounts.entries.where((e) => e.value != 0);
    if (entries.isEmpty && amounts.entries.isNotEmpty) entries = amounts.entries.take(1);
    return entries.map((e) => '${e.value.toStringAsFixed(2)} ${e.key.symbol}').join(', ');
  }
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

  ExpenseEntry({
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
