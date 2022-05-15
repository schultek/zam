part of split_module;

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
  final List<SplitEntry> entries;

  SplitState({this.pots = const {}, this.entries = const []}) {
    balances = calcBalances();
  }

  late final Map<SplitSource, SplitBalance> balances;

  Map<SplitSource, SplitBalance> calcBalances() {
    var balances = <SplitSource, SplitBalance>{
      ...pots.map((k, v) => MapEntry(SplitSource(k, SplitSourceType.pot), SplitBalance({Currency.euro: 0})))
    };
    var entries = [...this.entries]..sort();

    void addToBalance(SplitSource source, double amount, Currency currency) {
      var balance = balances[source] ??= SplitBalance({});
      balance.amounts[currency] = (balance.amounts[currency] ?? 0) + amount;
    }

    for (var entry in entries) {
      if (entry is ExpenseEntry) {
        addToBalance(entry.source, entry.amount, entry.currency);

        var target = entry.target;
        if (target is PercentageExpenseTarget) {
          for (var e in target.percentages.entries) {
            addToBalance(e.key, -entry.amount * e.value / 100, entry.currency);
          }
        } else if (target is SharesExpenseTarget) {
          var sumShares = target.shares.values.reduce((a, b) => a + b);
          for (var e in target.shares.entries) {
            addToBalance(e.key, -entry.amount * e.value / sumShares, entry.currency);
          }
        }
      } else if (entry is PaymentEntry) {
        addToBalance(entry.source, entry.amount, entry.currency);
        addToBalance(entry.target, -entry.amount, entry.currency);
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

  String toPrintString() {
    return amounts.entries.map((e) => '${e.value} ${e.key.symbol}').join(', ');
  }
}

@MappableClass()
class SplitPot {
  String name;

  SplitPot({required this.name});
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
  final double amount;
  final Currency currency;

  final SplitSource source;
  final ExpenseTarget target;

  ExpenseEntry({
    required String id,
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
  final double amount;
  final Currency currency;

  final SplitSource source;
  final SplitSource target;

  PaymentEntry({
    required String id,
    required this.amount,
    this.currency = Currency.euro,
    required this.source,
    required this.target,
    required DateTime createdAt,
    DateTime? transactedAt,
  }) : super(id: id, createdAt: createdAt, transactedAt: transactedAt);
}

@MappableClass(discriminatorValue: 'payment')
class ExchangeEntry extends SplitEntry {
  final double sourceAmount;
  final Currency sourceCurrency;

  final double targetAmount;
  final Currency targetCurrency;

  final String potId;

  ExchangeEntry({
    required String id,
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

@MappableClass(discriminatorKey: 'type')
class ExpenseTarget {
  const ExpenseTarget();

  const factory ExpenseTarget.percent(Map<SplitSource, double> percentages) = PercentageExpenseTarget;
  const factory ExpenseTarget.shares(Map<SplitSource, int> shares) = SharesExpenseTarget;
}

@MappableClass(discriminatorValue: 'precent')
class PercentageExpenseTarget extends ExpenseTarget {
  final Map<SplitSource, double> percentages;

  const PercentageExpenseTarget(this.percentages);
}

@MappableClass(discriminatorValue: 'shares')
class SharesExpenseTarget extends ExpenseTarget {
  final Map<SplitSource, int> shares;

  const SharesExpenseTarget(this.shares);
}
