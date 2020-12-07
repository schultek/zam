library module;

import 'package:flutter/material.dart';

import 'package:reflectable/reflectable.dart';
import '../../main.reflectable.dart';

// ignore: UNUSED_IMPORT
import '../../modules/modules.dart';
import '../../models/Trip.dart';

part 'ModuleRegistry.dart';

class Module extends Reflectable {
  const Module() : super(
      reflectedTypeCapability,
      newInstanceCapability,
      staticInvokeCapability,
      typeCapability,
      declarationsCapability,
      metadataCapability,
      instanceInvokeCapability
  );
}

class ModuleWidgetReflectable extends Reflectable {
  const ModuleWidgetReflectable() : super(
      reflectedTypeCapability,
      typeCapability,
      typeRelationsCapability,
      subtypeQuantifyCapability
  );
}

class ModuleItem {
  final String id;
  const ModuleItem({this.id});
}

@ModuleWidgetReflectable()
abstract class ModuleWidget extends StatelessWidget {
  ModuleWidget({Key key}): super(key: key);

  String _id;
  String get id => _id;
  _setId(String id) {
    this._id = id;
  }
}

class ModuleData {
  Trip trip;
  ModuleData({this.trip});
}