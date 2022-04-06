import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:vibration/vibration.dart';

import '../areas/areas.dart';
import '../elements/elements.dart';
import '../providers/selected_area_provider.dart';
import '../widgets/widget_selector.dart';
import 'drag_item.dart';
import 'logic_provider.dart';
import 'reorderable_item.dart';

final dragProvider = StateProvider<ReorderableDrag?>((ref) => null);
final isDragActiveProvider = StateProvider((ref) => false);

final isDraggingProvider =
    Provider.family((ref, Key key) => ref.watch(dragProvider)?.key == key && ref.watch(isDragActiveProvider));

final dragWidgetProvider = StateProvider<Widget?>((ref) => null);
final dragDecorationOpacityProvider = StateProvider<double>((ref) => 0);
final dragSizeProvider = StateProvider<Size?>((ref) => null);
final dragOffsetProvider = StateProvider<Offset?>((ref) => null);

class ReorderableDrag<T extends ModuleElement> with Drag {
  final Reader read;
  final Key key;

  final AreaState<Area<T>, T> area;

  ReorderableDrag({
    required this.read,
    required this.key,
    required PointerDownEvent event,
    required this.recognizer,
    required this.area,
  }) {
    recognizer!.onStart = onStart;
    recognizer!.addPointer(event);
  }

  MultiDragGestureRecognizer? recognizer;
  OverlayEntry? entry;
  T? moduleElement;

  AnimationController? finalAnimation;
  AnimationController? dragScaleAnimation;

  bool isOverWidgetSelector = false;
  bool isDropAccepted = false;

  WidgetSelectorState? get widgetSelector => area.mounted ? area.template.widgetSelector?.state : null;

  Offset? get dragOffset => read(dragOffsetProvider);
  set dragOffset(Offset? offset) => read(dragOffsetProvider.state).state = offset;

  Size? get dragSize => read(dragSizeProvider);
  set dragSize(Size? size) => read(dragSizeProvider.state).state = size;

  double get dragDecorationOpacity => read(dragDecorationOpacityProvider.state).state;
  set dragDecorationOpacity(double opacity) => read(dragDecorationOpacityProvider.state).state = opacity;

  Drag onStart(Offset position) {
    if (widgetSelector == null) {
      area.context.read(selectedAreaProvider.notifier).selectWidgetAreaById(area.id);
    }

    Vibration.vibrate(amplitude: 1, duration: 2);

    var draggedItem = read(reorderableLogicProvider).items[key]!;

    read(dragWidgetProvider.state).state =
        draggedItem.widget.builder(draggedItem.context, ReorderableState.dragging, draggedItem.widget.child);
    moduleElement = draggedItem.context.findAncestorWidgetOfExactType<T>();

    dragDecorationOpacity = 1;
    isDropAccepted = area.hasKey(key);

    dragScaleAnimation = AnimationController(
      vsync: area.template,
      duration: const Duration(milliseconds: 200),
      value: isDropAccepted ? 1 : 0,
    );

    isOverWidgetSelector = !isDropAccepted;

    var renderBox = draggedItem.context.findRenderObject()! as RenderBox;

    dragSize = Size(renderBox.size.width, renderBox.size.height);

    var height =
        isDropAccepted || widgetSelector == null ? dragSize!.height : widgetSelector!.startHeightFor(dragSize!);
    var width = height / dragSize!.height * dragSize!.width;

    dragOffset = renderBox.localToGlobal(Offset.zero) + Offset(width / 2, height / 2);

    var overlayState = Overlay.of(area.template.context)!;
    entry = OverlayEntry(
      builder: (ctx) => DragItemWidget<T>(
        area: area,
        elementConstraints: area.constrainWidget(moduleElement!),
        scaleAnimation: dragScaleAnimation!,
        decorationBuilder: draggedItem.widget.decorationBuilder,
      ),
    );
    overlayState.insert(entry!);

    read(isDragActiveProvider.state).state = true;

    return this;
  }

  @override
  void update(DragUpdateDetails details) {
    if (dragOffset == null || widgetSelector == null) return;
    dragOffset = dragOffset! + details.delta;

    if (widgetSelector == null || details.globalPosition.dy < widgetSelector!.topEdge) {
      if (isOverWidgetSelector) {
        isOverWidgetSelector = false;
        dragScaleAnimation!.forward();
      }

      var globalDragOffset = dragOffset! - Offset(dragSize!.width / 2, dragSize!.height / 2);

      var accepted = area.didInsertItem(globalDragOffset, moduleElement!, widgetSelector == null);
      if (accepted != isDropAccepted) {
        if (accepted) {
          widgetSelector?.takeWidget(moduleElement!);
        } else {
          widgetSelector?.placeWidget(moduleElement!);
        }
      }
      isDropAccepted = accepted;
    } else {
      if (!isOverWidgetSelector) {
        isOverWidgetSelector = true;
        dragScaleAnimation!.reverse();
      }
      if (isDropAccepted) {
        isDropAccepted = false;
        area.cancelDrop(key);
        widgetSelector!.placeWidget(moduleElement!);
      }
    }
  }

  @override
  Future<void> cancel() async {
    await end(null);
  }

  @override
  Future<void> end(DragEndDetails? details) async {
    HapticFeedback.lightImpact();

    var draggedItem = read(reorderableLogicProvider).items[key];
    if (draggedItem == null) {
      dispose();
      return;
    }

    finalAnimation = AnimationController(
      vsync: area.template,
      value: 0.0,
      duration: const Duration(milliseconds: 300),
    );

    if (isDropAccepted) {
      area.onDrop();
    } else if (widgetSelector == null) {
      dispose();
      return;
    }

    var renderBox = draggedItem.context.findRenderObject()! as RenderBox;
    var size = renderBox.size;

    var dragScale = dragScaleAnimation?.value ?? (isDropAccepted ? 1 : 0);
    var targetScale = isDropAccepted ? 1 : 0;

    var targetHeight = isDropAccepted ? size.height : widgetSelector!.startHeightFor(size);
    var targetWidth = targetHeight / size.height * size.width;

    var targetOffset = renderBox.localToGlobal(Offset.zero) + Offset(targetWidth / 2, targetHeight / 2);

    dragScaleAnimation!.stop();

    finalAnimation!.addListener(() {
      dragOffset = Offset.lerp(dragOffset, targetOffset, finalAnimation!.value);
      dragDecorationOpacity = 1.0 - finalAnimation!.value;
      dragScaleAnimation!.value = lerpDouble(dragScale, targetScale, finalAnimation!.value)!;
    });

    await finalAnimation!.animateTo(1.0, curve: Curves.easeOut);
    dispose();
  }

  void dispose() {
    finalAnimation?.stop();
    finalAnimation?.dispose();
    finalAnimation = null;

    recognizer?.dispose();
    recognizer = null;

    entry?.remove();
    entry = null;

    if (widgetSelector?.toDeleteElement == moduleElement) {
      widgetSelector?.endDeletion();
    }

    if (read(dragProvider) == this) {
      read(dragProvider.state).state = null;
      read(isDragActiveProvider.state).state = false;
    }
  }
}
