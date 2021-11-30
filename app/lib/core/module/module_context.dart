import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

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
