import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../widgets/simple_card.dart';
import 'pages/profile_page.dart';
import 'widgets/profile_image_widget.dart';

class ProfileModule extends ModuleBuilder {
  ProfileModule() : super('profile');

  @override
  String getName(BuildContext context) => context.tr.profile;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'profile': buildProfile,
        'profile_image': buildProfileImage,
        'profile_action': buildProfileAction,
      };

  FutureOr<ContentSegment?> buildProfile(ModuleContext module) {
    return ContentSegment(
      module: module,
      builder: (context) => SimpleCard(title: context.tr.profile, icon: Icons.account_circle),
      onNavigate: (context) => const ProfilePage(),
    );
  }

  FutureOr<ContentSegment?> buildProfileImage(ModuleContext module) {
    return ContentSegment(
      module: module,
      builder: (context) => const ProfileImageWidget(),
      onNavigate: (context) => const ProfilePage(),
    );
  }

  FutureOr<QuickAction?> buildProfileAction(ModuleContext module) {
    return QuickAction(
      module: module,
      icon: Icons.account_circle,
      text: module.context.tr.profile,
      onNavigate: (context) => const ProfilePage(),
    );
  }
}
