import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';

class BalancesView extends StatelessWidget {
  const BalancesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var split = context.watch<AsyncValue<SplitState?>>(splitProvider).value;
    if (split == null) return Container();

    var balances = split.balances;
    var potBalances = balances.entries.where((b) => b.key.type == SplitSourceType.pot);
    var userBalances = balances.entries.where((b) => b.key.type == SplitSourceType.user);
    return ThemedSurface(
      builder: (context, color) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          SettingsSection(children: [
            for (var entry in potBalances)
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(Icons.savings),
                ),
                title: Text(context.watch(splitSourceLabelProvider(entry.key))),
                trailing: Text(
                  entry.value.toPrintString(),
                  style: context.theme.textTheme.bodyMedium,
                ),
                tileColor: color,
              ),
          ]),
          SettingsSection(children: [
            for (var entry in userBalances)
              ListTile(
                leading: UserAvatar(id: entry.key.id, small: true),
                title: Text(context.watch(splitSourceLabelProvider(entry.key))),
                trailing: Text(
                  entry.value.toPrintString(),
                  style: context.theme.textTheme.bodyMedium,
                ),
                tileColor: color,
              ),
          ]),
          if (context.watch(isOrganizerProvider))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: context.theme.colorScheme.onPrimary,
                    onPrimary: context.theme.colorScheme.primary,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                  child: Text(context.tr.new_pot),
                  onPressed: () => showNewPotDialog(context),
                ),
              ),
            )
        ],
      ),
    );
  }

  void showNewPotDialog(BuildContext context) async {
    var potName = await showDialog<String>(
      context: context,
      builder: (context) {
        String? name;
        return AlertDialog(
          title: Text(context.tr.new_pot),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            onChanged: (value) {
              name = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(name);
              },
              child: Text(context.tr.create),
            ),
          ],
        );
      },
    );

    if (potName != null) {
      context.read(splitLogicProvider).addNewPot(potName);
    }
  }
}
