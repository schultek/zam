import 'dart:async';

import 'package:flutter/material.dart';

import '../elements/elements.dart';
import 'module_context.dart';
import 'module_registry.dart';

abstract class ModuleBuilder {
  final String id;
  ModuleBuilder(this.id);

  String getName(BuildContext context);

  Map<String, ElementBuilder> get elements;

  void preload(BuildContext context) {}

  Iterable<Route> generateInitialRoutes(BuildContext context) => [];

  @mustCallSuper
  void dispose() {}

  ModuleSettings? getSettings(BuildContext context) => null;
}

typedef ElementBuilder<T extends ModuleElement> = FutureOr<T?> Function(ModuleContext module);

mixin ElementBuilderMixin<T extends ModuleElement> {
  FutureOr<T?> build(ModuleContext module);

  FutureOr<T?> call(ModuleContext module) => build(module);
}
