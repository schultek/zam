import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'module_builder.dart';

class ModuleContext {
  final BuildContext context;
  final ModuleBuilder parent;

  final String id;
  final String moduleId;
  final String elementId;
  final String? dataId;

  ModuleContext(this.context, this.parent, this.id)
      : moduleId = id.split('/').first,
        elementId = id.split('/').skip(1).firstOrNull ?? '',
        dataId = id.split('/').skip(2).firstOrNull;

  FutureOr<T> when<T>({
    required FutureOr<T> Function(String id) withId,
    required FutureOr<T> Function() withoutId,
  }) {
    if (dataId != null) {
      return withId(dataId!);
    } else {
      return withoutId();
    }
  }

  static String? setDataId(String fullId, String? dataId) {
    return dataId != null ? fullId.split('/').take(2).followedBy([dataId]).join('/') : fullId;
  }
}
