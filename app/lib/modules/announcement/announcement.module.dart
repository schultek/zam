library announcement_module;

import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:shared/api/modules/announcement.dart';

import '../../widgets/needs_setup_card.dart';
import '../module.dart';
import 'pages/announcement_create_page.dart';
import 'widgets/announcement_card.dart';

export '../module.dart';

part 'announcement.models.dart';
part 'announcement.provider.dart';
part 'elements/announcement_content_element.dart';

class AnnouncementModule extends ModuleBuilder {
  AnnouncementModule() : super('announcements');

  @override
  String getName(BuildContext context) => context.tr.announcements;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'announcement': AnnouncementContentElement(),
      };
}
