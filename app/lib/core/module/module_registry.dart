import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/trips/selected_trip_provider.dart';
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
  ModuleRegistry(List<ModuleBuilder> modules) : modules = Map.fromEntries(modules.map((m) => MapEntry(m.id, m)));

  FutureOr<T?> getWidget<T extends ModuleElement>(ModuleContext context) async {
    var builder = modules[context.moduleId]?.elements[context.elementId];
    assert(builder is ElementBuilder<T>?,
        'Expected ElementBuilder<$T> for module ${context.moduleId}/${context.elementId}.');
    return (builder as ElementBuilder<T>?)?.call(context);
  }

  Future<List<T>> getWidgetsOf<T extends ModuleElement>(BuildContext context) async {
    var moduleBlacklist = context.read(selectedTripProvider)!.moduleBlacklist;
    var widgets = await Future.wait([
      for (var m in modules.entries)
        if (!moduleBlacklist.contains(m.key))
          for (var e in m.value.elements.entries)
            if (e.value is ElementBuilder<T>)
              _callOrCatch(
                e.value as ElementBuilder<T>,
                ModuleContext(context, '${m.key}/${e.key}'),
              ),
    ]);
    return widgets.whereNotNull().toList();
  }

  Future<T?> _callOrCatch<T extends ModuleElement>(ElementBuilder<T> builder, ModuleContext context) async {
    var future = builder(context);
    try {
      return await future;
    } catch (e) {
      print('Error when getting widget ${context.id}: $e');
      return null;
    }
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
