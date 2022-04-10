import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../elements/elements.dart';
import '../area.dart';

mixin SingleElementAreaMixin<U extends Area<T>, T extends ModuleElement> on AreaState<U, T> {
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
  void insertItem(Offset offset, T item) {
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
  Offset? didReorderItem(Offset offset, Key itemKey) => null;

  @override
  bool canInsertItem(T item) => element == null;
}
