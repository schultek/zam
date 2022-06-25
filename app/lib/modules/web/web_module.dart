library web_module;

import 'dart:async';

import 'package:cropperx/cropperx.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/emoji_keyboard.dart';
import '../../core/widgets/input_list_tile.dart';
import '../../core/widgets/select_image_list_tile.dart';
import '../module.dart';
import 'widgets/url_shortcut_card.dart';
import 'widgets/web_view_page.dart';

export '../module.dart';

part 'elements/launch_url_action_element.dart';
part 'elements/launch_url_content_element.dart';
part 'elements/web_page_element.dart';

class WebModule extends ModuleBuilder {
  WebModule() : super('web');

  @override
  String getName(BuildContext context) => context.tr.web;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'launch_url': LaunchUrlContentElement(),
        'web_page': WebPageElement(),
        'launch_url_action': LaunchUrlActionElement(),
      };
}
