import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import '../widgets/select_source_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry != null ? context.tr.edit_exchange : context.tr.new_exchange),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
            child: TextFormField(
              initialValue: title,
              decoration: InputDecoration(
                hintText: context.tr.title,
                border: InputBorder.none,
                filled: false,
              ),
              style: context.theme.textTheme.bodyLarge!.copyWith(fontSize: 22),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: isValid
                ? () {
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
                  }
                : null,
            child: Text(context.tr.save),
          ),
        ],
      ),
      body: ListView(
        children: [
          SettingsSection(title: context.tr.from, children: [
            ListTile(
              title: Row(
                children: [
                  Text(context.tr.amount),
                  Expanded(
                    child: TextFormField(
                      initialValue: sourceAmount.toStringAsFixed(2),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixText: sourceCurrency.symbol,
                        filled: false,
                      ),
                      textAlign: TextAlign.end,
                      onChanged: (value) {
                        setState(() {
                          sourceAmount = double.parse(value);
                        });
                      },
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<Currency>(
              itemBuilder: (context) => [
                for (var currency in Currency.values)
                  PopupMenuItem(
                    value: currency,
                    child: Text('${currency.symbol} (${currency.name.toUpperCase()})'),
                  ),
              ],
              onSelected: (value) {
                setState(() {
                  sourceCurrency = value;
                });
              },
              child: ListTile(
                title: Text(context.tr.currency),
                trailing: Text('${sourceCurrency.symbol} (${sourceCurrency.name.toUpperCase()})'),
              ),
            ),
          ]),
          SettingsSection(title: context.tr.to, children: [
            ListTile(
              title: Row(
                children: [
                  Text(context.tr.amount),
                  Expanded(
                    child: TextFormField(
                      initialValue: targetAmount.toStringAsFixed(2),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixText: targetCurrency?.symbol,
                        filled: false,
                      ),
                      textAlign: TextAlign.end,
                      onChanged: (value) {
                        setState(() {
                          targetAmount = double.parse(value);
                        });
                      },
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<Currency>(
              itemBuilder: (context) => [
                for (var currency in Currency.values)
                  PopupMenuItem(
                    value: currency,
                    child: Text('${currency.symbol} (${currency.name.toUpperCase()})'),
                  ),
              ],
              onSelected: (value) {
                setState(() {
                  targetCurrency = value;
                });
              },
              child: ListTile(
                title: Text(context.tr.currency),
                trailing: targetCurrency != null
                    ? Text('${targetCurrency!.symbol} (${targetCurrency!.name.toUpperCase()})')
                    : null,
              ),
            ),
          ]),
          SettingsSection(children: [
            ListTile(
              title: Text(context.tr.from),
              trailing: potId != null
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(context.watch(splitSourceLabelProvider(SplitSource.pot(potId!)))),
                      const SizedBox(width: 10),
                      const Padding(
                        padding: EdgeInsets.all(3),
                        child: Icon(Icons.savings),
                      ),
                    ])
                  : null,
              onTap: () async {
                var source = await SelectSourceDialog.show(context, potId != null ? SplitSource.pot(potId!) : null,
                    allowUsers: false);
                if (source != null) {
                  setState(() {
                    potId = source.id;
                  });
                }
              },
            ),
          ]),
          SettingsSection(children: [
            ListTile(
              title: Text(context.tr.date),
              trailing: transactedAt != null ? Text(dateFormat.format(transactedAt!)) : null,
              onTap: () async {
                var date = await showDatePicker(
                  context: context,
                  initialDate: transactedAt ?? createdAt,
                  lastDate: createdAt,
                  useRootNavigator: false,
                  firstDate: DateTime(2000),
                );

                if (date != null) {
                  setState(() {
                    transactedAt = date;
                  });
                }
              },
            ),
          ]),
        ],
      ),
    );
  }
}
