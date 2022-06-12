import 'package:flutter/material.dart';

import '../split.module.dart';
import '../widgets/amount_section.dart';
import '../widgets/date_section.dart';
import '../widgets/edit_entry_page.dart';
import '../widgets/targets_section.dart';

class EditPaymentPage extends StatefulWidget {
  const EditPaymentPage({this.entry, Key? key}) : super(key: key);

  final PaymentEntry? entry;

  @override
  State<EditPaymentPage> createState() => _EditPaymentPageState();

  static Route<PaymentEntry> route([PaymentEntry? entry]) {
    return MaterialPageRoute(builder: (context) => EditPaymentPage(entry: entry));
  }
}

class _EditPaymentPageState extends State<EditPaymentPage> {
  String? title;

  double amount = 0;
  Currency currency = Currency.euro;

  SplitSource? source;
  SplitSource? target;

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
    return title != null && title!.isNotEmpty && amount != 0 && source != null && target != null && source != target;
  }

  @override
  Widget build(BuildContext context) {
    return EditEntryPage<PaymentEntry>(
      pageTitle: widget.entry != null ? context.tr.edit_payment : context.tr.new_payment,
      entry: widget.entry,
      title: title,
      onTitleChanged: (value) {
        setState(() => title = value);
      },
      entryValid: isValid,
      onSave: () {
        Navigator.of(context).pop(PaymentEntry(
          id: widget.entry?.id ?? generateRandomId(8),
          title: title!,
          amount: amount,
          currency: currency,
          source: source!,
          target: target!,
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
        TargetsSection.fromToSource(
          from: source,
          to: target,
          onFromChanged: (source) {
            setState(() => this.source = source);
          },
          onToChanged: (target) {
            setState(() => this.target = target);
          },
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
