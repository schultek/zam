import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/trips/logic_provider.dart';
import 'drops_template.dart';
import 'focus_template.dart';
import 'grid_template.dart';
import 'swipe_template.dart';
import 'widget_template.dart';

@MappableClass(discriminatorKey: 'type')
abstract class TemplateModel {
  String type;
  TemplateModel(this.type);

  String get name;
  WidgetTemplate builder();

  List<Widget>? settings(BuildContext context) => null;

  static List<TemplateModel> get all {
    return [
      GridTemplateModel(),
      SwipeTemplateModel(),
      FocusTemplateModel(),
      DropsTemplateModel(),
    ];
  }
}

extension ModelUpdate<T extends TemplateModel> on T {
  Future<void> update(BuildContext context, T Function(T model) fn) async {
    var updated = fn(this);
    await context.read(tripsLogicProvider).updateTemplateModel(updated);
  }
}
