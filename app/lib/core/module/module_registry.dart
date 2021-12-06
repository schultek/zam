import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../elements/module_element.dart';
import 'module_builder.dart';
import 'module_context.dart';

class ModuleSettings {
  String title;
  List<Widget> settings;

  ModuleSettings(this.title, this.settings);
}

class ModuleRegistry {
  final Map<String, ModuleBuilder> modules;
  ModuleRegistry(this.modules);

  FutureOr<T?> getWidget<T extends ModuleElement>(ModuleContext context) async {
    var builder = modules[context.moduleId];
    assert(builder is ModuleBuilder<T>?, 'Expected ModuleBuilder<T> for module ${context.moduleId}.');
    return (builder as ModuleBuilder<T>?)?.build(context);
  }

  Future<List<T>> getWidgetsOf<T extends ModuleElement>(BuildContext context) async {
    var widgets = await Future.wait(modules.entries
        .where((e) => e.value is ModuleBuilder<T>)
        .map((e) async => await (e.value as ModuleBuilder<T>).build(ModuleContext(context, e.key))));
    return widgets.whereNotNull().toList();
  }

  void preloadModules(BuildContext context) {
    for (var module in modules.values) {
      module.preload(context);
    }
  }

  void disposeModules() {
    for (var module in modules.values) {
      module.dispose();
    }
  }

  Iterable<Route> generateInitialRoutes(BuildContext context) sync* {
    for (var module in modules.values) {
      yield* module.generateInitialRoutes(context);
    }
  }

  Iterable<ModuleSettings> getSettings(BuildContext context) sync* {
    for (var module in modules.values) {
      var settings = module.getSettings(context);
      if (settings != null) yield settings;
    }
  }
}
