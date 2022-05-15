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
    return ThemedSurface(
      builder: (context, color) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          for (var entry in balances.entries)
            ListTile(
              leading: Icon(entry.key.type == SplitSourceType.user ? Icons.account_circle : Icons.savings),
              title: Text(entry.key.type == SplitSourceType.user
                  ? context.watch(groupUserByIdProvider(entry.key.id))?.nickname ?? context.tr.anonymous
                  : split.pots[entry.key.id]!.name),
              trailing: Text(entry.value.toPrintString()),
              tileColor: color,
            ),
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
