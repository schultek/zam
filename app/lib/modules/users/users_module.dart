import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/simple_card.dart';
import 'pages/users_page.dart';

class UsersModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
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
}

class UsersActionModule extends ModuleBuilder<QuickAction> {
  @override
  FutureOr<QuickAction?> build(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.supervised_user_circle,
      text: 'Users',
      onNavigate: (context) => const UsersPage(),
    );
  }
}
