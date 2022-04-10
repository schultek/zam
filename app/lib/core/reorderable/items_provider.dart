import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../areas/areas.dart';
import '../elements/elements.dart';
import 'drag_provider.dart';
import 'item_animation.dart';
import 'reorderable_item.dart';

final itemTranslationProvider = StateProvider.family((ref, Key key) => const ItemAxisAnimation(null, null));

final itemAnimationProvider =
    Provider.family((ref, Key key) => ItemOffsetAnimation(axisAnimation: ref.watch(itemTranslationProvider(key))));

final reorderableItemProvider = Provider((ref) => ReorderableItemLogic(ref.read));

class ItemState {
  ReorderableItemState item;

  ItemState(this.item);

  Offset? _cachedOffset;
  Size? _cachedSize;

  void update() {
    _cachedOffset = null;
    _cachedSize = null;
  }

  void addOffset(Offset offset) {
    _cachedOffset = this.offset + offset;
  }

  Offset get offset {
    if (_cachedOffset != null) return _cachedOffset!;
    return _cachedOffset = (item.context.findRenderObject()! as RenderBox).localToGlobal(Offset.zero);
  }

  Size get size {
    if (_cachedSize != null) return _cachedSize!;
    return _cachedSize = item.context.size!;
  }
}

class ReorderableItemLogic {
  final Reader read;
  ReorderableItemLogic(this.read);

  final Map<Key, ItemState> items = {};

  void register(ReorderableItemState item) {
    items[item.key] = ItemState(item);
  }

  void unregister(ReorderableItemState item) {
    if (items[item.key]?.item == item) {
      items.remove(item.key);
    }
  }

  void update(ReorderableItemState item) {
    if (items[item.key]?.item == item) {
      items[item.key]?.update();
    }
  }

  void startDragging<T extends ModuleElement>({
    required Key key,
    required PointerDownEvent event,
    required MultiDragGestureRecognizer recognizer,
    required AreaState<Area<T>, T> widgetArea,
  }) {
    var dragState = read(dragProvider.state);
    dragState.state?.dispose();
    dragState.state = ReorderableDrag<T>(
      read: read,
      key: key,
      event: event,
      recognizer: recognizer,
      area: widgetArea,
    );
  }

  bool hasItem(Key key) {
    return items[key] != null;
  }

  Offset itemOffset(Key key) {
    return items[key]!.offset;
  }

  Size itemSize(Key key) {
    return items[key]!.size;
  }

  void addArtificialOffset(Key key, Offset offset) {
    items[key]?.addOffset(offset);
  }

  void translateItemY(AreaState area, Key key, double delta) {
    _translateItem(area, key, delta, (t) => t.item2, (t, v) => t.withItem2(v));
  }

  void translateItemX(AreaState area, Key key, double delta) {
    _translateItem(area, key, delta, (t) => t.item1, (t, v) => t.withItem1(v));
  }

  void _translateItem(
    AreaState area,
    Key key,
    double delta,
    AnimationController? Function(ItemAxisAnimation t) getItem,
    ItemAxisAnimation Function(ItemAxisAnimation t, AnimationController? v) withItem,
  ) {
    double current = 0.0;
    double max = delta.abs();

    var itemTranslation = read(itemTranslationProvider(key));
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
        var itemTranslation = read(itemTranslationProvider(key));
        if (getItem(itemTranslation) == newController) {
          read(itemTranslationProvider(key).state).state = withItem(itemTranslation, null);
        }
      }
    });

    read(itemTranslationProvider(key).state).state = withItem(itemTranslation, newController);
    newController.animateTo(0.0, curve: Curves.easeInOut);
  }
}
