part of reorderable;

class ReorderableListener extends StatelessWidget {
  ReorderableListener({
    Key key,
    this.child,
    this.delay = kLongPressTimeout,
  }) : super(key: key);

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerEvent event) {
        _startDragging(context: context, event: event);
      },
      child: child,
    );
  }

  void _startDragging({BuildContext context, PointerEvent event}) {

    _ReorderableItemState state = context.findAncestorStateOfType<_ReorderableItemState>();

    final scrollable = Scrollable.of(context);
    final listState = ReorderableListState.of(context);

    if (listState.dragging == null) {
      listState._startDragging(
          key: state.key,
          event: event,
          scrollable: scrollable,
          recognizer: DelayedMultiDragGestureRecognizer(delay: delay, debugOwner: this, kind: event.kind)
      );
    }
  }
}




