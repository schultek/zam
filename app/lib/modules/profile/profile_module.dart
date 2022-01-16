import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/simple_card.dart';
import 'pages/profile_page.dart';
import 'widgets/profile_image_widget.dart';

class ProfileModule extends ModuleBuilder<ContentSegment> {
  ProfileModule() : super('profile');

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'profile': buildProfile,
        'profile_image': buildProfileImage,
        'profile_action': buildProfileAction,
      };

  FutureOr<ContentSegment?> buildProfile(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => const SimpleCard(title: 'Profil', icon: Icons.account_circle),
      onNavigate: (context) => const ProfilePage(),
    );
  }

  FutureOr<ContentSegment?> buildProfileImage(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => const ProfileImageWidget(),
      onNavigate: (context) => const ProfilePage(),
    );
  }

  FutureOr<QuickAction?> buildProfileAction(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.account_circle,
      text: 'Profil',
      onNavigate: (context) => const ProfilePage(),
    );
  }
}
