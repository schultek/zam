part of templates;

class ReorderableListener<T extends ModuleWidget> extends StatelessWidget {
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
    ReorderableItemState state = context.findAncestorStateOfType<ReorderableItemState>();

    final widgetArea = WidgetArea.of<T>(context, listen: false);
    final manager = WidgetTemplate.of(context, listen: false).reorderable;

    if (manager.dragging == null) {
      manager.startDragging(
          key: state.key,
          event: event,
          widgetArea: widgetArea,
          recognizer: DelayedMultiDragGestureRecognizer(delay: delay, debugOwner: this, kind: event.kind));
    }
  }
}
