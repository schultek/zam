library profile_module;

import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../module.dart';
import 'pages/profile_page.dart';
import 'widgets/profile_image_widget.dart';

export '../module.dart';

part 'elements/profile_action_element.dart';
part 'elements/profile_content_element.dart';
part 'elements/profile_image_content_element.dart';
part 'elements/profile_user_action_element.dart';

class ProfileModule extends ModuleBuilder {
  ProfileModule() : super('profile');

  @override
  String getName(BuildContext context) => context.tr.profile;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'profile': ProfileElement(),
        'profile_image': ProfileImageElement(),
        'profile_action': ProfileActionElement(),
        'profile_user_action': ProfileUserActionElement(),
      };
}
