import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import '../widgets/pot_icon.dart';
import '../widgets/select_source_dialog.dart';
import '../widgets/select_target_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry != null ? context.tr.edit_expense : context.tr.new_expense),
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
                      if (target.amounts.isEmpty) {
                        target = ExpenseTarget.shares({
                          for (var user in context.read(selectedGroupProvider)!.users.keys)
                            if (source!.type != SplitSourceType.user || user != source!.id) user: 1,
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
                      if (source!.type == SplitSourceType.user)
                        UserAvatar(id: source!.id, small: true)
                      else
                        PotIcon(id: source!.id),
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
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                if (target.amounts.isEmpty)
                  Text(
                      '${context.watch(selectedGroupProvider.select((g) => g?.users.length ?? 0)) - (source?.type == SplitSourceType.user ? 1 : 0)} ${context.tr.persons}')
                else if (target.amounts.length == 1) ...[
                  Text(context.watch(groupUserByIdProvider(target.amounts.keys.first))?.nickname ??
                      context.tr.anonymous),
                  const SizedBox(width: 10),
                  UserAvatar(id: target.amounts.keys.first, small: true),
                ] else
                  Text('${target.amounts.length} ${context.tr.persons}'),
              ]),
              onTap: () async {
                var target = await SelectTargetDialog.show(context, this.target, amount, currency);
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
