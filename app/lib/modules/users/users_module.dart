import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/simple_card.dart';
import 'pages/users_page.dart';

class UsersModule extends ModuleBuilder<ContentSegment> {
  UsersModule() : super('users');

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'users': buildUsers,
        'users_action': buildUsersAction,
      };

  FutureOr<ContentSegment?> buildUsers(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => const SimpleCard(title: 'Users', icon: Icons.supervised_user_circle),
      onNavigate: (context) => const UsersPage(),
    );
  }

  @override
  ModuleSettings? getSettings(BuildContext context) {
    return ModuleSettings('Users', [
      ListTile(
        title: const Text('Open Users'),
        onTap: () => Navigator.of(context).push(UsersPage.route()),
      ),
    ]);
  }

  FutureOr<QuickAction?> buildUsersAction(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.supervised_user_circle,
      text: 'Users',
      onNavigate: (context) => const UsersPage(),
    );
  }
}
