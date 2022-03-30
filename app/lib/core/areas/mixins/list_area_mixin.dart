import 'package:flutter/foundation.dart';

import '../../elements/elements.dart';
import '../area.dart';

mixin ListAreaMixin<U extends Area<T>, T extends ModuleElement> on AreaState<U, T> {
  List<T> elements = [];

  @override
  void initArea(List<T> widgets) => elements = widgets;

  @override
  List<T> getWidgets() => elements;

  @override
  T getWidgetFromKey(Key key) => elements.firstWhere((e) => e.key == key);

  @override
  bool hasKey(Key key) => elements.any((e) => e.key == key);
}
