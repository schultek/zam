import 'package:flutter/material.dart';

import '../split.module.dart';
import '../widgets/amount_section.dart';
import '../widgets/date_section.dart';
import '../widgets/edit_entry_page.dart';
import '../widgets/targets_section.dart';

class EditExchangePage extends StatefulWidget {
  const EditExchangePage({this.entry, Key? key}) : super(key: key);

  final ExchangeEntry? entry;

  @override
  State<EditExchangePage> createState() => _EditExchangePageState();

  static Route<ExchangeEntry> route([ExchangeEntry? entry]) {
    return MaterialPageRoute(builder: (context) => EditExchangePage(entry: entry));
  }
}

class _EditExchangePageState extends State<EditExchangePage> {
  String? title;

  double sourceAmount = 0;
  Currency sourceCurrency = Currency.euro;

  double targetAmount = 0;
  Currency? targetCurrency;

  String? potId;

  DateTime createdAt = DateTime.now();
  DateTime? transactedAt;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      title = widget.entry!.title;
      sourceAmount = widget.entry!.sourceAmount;
      sourceCurrency = widget.entry!.sourceCurrency;
      targetAmount = widget.entry!.targetAmount;
      targetCurrency = widget.entry!.targetCurrency;
      potId = widget.entry!.potId;
      createdAt = widget.entry!.createdAt;
      transactedAt = widget.entry!.transactedAt;
    }
  }

  bool get isValid {
    return title != null &&
        title!.isNotEmpty &&
        sourceAmount != 0 &&
        targetAmount != 0 &&
        targetCurrency != null &&
        sourceCurrency != targetCurrency &&
        potId != null;
  }

  @override
  Widget build(BuildContext context) {
    return EditEntryPage<ExchangeEntry>(
      pageTitle: widget.entry != null ? context.tr.edit_exchange : context.tr.new_exchange,
      entry: widget.entry,
      title: title,
      onTitleChanged: (value) {
        setState(() => title = value);
      },
      entryValid: isValid,
      onSave: () {
        Navigator.of(context).pop(ExchangeEntry(
          id: widget.entry?.id ?? generateRandomId(8),
          title: title!,
          sourceAmount: sourceAmount,
          sourceCurrency: sourceCurrency,
          targetAmount: targetAmount,
          targetCurrency: targetCurrency!,
          potId: potId!,
          createdAt: createdAt,
          transactedAt: transactedAt,
        ));
      },
      children: [
        AmountSection(
          title: context.tr.from,
          amount: sourceAmount,
          currency: sourceCurrency,
          onAmountChanged: (value) {
            setState(() => sourceAmount = value);
          },
          onCurrencyChanged: (value) {
            setState(() => sourceCurrency = value);
          },
        ),
        AmountSection(
          title: context.tr.to,
          amount: targetAmount,
          currency: targetCurrency,
          onAmountChanged: (value) {
            setState(() => targetAmount = value);
          },
          onCurrencyChanged: (value) {
            setState(() => targetCurrency = value);
          },
        ),
        TargetsSection.fromPot(
          potId: potId,
          onPotChanged: (value) {
            setState(() => potId = value);
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
