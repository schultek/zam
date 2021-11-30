import 'dart:async';

import 'package:flutter/material.dart';

import '../elements/module_element.dart';
import 'module_context.dart';
import 'module_registry.dart';

abstract class ModuleBuilder<T extends ModuleElement> {
  FutureOr<T?> build(ModuleContext context);

  void preload(BuildContext context) {}

  Iterable<Route> generateInitialRoutes(BuildContext context) => [];

  @mustCallSuper
  void dispose() {}

  ModuleSettings? getSettings(BuildContext context) => null;
}
