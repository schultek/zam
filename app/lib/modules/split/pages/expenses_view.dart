import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import 'edit_exchange_page.dart';
import 'edit_expense_page.dart';
import 'edit_payment_page.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var split = context.watch<AsyncValue<SplitState?>>(splitProvider).value;
    if (split == null) return Container();

    var entries = ([...split.entries.values]..sort()).reversed;
    return ThemedSurface(
      builder: (context, color) => ListView(
        key: const PageStorageKey<String>('expenses'),
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          for (var entry in entries)
            if (entry is ExpenseEntry)
              ListTile(
                leading: const Icon(Icons.shopping_basket),
                title: Text(entry.title),
                subtitle: Text(context.watch(splitSourceLabelProvider(entry.source))),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${entry.amount.toStringAsFixed(2)} ${entry.currency.symbol}',
                      style: context.theme.textTheme.bodyMedium,
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        dateFormat.format(entry.transactedAt ?? entry.createdAt),
                        style: context.theme.textTheme.caption,
                      ),
                    ),
                  ],
                ),
                tileColor: color,
                onTap: () async {
                  var logic = context.read(splitLogicProvider);
                  var result = await Navigator.of(context).push(EditExpensePage.route(entry));
                  if (result != null) {
                    logic.updateEntry(result);
                  }
                },
              )
            else if (entry is PaymentEntry)
              ListTile(
                leading: const Icon(Icons.payment),
                title: Text(entry.title),
                subtitle: Row(
                  children: [
                    Text(context.watch(splitSourceLabelProvider(entry.source))),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.arrow_right_alt,
                      color: context.onSurfaceColor.withOpacity(0.8),
                    ),
                    const SizedBox(width: 5),
                    Text(context.watch(splitSourceLabelProvider(entry.target))),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${entry.amount.toStringAsFixed(2)} ${entry.currency.symbol}',
                      style: context.theme.textTheme.bodyMedium,
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        dateFormat.format(entry.transactedAt ?? entry.createdAt),
                        style: context.theme.textTheme.caption,
                      ),
                    ),
                  ],
                ),
                tileColor: color,
                onTap: () async {
                  var logic = context.read(splitLogicProvider);
                  var result = await Navigator.of(context).push(EditPaymentPage.route(entry));
                  if (result != null) {
                    logic.updateEntry(result);
                  }
                },
              )
            else if (entry is ExchangeEntry)
              ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: Text(entry.title),
                subtitle: Row(
                  children: [
                    Text(context.watch(splitSourceLabelProvider(SplitSource.pot(entry.potId)))),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${entry.sourceAmount.toStringAsFixed(2)} ${entry.sourceCurrency.symbol}',
                          style: context.theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.arrow_right_alt,
                          color: context.onSurfaceColor.withOpacity(0.8),
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${entry.targetAmount.toStringAsFixed(2)} ${entry.targetCurrency.symbol}',
                          style: context.theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        dateFormat.format(entry.transactedAt ?? entry.createdAt),
                        style: context.theme.textTheme.caption,
                      ),
                    ),
                  ],
                ),
                tileColor: color,
                onTap: () async {
                  var logic = context.read(splitLogicProvider);
                  var result = await Navigator.of(context).push(EditExchangePage.route(entry));
                  if (result != null) {
                    logic.updateEntry(result);
                  }
                },
              ),
        ],
      ),
    );
  }
}
