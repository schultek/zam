library thebutton_module;

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../module.dart';
import 'pages/thebutton_help.dart';
import 'pages/thebutton_settings.dart';
import 'widgets/thebutton_widget.dart';

export '../module.dart';

part 'elements/thebutton_content_element.dart';
part 'thebutton.models.dart';
part 'thebutton.provider.dart';

class TheButtonModule extends ModuleBuilder {
  TheButtonModule() : super('thebutton');

  @override
  String getName(BuildContext context) => context.tr.the_button;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'thebutton': TheButtonElement(),
      };

  @override
  Iterable<Widget>? getSettings(BuildContext context) {
    var state = context.watch(theButtonProvider);

    if (state.value != null) {
      return [
        SwitchListTile(
          title: Text(context.tr.show_level_in_avatars),
          value: state.value!.showInAvatars,
          onChanged: (v) => context.read(theButtonLogicProvider).setShowInAvatars(v),
        ),
      ];
    }
    return null;
  }
}
