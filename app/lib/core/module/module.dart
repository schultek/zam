import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

abstract class ModuleElement extends StatelessWidget {
  ModuleElement({required Key key, required ModuleContext context})
      : id = context.id,
        super(key: key);

  final String id;

  @override
  Key get key => super.key!;

  void onRemoved(BuildContext context) {}
}

abstract class ModuleBuilder<T extends ModuleElement> {
  FutureOr<T?> build(ModuleContext context);

  void preload(BuildContext context) {}

  Iterable<Route> generateInitialRoutes(BuildContext context) => [];

  @mustCallSuper
  void dispose() {}
}

class ModuleContext {
  final BuildContext context;
  final String id;
  final String moduleId;
  final String? elementId;

  ModuleContext(this.context, this.id)
      : moduleId = id.split('/').first,
        elementId = id.split('/').skip(1).firstOrNull;

  FutureOr<T> when<T>({
    required FutureOr<T> Function(String id) withId,
    required FutureOr<T> Function() withoutId,
  }) {
    if (elementId != null) {
      return withId(elementId!);
    } else {
      return withoutId();
    }
  }
}

class ModuleRegistry {
  final Map<String, ModuleBuilder> modules;
  ModuleRegistry(this.modules);

  FutureOr<T?> getWidget<T extends ModuleElement>(ModuleContext context) async {
    var builder = modules[context.moduleId];
    assert(builder is ModuleBuilder<T>?, 'Expected ModuleBuilder<T> for module ${context.moduleId}.');
    return (builder as ModuleBuilder<T>?)?.build(context);
  }

  List<T> getWidgetsOf<T extends ModuleElement>(BuildContext context) {
    return modules.entries
        .where((e) => e.value is ModuleBuilder<T>)
        .map((e) {
          var element = e.value.build(ModuleContext(context, e.key));
          assert(element is T?, "ModuleBuilder's build() method must return synchronously when given no element id.");
          return element as T?;
        })
        .whereNotNull()
        .toList();
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
}
