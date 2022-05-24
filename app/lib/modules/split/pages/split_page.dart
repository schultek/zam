import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import 'balances_view.dart';
import 'billing_view.dart';
import 'edit_exchange_page.dart';
import 'edit_expense_page.dart';
import 'edit_payment_page.dart';
import 'expenses_view.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({Key? key}) : super(key: key);

  @override
  _SplitPageState createState() => _SplitPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const SplitPage());
  }
}

final _splitTabIndexProvider = StateProvider((ref) => 0);

class _SplitPageState extends State<SplitPage> with TickerProviderStateMixin {
  TabController? controller;

  void updateTabController(bool showBilling) {
    if (controller?.length == (showBilling ? 3 : 2)) {
      return;
    }
    setState(() {
      controller?.dispose();
      controller =
          TabController(initialIndex: context.read(_splitTabIndexProvider), length: showBilling ? 3 : 2, vsync: this)
            ..addListener(() {
              context.read(_splitTabIndexProvider.notifier).state = controller!.index;
            });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var showBilling = context.watch(splitProvider.select((split) => split.value?.showBilling ?? false));
    updateTabController(showBilling);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.split),
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(text: context.tr.balances),
            Tab(text: context.tr.expenses),
            if (showBilling) Tab(text: context.tr.billing),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          const BalancesView(),
          const ExpensesView(),
          if (showBilling) const BillingView(),
        ],
      ),
      floatingActionButton: SpeedDial(
        children: [
          _childOption(
            icon: Icons.currency_exchange,
            title: context.tr.new_exchange,
            subtitle: context.tr.new_exchange_desc,
            onTap: () async {
              Future.delayed(const Duration(milliseconds: 100), () async {
                var logic = context.read(splitLogicProvider);
                var result = await Navigator.of(context).push(EditExchangePage.route());
                if (result != null) {
                  logic.updateEntry(result);
                }
              });
            },
          ),
          _childOption(
            icon: Icons.payment,
            title: context.tr.new_payment,
            subtitle: context.tr.new_payment_desc,
            onTap: () async {
              Future.delayed(const Duration(milliseconds: 100), () async {
                var logic = context.read(splitLogicProvider);
                var result = await Navigator.of(context).push(EditPaymentPage.route());
                if (result != null) {
                  logic.updateEntry(result);
                }
              });
            },
          ),
          _childOption(
            icon: Icons.shopping_basket,
            title: context.tr.new_expense,
            subtitle: context.tr.new_expense_desc,
            onTap: () async {
              Future.delayed(const Duration(milliseconds: 100), () async {
                var logic = context.read(splitLogicProvider);
                var result = await Navigator.of(context).push(EditExpensePage.route());
                if (result != null) {
                  logic.updateEntry(result);
                }
              });
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
    );
  }

  SpeedDialChild _childOption(
      {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return SpeedDialChild(
      key: ValueKey(title),
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
