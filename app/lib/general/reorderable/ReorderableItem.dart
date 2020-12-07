part of reorderable;

class ReorderableItem extends StatefulWidget {

  ReorderableItem({
    @required Key key,
    @required this.builder,
    this.child,
  }) : super(key: key);

  final Widget child;
  final Widget Function(BuildContext context, ReorderableItemState state, Widget child) builder;

  @override
  createState() => new _ReorderableItemState();
}


class _ReorderableItemState extends State<ReorderableItem> {

  ReorderableListState _listState;

  Key get key => widget.key;

  @override
  Widget build(BuildContext context) {

    _listState = ReorderableListState.of(context);
    _listState.registerItem(this);

    bool dragging = _listState.dragging == key;
    Offset translation = _listState.itemTranslation(key);
    return Transform(
      transform: new Matrix4.translationValues(translation.dx, translation.dy, 0.0),
      child: widget.builder(context, dragging ? ReorderableItemState.placeholder : ReorderableItemState.normal, widget.child),
    );
  }

  @override
  void didUpdateWidget(ReorderableItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    _listState = ReorderableListState.of(context);
    if (_listState.dragging == key) {
      _listState._draggedItemWidgetUpdated();
    }
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    _listState?.unregisterItem(this);
    _listState = null;
    super.deactivate();
  }

}