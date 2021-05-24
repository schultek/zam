library module;

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:reflectable/reflectable.dart';

import '../../main.mapper.g.dart';
import '../../models/models.dart';
// ignore: UNUSED_IMPORT
import '../../modules/modules.dart';

export '../elements/elements.dart';
export '../themes/themes.dart';

part 'module_registry.dart';

class Module extends Reflectable {
  const Module()
      : super(reflectedTypeCapability, newInstanceCapability, staticInvokeCapability, typeCapability,
            declarationsCapability, metadataCapability, instanceInvokeCapability);
}

class ModuleWidgetReflectable extends Reflectable {
  const ModuleWidgetReflectable()
      : super(reflectedTypeCapability, typeCapability, typeRelationsCapability, subtypeQuantifyCapability);
}

class ModuleItem {
  final String id;
  const ModuleItem({required this.id});
}

@ModuleWidgetReflectable()
abstract class ModuleElement extends StatelessWidget {
  @override
  final Key key; // ignore: overridden_fields
  ModuleElement({required this.key}); // ignore: prefer_const_constructors_in_immutables

  Widget buildPlaceholder(BuildContext context);

  late final String _id;
  String get id => _id;
}

class ModuleData {
  Trip trip;
  ModuleData({required this.trip});
}
