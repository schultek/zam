library web_module;

import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/widgets/emoji_keyboard.dart';
import '../../core/widgets/input_list_tile.dart';
import '../../widgets/needs_setup_card.dart';
import '../../widgets/nested_will_pop_scope.dart';
import '../module.dart';

export '../module.dart';

part 'elements/launch_url_action_element.dart';
part 'elements/web_page_element.dart';

class WebModule extends ModuleBuilder {
  WebModule() : super('web');

  @override
  String getName(BuildContext context) => context.tr.web;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'web_page': WebPageElement(),
        'launch_url_action': LaunchUrlActionElement(),
      };
}
