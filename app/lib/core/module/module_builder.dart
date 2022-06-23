import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../elements/elements.dart';
import '../themes/themes.dart';
import 'module_context.dart';

abstract class ModuleBuilder {
  final String id;
  ModuleBuilder(this.id);

  String getName(BuildContext context);

  Map<String, ElementBuilder> get elements;

  void preload(BuildContext context) {}

  Iterable<Route> generateInitialRoutes(BuildContext context) => [];

  @mustCallSuper
  void dispose() {}

  Iterable<Widget>? getSettings(BuildContext context) => null;

  Future<void> handleMessage(ModuleMessage message) async {}
}

@MappableClass(discriminatorKey: 'type')
class ModuleMessage {
  final String? moduleId;

  ModuleMessage(this.moduleId);
}

abstract class ElementBuilder<T extends ModuleElement> {
  String getTitle(BuildContext context) => 'Some Module';
  String getSubtitle(BuildContext context) => 'A short description what it does.';

  Widget buildDescription(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Some detailed text about this module that can have more information and be a longer block of text.\n\n'
            'Maybe also show some examples or mockups of certain aspects of this module. '
            'I dont know, I\'m just trying to fill in some text. '
            'At this point I can write anything it does not matter.',
            style: TextStyle(color: context.onSurfaceColor),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
          Text(
            'We could also explain some of the settings on how the element can be further customized once placed on the page.',
            style: TextStyle(color: context.onSurfaceColor),
          ),
        ],
      );

  FutureOr<T?> build(ModuleContext module);
}
