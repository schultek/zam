import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/trips/selected_trip_provider.dart';
import '../elements/module_element.dart';
import 'module_builder.dart';
import 'module_context.dart';

class ModuleSettings {
  List<Widget> settings;

  ModuleSettings(this.settings);
}

class ModuleRegistry {
  final Map<String, ModuleBuilder> modules;
  ModuleRegistry(List<ModuleBuilder> modules) : modules = Map.fromEntries(modules.map((m) => MapEntry(m.id, m)));

  FutureOr<T?> getWidget<T extends ModuleElement>(BuildContext context, String id) async {
    var moduleId = ModuleContext.getModuleId(id);
    var module = modules[moduleId];
    if (module == null) return null;

    var moduleContext = ModuleContext<T>(context, module, id);

    var builder = modules[moduleId]?.elements[moduleContext.elementId];
    assert(builder is ElementBuilder<T>?,
        'Expected ElementBuilder<$T> for module ${moduleContext.moduleId}/${moduleContext.elementId}.');
    return (builder as ElementBuilder<T>?)?.call(moduleContext);
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
                ModuleContext<T>(context, m.value, '${m.key}/${e.key}'),
              ),
    ]);
    return widgets.whereNotNull().toList();
  }

  Future<T?> _callOrCatch<T extends ModuleElement>(ElementBuilder<T> builder, ModuleContext module) async {
    var future = builder(module);
    try {
      return await future;
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st, reason: 'Getting widget for module ${module.id}');
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

  Iterable<MapEntry<String, ModuleSettings>> getSettings(BuildContext context) sync* {
    for (var module in modules.values) {
      var settings = module.getSettings(context);
      if (settings != null) yield MapEntry(module.getName(context), settings);
    }
  }
}
