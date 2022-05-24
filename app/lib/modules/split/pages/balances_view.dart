import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import '../widgets/new_pot_dialog.dart';
import '../widgets/pot_icon.dart';

class BalancesView extends StatelessWidget {
  const BalancesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var split = context.watch<AsyncValue<SplitState?>>(splitProvider).value;
    if (split == null) return Container();

    var balances = split.balances;
    var potBalances = balances.entries.where((b) => b.key.isPot);
    return ThemedSurface(
      builder: (context, color) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          SettingsSection(children: [
            for (var entry in potBalances)
              ListTile(
                leading: PotIcon(id: entry.key.id),
                title: Text(context.watch(splitSourceLabelProvider(entry.key))),
                trailing: Text(
                  entry.value.toPrintString(),
                  style: context.theme.textTheme.bodyMedium,
                ),
                tileColor: color,
              ),
          ]),
          SettingsSection(children: [
            for (var entry in context.watch(selectedGroupProvider)!.users.entries)
              ListTile(
                leading: UserAvatar(id: entry.key, small: true),
                title: Text(context.watch(splitSourceLabelProvider(SplitSource.user(entry.key)))),
                trailing: Text(
                  (balances[SplitSource.user(entry.key)] ?? SplitBalance.zeroEuros).toPrintString(),
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
                  onPressed: () async {
                    var pot = await NewPotDialog.show(context);
                    if (pot != null) {
                      context.read(splitLogicProvider).addNewPot(pot);
                    }
                  },
                ),
              ),
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
                  child: Text(split.showBilling ? context.tr.hide_billing : context.tr.show_billing),
                  onPressed: () async {
                    context.read(splitLogicProvider).toggleBilling();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
