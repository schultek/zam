import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/groups/selected_group_provider.dart';
import '../elements/elements.dart';
import 'module_builder.dart';
import 'module_context.dart';

class ModuleRegistry {
  final List<ModuleBuilder Function()> factories;
  final Map<String, ModuleBuilder> modules = {};

  ModuleRegistry(this.factories);

  bool isInitialized = false;
  void initModules() {
    if (isInitialized) return;
    modules.clear();
    for (var factory in factories) {
      var m = factory();
      modules[m.id] = m;
    }
    isInitialized = true;
  }

  FutureOr<T?> getWidget<T extends ModuleElement>(BuildContext context, String id) async {
    initModules();

    var moduleId = ModuleContext.getModuleId(id);
    var module = modules[moduleId];
    if (module == null) return null;

    var moduleContext = ModuleContext<T>(context, module, id);

    var builder = modules[moduleId]?.elements[moduleContext.elementId];
    assert(builder is ElementBuilder<T>?,
        'Expected ElementBuilder<$T> for module ${moduleContext.moduleId}/${moduleContext.elementId}.');
    return (builder as ElementBuilder<T>?)?.call(moduleContext);
  }

  List<ElementResolver<T>> getWidgetsOf<T extends ModuleElement>(BuildContext context) {
    initModules();

    var moduleBlacklist = context.read(selectedGroupProvider)!.moduleBlacklist;
    var widgets = <ElementResolver<T>>[];

    for (var m in modules.entries) {
      if (!moduleBlacklist.contains(m.key)) {
        for (var e in m.value.elements.entries) {
          if (e.value is ElementBuilder<T>) {
            var widget = _callOrCatch(
              e.value as ElementBuilder<T>,
              ModuleContext<T>(context, m.value, '${m.key}/${e.key}'),
            );
            if (widget != null) {
              widgets.add(ElementResolver(widget, m.value));
            }
          }
        }
      }
    }
    return widgets;
  }

  FutureOr<T?> _callOrCatch<T extends ModuleElement>(ElementBuilder<T> builder, ModuleContext module) {
    var future = builder(module);
    if (future is T?) {
      return future;
    } else {
      return Future.sync(() async {
        try {
          return await future;
        } catch (e, st) {
          FirebaseCrashlytics.instance.recordError(e, st, reason: 'Getting widget for module ${module.id}');
          return null;
        }
      });
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
    modules.clear();
    isInitialized = false;
  }

  Iterable<Route> generateInitialRoutes(BuildContext context) sync* {
    initModules();

    for (var module in modules.values) {
      yield* module.generateInitialRoutes(context);
    }
  }

  Iterable<MapEntry<String, Iterable<Widget>>> getSettings(BuildContext context) sync* {
    initModules();

    for (var module in modules.values) {
      var settings = module.getSettings(context);
      if (settings != null) yield MapEntry(module.getName(context), settings);
    }
  }

  Future<void> handleMessage(ModuleMessage message) async {
    initModules();

    if (message.moduleId != null) {
      await modules[message.moduleId!]?.handleMessage(message);
    } else {
      for (var m in modules.values) {
        await m.handleMessage(message);
      }
    }
  }
}

class ElementResolver<T extends ModuleElement> with ChangeNotifier implements ValueListenable<ElementResolver<T>> {
  final FutureOr<T?> _elementFuture;
  final ModuleBuilder module;

  bool isResolved = false;
  T? result;

  ElementResolver(this._elementFuture, this.module) {
    assert(_elementFuture != null);
    if (_elementFuture is T) {
      isResolved = true;
      result = _elementFuture as T;
    } else {
      (_elementFuture as Future<T?>).then((e) {
        isResolved = true;
        result = e;
        notifyListeners();
      });
    }
  }

  @override
  get value => this;
}
