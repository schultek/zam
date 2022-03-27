import 'dart:convert';

import 'package:binary_codec/binary_codec.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../../main.mapper.g.dart';
import '../areas/widget_area.dart';
import '../elements/module_element.dart';
import 'module_builder.dart';

class ModuleContext<T extends ModuleElement> {
  final BuildContext context;
  final ModuleBuilder parent;

  ModuleId _parsedId;

  String get id => _parsedId.toString();
  String get moduleId => _parsedId.moduleId;
  String get elementId => _parsedId.elementId;
  String get uniqueId => _parsedId.uniqueId;
  bool get hasParams => _parsedId.params != null;

  String get keyId => _parsedId.copyWith(params: null).toString();

  ModuleContext(this.context, this.parent, String id)
      : assert(T != ModuleElement, 'ModuleContext was called with default type parameter. This is probably not right.'),
        _parsedId = ModuleId.from(id);

  E getParams<E>() {
    return Mapper.fromValue<E>(_parsedId.params);
  }

  void updateParams<E>(E params) {
    _parsedId = _parsedId.copyWith(params: Mapper.toValue(params));
    WidgetArea.of<T>(context)!.updateWidgetsInTrip();
  }

  String copyId() {
    return _parsedId.copyWith(uniqueId: generateRandomId(4)).toString();
  }

  static getModuleId(String fullId) {
    return fullId.split('/').first;
  }
}

/// Format: <moduleId>/<elementId>[/<dataId>][?<params>]
@MappableClass()
class ModuleId {
  String moduleId;
  String elementId;
  String uniqueId;

  dynamic params;

  ModuleId(this.moduleId, this.elementId, this.uniqueId, this.params);

  factory ModuleId.from(String id) {
    var parts = id.split('?');
    var ids = parts[0].split('/');
    var moduleId = ids[0];
    var elementId = ids[1];
    var uniqueId = ids.length > 2 ? ids[2] : generateRandomId(4);
    var params = parts.length > 1 ? _decode(parts[1]) : null;
    if (params is Map) {
      params = params.cast<String, dynamic>();
    }
    return ModuleId(moduleId, elementId, uniqueId, params);
  }

  static dynamic _decode(String encoded) {
    return binaryCodec.decode(base64Url.decode(encoded));
  }

  @override
  String toString() {
    var paramsStr = params != null ? '?${base64Url.encode(binaryCodec.encode(params!))}' : '';
    return '$moduleId/$elementId/$uniqueId$paramsStr';
  }
}
