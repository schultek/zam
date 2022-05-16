import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
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
    return title != null && title!.isNotEmpty && amount != 0 && source != null && target != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry != null ? context.tr.edit_payment : context.tr.new_payment),
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
            child: Text(context.tr.save),
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
                      if (source!.type == SplitSourceType.user)
                        UserAvatar(id: source!.id, small: true)
                      else
                        const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(Icons.savings),
                        ),
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
                      if (target!.type == SplitSourceType.user)
                        UserAvatar(id: target!.id, small: true)
                      else
                        const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(Icons.savings),
                        ),
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
        ],
      ),
    );
  }
}
