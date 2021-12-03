import 'package:flutter/foundation.dart';

import '../../elements/module_element.dart';
import '../widget_area.dart';

mixin ListAreaMixin<U extends WidgetArea<T>, T extends ModuleElement> on WidgetAreaState<U, T> {
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
