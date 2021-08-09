import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../areas/areas.dart';
import '../module/module.dart';
import 'drag_provider.dart';
import 'item_animation.dart';
import 'items_provider.dart';
import 'reorderable_item.dart';

final reorderableLogicProvider = Provider((ref) => ReorderableLogic(ref.read));

class ReorderableLogic {
  final Reader read;
  ReorderableLogic(this.read);

  final Map<Key, ReorderableItemState> items = {};

  void register(ReorderableItemState item) {
    items[item.key] = item;
  }

  void unregister(ReorderableItemState item) {
    if (items[item.key] == item) {
      items.remove(item.key);
    }
  }

  void startDragging<T extends ModuleElement>({
    required Key key,
    required PointerDownEvent event,
    required MultiDragGestureRecognizer recognizer,
    required WidgetAreaState<WidgetArea<T>, T> widgetArea,
  }) {
    var dragState = read(dragProvider);
    dragState.state?.dispose();
    dragState.state = ReorderableDrag<T>(
      read: read,
      key: key,
      event: event,
      recognizer: recognizer,
      area: widgetArea,
    );
  }

  Offset _itemOffset(ReorderableItemState item) {
    return (item.context.findRenderObject()! as RenderBox).localToGlobal(Offset.zero);
  }

  Offset itemOffset(Key key) {
    return _itemOffset(items[key]!);
  }

  Size itemSize(Key key) {
    return items[key]!.context.size!;
  }

  void translateItemY(WidgetAreaState area, Key key, double delta) {
    translateItem(area, key, delta, (t) => t.item2, (t, v) => t.withItem2(v));
  }

  void translateItemX(WidgetAreaState area, Key key, double delta) {
    translateItem(area, key, delta, (t) => t.item1, (t, v) => t.withItem1(v));
  }

  void translateItem(
    WidgetAreaState area,
    Key key,
    double delta,
    AnimationController? Function(ItemAxisAnimation t) getItem,
    ItemAxisAnimation Function(ItemAxisAnimation t, AnimationController? v) withItem,
  ) {
    double current = 0.0;
    double max = delta.abs();

    var itemTranslation = read(itemTranslationProvider(key)).state;
    var target = getItem(itemTranslation);

    if (target != null) {
      current = target.value;
      target.stop();
      target.dispose();
    }

    current += delta;

    var newController = AnimationController(
      vsync: area.template,
      lowerBound: current < 0.0 ? -max : 0.0,
      upperBound: current < 0.0 ? 0.0 : max,
      value: current,
      duration: const Duration(milliseconds: 300),
    );
    newController.addStatusListener((AnimationStatus s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
        newController.dispose();
        var itemTranslation = read(itemTranslationProvider(key)).state;
        if (getItem(itemTranslation) == newController) {
          read(itemTranslationProvider(key)).state = withItem(itemTranslation, null);
        }
      }
    });

    read(itemTranslationProvider(key)).state = withItem(itemTranslation, newController);
    newController.animateTo(0.0, curve: Curves.easeInOut);
  }
}
