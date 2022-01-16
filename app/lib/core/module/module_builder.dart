import 'dart:async';

import 'package:flutter/material.dart';

import '../elements/module_element.dart';
import 'module_context.dart';
import 'module_registry.dart';

abstract class ModuleBuilder<T extends ModuleElement> {
  final String id;
  ModuleBuilder(this.id);

  Map<String, ElementBuilder> get elements;

  void preload(BuildContext context) {}

  Iterable<Route> generateInitialRoutes(BuildContext context) => [];

  @mustCallSuper
  void dispose() {}

  ModuleSettings? getSettings(BuildContext context) => null;
}

typedef ElementBuilder<T extends ModuleElement> = FutureOr<T?> Function(ModuleContext);
