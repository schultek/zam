import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../elements/module_element.dart';
import '../widget_area.dart';

mixin SingleElementAreaMixin<U extends WidgetArea<T>, T extends ModuleElement> on WidgetAreaState<U, T> {
  T? element;

  @override
  void initArea(List<T> widgets) => element = widgets.firstOrNull;

  @override
  List<T> getWidgets() => [if (element != null) element!];

  @override
  T getWidgetFromKey(Key key) => element!;

  @override
  bool hasKey(Key key) => element?.key == key;

  @override
  void insertItem(T item) {
    if (element != null) removeWidget(element!.key);
    setState(() => element = item);
  }

  @override
  void removeItem(Key key) {
    if (key == element?.key) {
      setState(() => element = null);
    }
  }

  @override
  bool didReorderItem(Offset offset, Key itemKey) => false;
}
