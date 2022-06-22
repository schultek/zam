import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';

class BalancesList extends StatelessWidget {
  const BalancesList({this.showTitle = false, this.params, Key? key}) : super(key: key);

  final bool showTitle;
  final BalancesListParams? params;

  @override
  Widget build(BuildContext context) {
    var balances = context.watch(balancesProvider);
    var balanceEntries = balances.entries;

    if (!(params?.showZeroBalances ?? true)) {
      print(balanceEntries.map((e) => e.value.amounts).toList());
      balanceEntries = balanceEntries.where((e) => e.value.amounts.values.any((v) => v != 0));
    }

    var potBalances = balanceEntries.where((b) => b.key.isPot);
    var userBalances = balanceEntries.where((b) => b.key.isUser);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 20),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          if (showTitle)
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 16.0, bottom: 20),
              child: Text(context.tr.balances, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          if (params?.showPots ?? true)
            for (var entry in potBalances)
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Icon(Icons.savings, color: context.onSurfaceColor),
                ),
                title: Text(
                  context.watch(splitSourceLabelProvider(entry.key)),
                  style: TextStyle(color: context.onSurfaceColor),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
                trailing: Text(
                  entry.value.toPrintString(),
                  style: context.theme.textTheme.bodyMedium!.copyWith(color: context.onSurfaceColor),
                ),
                minLeadingWidth: 20,
              ),
          for (var entry in userBalances)
            ListTile(
              leading: UserAvatar(id: entry.key.id, small: true),
              title: Text(
                context.watch(splitSourceLabelProvider(entry.key)),
                style: TextStyle(color: context.onSurfaceColor),
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              trailing: Text(
                entry.value.toPrintString(),
                style: context.theme.textTheme.bodyMedium!.copyWith(color: context.onSurfaceColor),
              ),
              minLeadingWidth: 20,
            ),
        ].intersperse(const Divider(height: 0)).toList(),
      ),
    );
  }
}
