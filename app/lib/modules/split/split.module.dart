library split_module;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../module.dart';
import 'pages/split_page.dart';

export '../module.dart';

part 'elements/split_element.dart';
part 'split.models.dart';
part 'split.provider.dart';

class SplitModule extends ModuleBuilder {
  SplitModule() : super('split');

  @override
  String getName(BuildContext context) => context.tr.split;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        // 'split_new_expense_action': NewExpenseActionElement(),
        // 'balances': BalancesElement(),
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
