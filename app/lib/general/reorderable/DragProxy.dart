part of reorderable;

class DragProxy extends StatefulWidget {
  final Widget Function(Widget child, double opacity) itemPlaceholder;
  final double parentWidth;

  @override
  State<StatefulWidget> createState() => new _DragProxyState();

  DragProxy(this.itemPlaceholder, this.parentWidth);
}

class _DragProxyState extends State<DragProxy> {
  Widget _widget;
  Size _size;
  double _offsetY;
  double _offsetX;

  _DragProxyState();

  void setWidget(Widget widget, RenderBox position) {
    setState(() {
      _decorationOpacity = 1.0;
      _widget = widget;
      final state = ReorderableListState.of(context);
      RenderBox renderBox = state.context.findRenderObject();
      final offset = position.localToGlobal(Offset.zero, ancestor: renderBox);
      _offsetX = offset.dx;
      _offsetY = offset.dy;
      _size = position.size;
    });
  }

  void updateWidget(Widget widget) {
    _widget = widget;
  }

  set offsetY(double newOffset) {
    setState(() {
      _offsetY = newOffset;
    });
  }

  get offsetY => _offsetY;

  set offsetX(double newOffset) {
    setState(() {
      _offsetX = newOffset;
    });
  }

  get offsetX => _offsetX;

  Offset get offset => Offset(_offsetX, _offsetY);

  get height => _size.height;

  get width => _size.width;

  double _decorationOpacity;

  set decorationOpacity(double val) {
    setState(() {
      _decorationOpacity = val;
    });
  }

  void hide() {
    setState(() {
      _widget = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ReorderableListState.of(context);
    state._dragProxy = this;

    if (_widget != null && _size != null && _offsetY != null) {
      final w = IgnorePointer(
        child: MediaQuery.removePadding(
          context: context,
          child: _widget,
          removeTop: true,
          removeBottom: true,
        ),
      );

      final decoratedPlaceholder = widget.itemPlaceholder(w, _decorationOpacity);
      return Positioned(
        child: decoratedPlaceholder,
        top: _offsetY,
        left: max(20, min(widget.parentWidth - _size.width - 20, _offsetX)),
        width: _size.width,
      );
    } else {
      return new Container(width: 0.0, height: 0.0);
    }
  }

  @override
  void deactivate() {
    ReorderableListState.of(context)?._dragProxy = null;
    super.deactivate();
  }
}