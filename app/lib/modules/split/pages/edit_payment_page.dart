import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import '../widgets/pot_icon.dart';
import '../widgets/select_source_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry != null ? context.tr.edit_payment : context.tr.new_payment),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ThemedSurface(
            preference: ColorPreference(useHighlightColor: !context.groupTheme.dark),
            builder: (context, _) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
              child: TextFormField(
                initialValue: title,
                autofocus: true,
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
          SettingsSection(children: [
            ListTile(
              title: Row(
                children: [
                  Text(context.tr.amount),
                  Expanded(
                    child: TextFormField(
                      initialValue: amount.toStringAsFixed(2),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixText: currency.symbol,
                        filled: false,
                      ),
                      textAlign: TextAlign.end,
                      onChanged: (value) {
                        setState(() {
                          amount = double.parse(value);
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
                  currency = value;
                });
              },
              child: ListTile(
                title: Text(context.tr.currency),
                trailing: Text('${currency.symbol} (${currency.name.toUpperCase()})'),
              ),
            ),
          ]),
          SettingsSection(children: [
            ListTile(
              title: Text(context.tr.from),
              trailing: source != null
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(context.watch(splitSourceLabelProvider(source!))),
                      const SizedBox(width: 10),
                      if (source!.isUser) UserAvatar(id: source!.id, small: true) else PotIcon(id: source!.id),
                    ])
                  : null,
              onTap: () async {
                var source = await SelectSourceDialog.show(context, this.source);
                if (source != null) {
                  setState(() {
                    this.source = source;
                  });
                }
              },
            ),
            ListTile(
              title: Text(context.tr.to),
              trailing: target != null
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(context.watch(splitSourceLabelProvider(target!))),
                      const SizedBox(width: 10),
                      if (target!.isUser) UserAvatar(id: target!.id, small: true) else PotIcon(id: target!.id),
                    ])
                  : null,
              onTap: () async {
                var target = await SelectSourceDialog.show(context, this.target);
                if (target != null) {
                  setState(() {
                    this.target = target;
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
