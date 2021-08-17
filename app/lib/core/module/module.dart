library module;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

export '../../models/segment_size.dart';
export '../elements/elements.dart';
export '../themes/themes.dart';
export 'module_annotations.dart';

abstract class ModuleElement extends StatelessWidget {
  @override
  final Key key; // ignore: overridden_fields
  ModuleElement({required this.key}); // ignore: prefer_const_constructors_in_immutables

  late final String _id;
  String get id => _id;

  void onRemoved(BuildContext context) {}
}

class ModuleRegistry {
  final Map<String, ModuleInstance> moduleMap;
  ModuleRegistry(this.moduleMap);

  ModuleElement? getWidget(BuildContext context, String id) {
    return moduleMap[id.split('/').firstOrNull]?.getWidget(context, id);
  }

  List<T> getWidgetsOf<T extends ModuleElement>(BuildContext context) {
    return moduleMap.entries.expand((e) => e.value.getWidgetsOf<T>(context, e.key)).whereNotNull().toList();
  }
}

class ModuleInstance<T> {
  final T module;
  final Map<String, ModuleFactory<T, ModuleElement>> factories;

  ModuleInstance(this.module, this.factories);

  ModuleElement? getWidget(BuildContext context, String id) {
    return factories[id.split('/').skip(1).firstOrNull]?.getWidget(context, module, id);
  }

  Iterable<U?> getWidgetsOf<U extends ModuleElement>(BuildContext context, String moduleId) {
    return factories.entries
        .where((e) => e.value is ModuleFactory<T, U>)
        .map((e) => (e.value as ModuleFactory<T, U>).getWidget(context, module, '$moduleId/${e.key}'));
  }
}

class ModuleFactory<M, T extends ModuleElement> {
  T? Function(BuildContext context, M m, String? id) factory;
  Type get type => T;

  ModuleFactory(this.factory);

  T? getWidget(BuildContext context, M m, String id) {
    return factory(context, m, id.split('/').skip(2).firstOrNull)?.._id = id;
  }
}
