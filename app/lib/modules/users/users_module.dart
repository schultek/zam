library users_module;

import 'dart:async';

import 'package:flutter/material.dart';

import '../module.dart';
import 'pages/users_page.dart';

export '../module.dart';

part 'elements/users_action_element.dart';
part 'elements/users_content_element.dart';

class UsersModule extends ModuleBuilder {
  UsersModule() : super('users');

  @override
  String getName(BuildContext context) => context.tr.users;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'users': UsersContentElement(),
        'users_action': UsersActionElement(),
      };

  @override
  ModuleSettings? getSettings(BuildContext context) {
    return ModuleSettings([
      ListTile(
        title: Text(context.tr.open_users),
        onTap: () => Navigator.of(context).push(UsersPage.route()),
      ),
    ]);
  }
}
