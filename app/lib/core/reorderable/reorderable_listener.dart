import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../areas/areas.dart';
import '../elements/elements.dart';
import 'items_provider.dart';
import 'reorderable_item.dart';

class ReorderableListener<T extends ModuleElement> extends StatelessWidget {
  const ReorderableListener({
    required this.child,
    this.delay = kLongPressTimeout,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (PointerDownEvent event) {
        _startDragging(context: context, event: event);
      },
      child: child,
    );
  }

  void _startDragging({required BuildContext context, required PointerDownEvent event}) {
    ReorderableItemState state = context.findAncestorStateOfType<ReorderableItemState>()!;
    var widgetArea = Area.of<T>(context)!;

    context.read(reorderableItemProvider).startDragging(
          key: state.key,
          event: event,
          widgetArea: widgetArea,
          recognizer: DelayedMultiDragGestureRecognizer(
            delay: delay,
            debugOwner: this,
            supportedDevices: {event.kind},
          ),
        );
  }
}
