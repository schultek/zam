import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import '../widgets/pot_icon.dart';

class BillingView extends StatelessWidget {
  const BillingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var split = context.watch<AsyncValue<SplitState?>>(splitProvider).value;
    if (split == null) return Container();

    var billing = split.billing;
    return ThemedSurface(
      builder: (context, color) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          SettingsSection(children: [
            for (var entry in billing)
              ListTile(
                title: Row(
                  children: [
                    if (entry.from.isUser)
                      UserAvatar(id: entry.from.id, small: true)
                    else
                      Center(child: PotIcon(id: entry.from.id)),
                    const SizedBox(width: 8),
                    Text(context.watch(splitSourceLabelProvider(entry.from))),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right),
                    const SizedBox(width: 4),
                    if (entry.to.isUser)
                      UserAvatar(id: entry.to.id, small: true)
                    else
                      Center(child: PotIcon(id: entry.to.id)),
                    const SizedBox(width: 8),
                    Text(context.watch(splitSourceLabelProvider(entry.to))),
                  ],
                ),
                trailing: Text(
                  '${entry.amount.toStringAsFixed(2)} ${entry.currency.symbol}',
                  style: context.theme.textTheme.bodyMedium,
                ),
                tileColor: color,
              ),
          ]),
        ],
      ),
    );
  }
}
