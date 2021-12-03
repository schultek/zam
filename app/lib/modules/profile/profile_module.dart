import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/simple_card.dart';
import 'pages/profile_page.dart';

class ProfileModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => const SimpleCard(title: 'Profil', icon: Icons.account_circle),
      onNavigate: (context) => const ProfilePage(),
    );
  }
}

class ProfileActionModule extends ModuleBuilder<QuickAction> {
  @override
  FutureOr<QuickAction?> build(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.account_circle,
      text: 'Profil',
      onTap: (context) => Navigator.of(context).push(ProfilePage.route()),
    );
  }
}
