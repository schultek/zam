import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import '../widgets/amount_section.dart';
import '../widgets/date_section.dart';
import '../widgets/edit_entry_page.dart';
import '../widgets/targets_section.dart';

class EditExpensePage extends StatefulWidget {
  const EditExpensePage({this.entry, Key? key}) : super(key: key);

  final ExpenseEntry? entry;

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();

  static Route<ExpenseEntry> route([ExpenseEntry? entry]) {
    return MaterialPageRoute(builder: (context) => EditExpensePage(entry: entry));
  }
}

class _EditExpensePageState extends State<EditExpensePage> {
  String? title;

  double amount = 0;
  Currency currency = Currency.euro;

  SplitSource? source;
  ExpenseTarget target = const ExpenseTarget.percent({});

  DateTime createdAt = DateTime.now();
  DateTime? transactedAt;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      title = widget.entry!.title;
      amount = widget.entry!.amount;
      currency = widget.entry!.currency;
      source = widget.entry!.source;
      target = widget.entry!.target;
      createdAt = widget.entry!.createdAt;
      transactedAt = widget.entry!.transactedAt;
    }
  }

  bool get isValid {
    return title != null && title!.isNotEmpty && amount != 0 && source != null;
  }

  @override
  Widget build(BuildContext context) {
    return EditEntryPage<ExpenseEntry>(
      pageTitle: widget.entry != null ? context.tr.edit_exchange : context.tr.new_exchange,
      entry: widget.entry,
      title: title,
      onTitleChanged: (value) {
        setState(() => title = value);
      },
      entryValid: isValid,
      onSave: () {
        if (target.amounts.isEmpty) {
          target = ExpenseTarget.shares({
            for (var user in context.read(selectedGroupProvider)!.users.keys) user: 1,
          });
        }
        Navigator.of(context).pop(ExpenseEntry(
          id: widget.entry?.id ?? generateRandomId(8),
          title: title!,
          amount: amount,
          currency: currency,
          source: source!,
          target: target,
          createdAt: createdAt,
          transactedAt: transactedAt,
        ));
      },
      children: [
        AmountSection(
          amount: amount,
          currency: currency,
          onAmountChanged: (value) {
            setState(() => amount = value);
          },
          onCurrencyChanged: (value) {
            setState(() => currency = value);
          },
        ),
        TargetsSection.toTargets(
          source: source,
          target: target,
          onSourceChanged: (value) {
            setState(() => source = value);
          },
          onTargetsChanged: (value) {
            setState(() => target = value);
          },
          amount: amount,
          currency: currency,
        ),
        DateSection(
          transactedAt: transactedAt,
          createdAt: createdAt,
          showCreatedAt: widget.entry != null,
          onTransactedDateChanged: (date) {
            setState(() => transactedAt = date);
          },
        ),
      ],
    );
  }
}
