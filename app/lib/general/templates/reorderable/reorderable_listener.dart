part of templates;

class ReorderableListener<T extends ModuleWidget> extends StatelessWidget {
  const ReorderableListener({
    Key? key,
    required this.child,
    this.delay = kLongPressTimeout,
  }) : super(key: key);

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _startDragging(context: context, event: event);
      },
      child: child,
    );
  }

  void _startDragging({required BuildContext context, required PointerDownEvent event}) {
    ReorderableItemState state = context.findAncestorStateOfType<ReorderableItemState>()!;

    var widgetArea = WidgetArea.of<T>(context, listen: false);
    var manager = WidgetTemplate.of(context, listen: false).reorderable;

    if (manager.dragging == null) {
      manager.startDragging(
        key: state.key,
        event: event,
        widgetArea: widgetArea,
        recognizer: DelayedMultiDragGestureRecognizer(delay: delay, debugOwner: this, kind: event.kind),
      );
    }
  }
}
