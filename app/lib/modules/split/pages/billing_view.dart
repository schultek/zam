import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import '../widgets/edit_rates_dialog.dart';
import '../widgets/pot_icon.dart';

class BillingView extends StatelessWidget {
  const BillingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var split = context.watch<AsyncValue<SplitState?>>(splitProvider).value;
    if (split == null) return Container();

    var billing = split.billing;
    var stats = split.stats;
    var spendings = split.stats.userSpendings.entries.toList()
      ..sort((a, b) => b.value.amounts.entries
          .map((e) => e.value.compareTo(a.value.amounts[e.key] ?? 0))
          .fold(0, (sum, e) => sum + e));
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingsSection(
          title: context.tr.depts,
          children: [
            for (var entry in billing)
              ListTile(
                title: Row(
                  children: [
                    if (entry.from.isUser)
                      UserAvatar(id: entry.from.id, small: true)
                    else
                      Center(child: PotIcon(id: entry.from.id)),
                    const SizedBox(width: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 40),
                      child: Text(context.watch(splitSourceLabelProvider(entry.from))),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right),
                    const SizedBox(width: 8),
                    if (entry.to.isUser)
                      UserAvatar(id: entry.to.id, small: true)
                    else
                      Center(child: PotIcon(id: entry.to.id)),
                    const SizedBox(width: 10),
                    Text(context.watch(splitSourceLabelProvider(entry.to))),
                  ],
                ),
                trailing: Text(
                  '${entry.amount.toStringAsFixed(2)} ${entry.currency.symbol}',
                  style: context.theme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
        SettingsSection(
          title: context.tr.costs,
          children: [
            ListTile(
              title: Text(context.tr.total),
              leading: const Icon(Icons.functions),
              trailing: Text(
                stats.totalSpendings.toPrintString(),
                style: context.theme.textTheme.bodyMedium,
              ),
            ),
            for (var spending in spendings)
              ListTile(
                leading: UserAvatar(id: spending.key, small: true),
                title: Text(context.watch(splitSourceLabelProvider(SplitSource.user(spending.key)))),
                trailing: Text(
                  spending.value.toPrintString(),
                  style: context.theme.textTheme.bodyMedium,
                ),
              ),
          ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
                child: split.billingRates == null
                    ? Text(context.tr.set_exchange_rates)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.currency_exchange, size: 18),
                          const SizedBox(width: 6),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var rate in split.billingRates!.rates.entries)
                                Text('${rate.value}${rate.key.symbol} -> 1${split.billingRates!.target.symbol}'),
                            ],
                          ),
                        ],
                      ),
                onPressed: () async {
                  var rates = await EditRatesDialog.show(context, split.billingRates);

                  if (rates != null) {
                    if (rates.rates.isEmpty) {
                      context.read(splitLogicProvider).setBillingRates(null);
                    } else {
                      context.read(splitLogicProvider).setBillingRates(rates);
                    }
                  }
                },
              ),
            ),
          ),
      ],
    );
  }
}
