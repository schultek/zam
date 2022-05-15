import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import 'balances_view.dart';
import 'expenses_view.dart';
import 'new_exchange_page.dart';
import 'new_expense_page.dart';
import 'new_payment_page.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({Key? key}) : super(key: key);

  @override
  _SplitPageState createState() => _SplitPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const SplitPage());
  }
}

class _SplitPageState extends State<SplitPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.tr.split),
          bottom: TabBar(
            tabs: [Tab(text: context.tr.balances), Tab(text: context.tr.expenses)],
          ),
        ),
        body: const TabBarView(
          children: [
            BalancesView(),
            ExpensesView(),
          ],
        ),
        floatingActionButton: SpeedDial(
          children: [
            _childOption(
              icon: Icons.currency_exchange,
              title: context.tr.new_exchange,
              subtitle: context.tr.new_exchange_desc,
              onTap: () async {
                var result = await Navigator.of(context).push(NewExchangePage.route());
                if (result != null) {
                  context.read(splitLogicProvider).addEntry(result);
                }
              },
            ),
            _childOption(
              icon: Icons.payment,
              title: context.tr.new_payment,
              subtitle: context.tr.new_payment_desc,
              onTap: () async {
                var result = await Navigator.of(context).push(NewPaymentPage.route());
                if (result != null) {
                  context.read(splitLogicProvider).addEntry(result);
                }
              },
            ),
            _childOption(
              icon: Icons.shopping_basket,
              title: context.tr.new_expense,
              subtitle: context.tr.new_expense_desc,
              onTap: () async {
                var result = await Navigator.of(context).push(NewExpensePage.route());
                if (result != null) {
                  context.read(splitLogicProvider).addEntry(result);
                }
              },
            ),
          ],
          child: const Icon(Icons.add),
          foregroundColor: context.theme.colorScheme.onPrimary,
          backgroundColor: context.theme.colorScheme.primary,
          spacing: 20,
          childrenButtonSize: const Size(65, 65),
          spaceBetweenChildren: 8,
        ),
      ),
    );
  }

  SpeedDialChild _childOption(
      {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return SpeedDialChild(
      child: Icon(icon),
      backgroundColor: context.theme.colorScheme.onPrimary,
      foregroundColor: context.theme.colorScheme.primary,
      labelWidget: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: context.theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              subtitle,
              style: context.theme.textTheme.caption!.copyWith(color: context.onSurfaceColor.withOpacity(0.4)),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
