library split_module;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/general/l10n_provider.dart';
import '../module.dart';
import 'pages/edit_exchange_page.dart';
import 'pages/edit_expense_page.dart';
import 'pages/edit_payment_page.dart';
import 'pages/split_page.dart';
import 'widgets/balances_list.dart';
import 'widgets/pot_icon.dart';
import 'widgets/select_source_dialog.dart';

export '../module.dart';

part 'elements/balance_action_element.dart';
part 'elements/balance_content_element.dart';
part 'elements/balances_list_content_element.dart';
part 'elements/new_exchange_action_element.dart';
part 'elements/new_expense_action_element.dart';
part 'elements/new_payment_action_element.dart';
part 'elements/split_action_element.dart';
part 'elements/split_element.dart';
part 'split.models.dart';
part 'split.provider.dart';

class SplitModule extends ModuleBuilder {
  SplitModule() : super('split');

  @override
  String getName(BuildContext context) => context.tr.split;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'split_new_expense_action': NewExpenseActionElement(),
        'split_new_payment_action': NewPaymentActionElement(),
        'split_new_exchange_action': NewExchangeActionElement(),
        'split_action': SplitActionElement(),
        'split_balance_list': BalancesListContentSegment(),
        'balance_action_element': BalanceActionElement(),
        'balance_content_element': BalanceContentElement(),
        'split': SplitElement(),
      };

  @override
  Iterable<Widget>? getSettings(BuildContext context) sync* {
    yield ListTile(
      title: Text(context.tr.open_split),
      onTap: () => Navigator.of(context).push(SplitPage.route()),
    );
  }
}
