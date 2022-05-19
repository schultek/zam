import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import '../widgets/pot_icon.dart';
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
          child: ThemedSurface(
            preference: ColorPreference(useHighlightColor: !context.groupTheme.dark),
            builder: (context, _) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
              child: TextFormField(
                initialValue: title,
                decoration: InputDecoration(
                  hintText: context.tr.title,
                  hintStyle: TextStyle(color: context.onSurfaceColor.withOpacity(0.5)),
                  border: InputBorder.none,
                  filled: false,
                ),
                cursorColor: context.onSurfaceHighlightColor,
                style: context.theme.textTheme.bodyLarge!.copyWith(fontSize: 22, color: context.onSurfaceColor),
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
            ),
          ),
        ),
        actions: [
          ThemedSurface(
            preference: ColorPreference(useHighlightColor: !context.groupTheme.dark),
            builder: (context, _) => TextButton(
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
              child: Text(
                context.tr.save,
                style: TextStyle(color: context.onSurfaceHighlightColor.withOpacity(isValid ? 1 : 0.5)),
              ),
            ),
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
                      PotIcon(id: potId!),
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
          if (widget.entry != null && context.watch(isOrganizerProvider))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: context.theme.colorScheme.onPrimary,
                    onPrimary: context.theme.colorScheme.primary,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                  child: Text(context.tr.delete),
                  onPressed: () async {
                    var shouldDelete = await SettingsDialog.confirm(
                      context,
                      text: context.tr.confirm_delete_entry,
                      confirm: context.tr.delete,
                    );
                    if (shouldDelete) {
                      Navigator.of(context).pop();
                      context.read(splitLogicProvider).deleteEntry(widget.entry!.id);
                    }
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}
