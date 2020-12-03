part of module;

class GridIndex {
  int row, column;
  CardSize size;
  GridIndex(this.row, this.column, this.size);
}

// Can be used to cancel reordering (i.e. when underlying data changed)
class CancellationToken {
  void cancelDragging() {
    for (final c in _callbacks) {
      c();
    }
  }

  final _callbacks = List<VoidCallback>();
}

abstract class GridProvider {
  GridIndex indexOf(Key key);
  List<List<ModuleCard>> getGrid();
  void onReorder(Key draggedItem, Key newPosition);
  void onReorderDone(Key draggedItem) {}
  Widget decorateItem(Widget widget, double decorationOpacity);
}

class ReorderableList extends StatefulWidget {
  ReorderableList({
    Key key,
    @required this.child,
    @required this.grid,
    this.cancellationToken,
  }) : super(key: key);

  final Widget child;
  final GridProvider grid;

  final CancellationToken cancellationToken;

  @override
  State<StatefulWidget> createState() => new _ReorderableListState();

  static _ReorderableListState of(BuildContext context) {
    return _ReorderableListState.of(context);
  }
}

enum ReorderableItemState {
  /// Normal item inside list
  normal,

  /// Placeholder, used at position of currently dragged item;
  /// Shoud have same dimensions as [normal] but hidden content
  placeholder,

  // Proxy item displayed during dragging
  dragProxy,

  // Proxy item displayed during finishing animation
  dragProxyFinished
}

//
//

typedef Widget ReorderableItemChildBuilder(BuildContext context, ReorderableItemState state);

class ReorderableItem extends StatefulWidget {
  /// [key] must be unique key for every item. It must be stable and not change
  /// when items are reordered
  ReorderableItem({
    @required Key key,
    @required this.childBuilder,
  }) : super(key: key);

  final ReorderableItemChildBuilder childBuilder;

  @override
  createState() => new _ReorderableItemState();
}

typedef ReorderableListenerCallback = bool Function();

class ReorderableListener extends StatelessWidget {
  ReorderableListener({
    Key key,
    this.child,
    this.canStart,
  }) : super(key: key);
  final Widget child;

  final ReorderableListenerCallback canStart;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerEvent event) => _routePointer(event, context),
      child: child,
    );
  }

  void _routePointer(PointerEvent event, BuildContext context) {
    if (canStart == null || canStart()) {
      _startDragging(context: context, event: event);
    }
  }

  @protected
  MultiDragGestureRecognizer createRecognizer({
    @required Object debugOwner,
    PointerDeviceKind kind,
  }) {
    return _Recognizer(
      debugOwner: debugOwner,
      kind: kind,
    );
  }

  void _startDragging({BuildContext context, PointerEvent event}) {
    _ReorderableItemState state = context.findAncestorStateOfType<_ReorderableItemState>();
    final scrollable = Scrollable.of(context);
    final listState = _ReorderableListState.of(context);
    if (listState.dragging == null) {
      listState._startDragging(
          key: state.key, event: event, scrollable: scrollable, recognizer: createRecognizer(debugOwner: this, kind: event.kind));
    }
  }
}

class DelayedReorderableListener extends ReorderableListener {
  DelayedReorderableListener({
    Key key,
    Widget child,
    ReorderableListenerCallback canStart,
    this.delay = kLongPressTimeout,
  }) : super(key: key, child: child, canStart: canStart);

  final Duration delay;

  @protected
  MultiDragGestureRecognizer createRecognizer({
    @required Object debugOwner,
    PointerDeviceKind kind,
  }) {
    return DelayedMultiDragGestureRecognizer(delay: delay, debugOwner: debugOwner, kind: kind);
  }
}

//
//
//

class _ReorderableListState extends State<ReorderableList> with TickerProviderStateMixin, Drag {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.passthrough,
        children: <Widget>[widget.child, new _DragProxy(widget.grid.decorateItem, constraints.maxWidth)],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.cancellationToken != null) {
      widget.cancellationToken._callbacks.add(this._cancel);
    }
  }

  @override
  void dispose() {
    if (widget.cancellationToken != null) {
      widget.cancellationToken._callbacks.remove(this._cancel);
    }
    _finalAnimation?.dispose();
    for (final c in _itemTranslations.values) {
      if (c.item1 != null) c.item1.dispose();
      if (c.item2 != null) c.item2.dispose();
    }
    _scrolling = null;
    _recognizer?.dispose();
    super.dispose();
  }

  void _cancel() {
    if (_dragging != null) {
      if (_finalAnimation != null) {
        _finalAnimation.dispose();
        _finalAnimation = null;
      }

      final dragging = _dragging;
      _dragging = null;
      _dragProxy.hide();

      var current = _items[_dragging];
      current?.update();

      widget.grid.onReorderDone(dragging);
    }
  }

  // Returns currently dragged key
  Key get dragging => _dragging;

  Key _dragging;
  MultiDragGestureRecognizer _recognizer;
  _DragProxyState _dragProxy;

  void _startDragging({
    Key key,
    PointerEvent event,
    MultiDragGestureRecognizer recognizer,
    ScrollableState scrollable,
  }) {
    _scrollable = scrollable;

    _finalAnimation?.stop(canceled: true);
    _finalAnimation?.dispose();
    _finalAnimation = null;

    if (_dragging != null) {
      var current = _items[_dragging];
      _dragging = null;
      current?.update();
    }

    _maybeDragging = key;
    _recognizer?.dispose();
    _recognizer = recognizer;
    _recognizer.onStart = _dragStart;
    _recognizer.addPointer(event);
  }

  Key _maybeDragging;

  Drag _dragStart(Offset position) {
    if (_dragging == null && _maybeDragging != null) {
      _dragging = _maybeDragging;
      _maybeDragging = null;
    }
    _hapticFeedback();
    final draggedItem = _items[_dragging];
    draggedItem.update();
    _dragProxy.setWidget(draggedItem.widget.childBuilder(draggedItem.context, ReorderableItemState.dragProxy),
        draggedItem.context.findRenderObject());
    this._scrollable.position.addListener(this._scrolled);

    return this;
  }

  void _draggedItemWidgetUpdated() {
    final draggedItem = _items[_dragging];
    if (draggedItem != null) {
      _dragProxy.updateWidget(draggedItem.widget.childBuilder(draggedItem.context, ReorderableItemState.dragProxy));
    }
  }

  void _scrolled() {
    checkDragPosition();
  }

  void update(DragUpdateDetails details) {
    _dragProxy.offsetY += details.delta.dy;
    _dragProxy.offsetX += details.delta.dx;
    checkDragPosition();
    maybeScroll();
  }

  ScrollableState _scrollable;

  void maybeScroll() async {
    if (!_scrolling && _scrollable != null && _dragging != null) {
      final position = _scrollable.position;
      double newOffset;
      int duration = 15; // in ms
      double step = 1.0;
      double overdragMax = 40.0;
      double overdragCoef = 5.0;

      MediaQueryData d = MediaQuery.of(context);

      double top = d?.padding?.top ?? 0.0;
      double bottom = this._scrollable.position.viewportDimension - (d?.padding?.bottom ?? 0.0);

      if (_dragProxy.offsetY < top && position.pixels > position.minScrollExtent) {
        final overdrag = max(top - _dragProxy.offsetY, overdragMax);
        newOffset = max(position.minScrollExtent, position.pixels - step * overdrag / overdragCoef);
      } else if (_dragProxy.offsetY + _dragProxy.height > bottom && position.pixels < position.maxScrollExtent) {
        final overdrag = max<double>(_dragProxy.offsetY + _dragProxy.height - bottom, overdragMax);
        newOffset = min(position.maxScrollExtent, position.pixels + step * overdrag / overdragCoef);
      }

      if (newOffset != null && (newOffset - position.pixels).abs() >= 1.0) {
        _scrolling = true;
        await this._scrollable.position.animateTo(newOffset, duration: Duration(milliseconds: duration), curve: Curves.linear);
        _scrolling = false;
        if (_dragging != null) {
          checkDragPosition();
          maybeScroll();
        }
      }
    }
  }

  bool _scrolling = false;

  void cancel() {
    end(null);
  }

  end(DragEndDetails details) async {
    if (_dragging == null) {
      return;
    }

    _hapticFeedback();
    if (_scrolling) {
      var prevDragging = _dragging;
      _dragging = null;
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _dragging = prevDragging;
        end(details);
      });
      return;
    }

    if (_scheduledRebuild) {
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (mounted) end(details);
      });
      return;
    }

    this._scrollable.position.removeListener(this._scrolled);

    var current = _items[_dragging];
    if (current == null) return;

    final originalOffset = _itemOffset(current);
    final dragProxyOffsetY = _dragProxy.offsetY;
    final dragProxyOffsetX = _dragProxy.offsetX;

    _dragProxy.updateWidget(current.widget.childBuilder(current.context, ReorderableItemState.dragProxyFinished));

    _finalAnimation =
        new AnimationController(vsync: this, lowerBound: 0.0, upperBound: 1.0, value: 0.0, duration: Duration(milliseconds: 300));

    _finalAnimation.addListener(() {
      _dragProxy.offsetY = lerpDouble(dragProxyOffsetY, originalOffset.dy, _finalAnimation.value);
      _dragProxy.offsetX = lerpDouble(dragProxyOffsetX, originalOffset.dx, _finalAnimation.value);
      _dragProxy.decorationOpacity = 1.0 - _finalAnimation.value;
    });

    _recognizer?.dispose();
    _recognizer = null;

    await _finalAnimation.animateTo(1.0, curve: Curves.easeOut);

    if (_finalAnimation != null) {
      _finalAnimation.dispose();
      _finalAnimation = null;

      final dragging = _dragging;
      _dragging = null;
      _dragProxy.hide();
      current.update();
      _scrollable = null;

      widget.grid.onReorderDone(dragging);
    }
  }

  void checkDragPosition() {
    if (_scheduledRebuild) {
      return;
    }
    final draggingState = _items[_dragging];
    if (draggingState == null) {
      return;
    }

    final draggingOffset = _itemOffset(draggingState);
    final draggingHeight = draggingState.context.size.height;
    final draggingWidth = draggingState.context.size.width;

    var grid = widget.grid.getGrid();

    if (_dragProxy.offsetY < draggingOffset.dy - draggingHeight / 2 - 20) {
      var dragIndex = widget.grid.indexOf(_dragging);
      if (dragIndex.row > 0) {
        var aboveRow = grid[dragIndex.row - 1];

        if (dragIndex.size == CardSize.Wide) {
          widget.grid.onReorder(_dragging, aboveRow[0].key);

          _adjustItemTranslationY(aboveRow[0].key, -draggingHeight);
          if (aboveRow.length == 2) _adjustItemTranslationY(aboveRow[1].key, -draggingHeight);
        } else {
          if (aboveRow.length == 2) {
            var aboveItem = aboveRow[dragIndex.column];

            widget.grid.onReorder(_dragging, aboveItem.key);
            _adjustItemTranslationY(aboveItem.key, -draggingHeight);
          } else {
            var siblingItem = widget.grid.getGrid()[dragIndex.row][1 - dragIndex.column];

            widget.grid.onReorder(_dragging, aboveRow[0].key);
            _adjustItemTranslationY(aboveRow[0].key, -draggingHeight);
            _adjustItemTranslationY(siblingItem.key, draggingHeight);
          }
        }

        SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
          _scheduledRebuild = false;
        });
        _scheduledRebuild = true;
      }
    } else if (_dragProxy.offsetY > draggingOffset.dy + draggingHeight / 2 + 20) {
      var dragIndex = widget.grid.indexOf(_dragging);
      if (dragIndex.row < grid.length - 1) {
        var belowRow = grid[dragIndex.row + 1];

        if (dragIndex.size == CardSize.Wide) {
          widget.grid.onReorder(_dragging, belowRow[0].key);

          _adjustItemTranslationY(belowRow[0].key, draggingHeight);
          if (belowRow.length == 2) _adjustItemTranslationY(belowRow[1].key, draggingHeight);
        } else {
          if (belowRow.length == 2) {
            var belowItem = belowRow[dragIndex.column];

            widget.grid.onReorder(_dragging, belowItem.key);
            _adjustItemTranslationY(belowItem.key, draggingHeight);
          } else {
            var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

            widget.grid.onReorder(_dragging, belowRow[0].key);
            _adjustItemTranslationY(belowRow[0].key, draggingHeight);
            _adjustItemTranslationY(siblingItem.key, -draggingHeight);
          }
        }

        SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
          _scheduledRebuild = false;
        });
        _scheduledRebuild = true;
      }
    } else if ((_dragProxy.offsetX - draggingOffset.dx).abs() > draggingWidth / 2 + 20) {

      var dragIndex = widget.grid.indexOf(_dragging);
      if (dragIndex.size == CardSize.Square) {

        var siblingItem = grid[dragIndex.row][1 - dragIndex.column];

        widget.grid.onReorder(_dragging, siblingItem.key);

        var sign = dragIndex.column == 0 ? 1 : -1;
        _adjustItemTranslationX(siblingItem.key, sign * draggingWidth, draggingWidth);

        SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
          _scheduledRebuild = false;
        });
        _scheduledRebuild = true;
      }
    }
  }

  void removeItem(Key key) {



  }

  void _hapticFeedback() {
    HapticFeedback.lightImpact();
  }

  bool _scheduledRebuild = false;

  //

  final _items = new HashMap<Key, _ReorderableItemState>();

  void registerItem(_ReorderableItemState item) {
    _items[item.key] = item;
  }

  void unregisterItem(_ReorderableItemState item) {
    if (_items[item.key] == item) _items.remove(item.key);
  }

  Offset _itemOffset(_ReorderableItemState item) {
    final topRenderBox = context.findRenderObject() as RenderBox;
    return (item.context.findRenderObject() as RenderBox).localToGlobal(Offset.zero, ancestor: topRenderBox);
  }

  static _ReorderableListState of(BuildContext context) {
    return context.findAncestorStateOfType<_ReorderableListState>();
  }

  //

  Map<Key, Tuple2<AnimationController, AnimationController>> _itemTranslations = new HashMap();

  Offset itemTranslation(Key key) {
    if (!_itemTranslations.containsKey(key))
      return Offset.zero;
    else {
      var tuple = _itemTranslations[key];
      return Offset(tuple.item1 != null ? tuple.item1.value : 0.0, tuple.item2 != null ? tuple.item2.value : 0.0);
    }
  }

  void _adjustItemTranslationY(Key key, double delta) {
    double current = 0.0;
    double max = delta.abs();
    if (_itemTranslations.containsKey(key)) {
      var currentController = _itemTranslations[key].item2;
      if (currentController != null) {
        current = currentController.value;
        currentController.stop(canceled: true);
        currentController.dispose();
      }
    }

    current += delta;

    final newController = new AnimationController(
        vsync: this,
        lowerBound: current < 0.0 ? -max : 0.0,
        upperBound: current < 0.0 ? 0.0 : max,
        value: current,
        duration: const Duration(milliseconds: 300));
    newController.addListener(() {
      _items[key]?.setState(() {}); // update offset
    });
    newController.addStatusListener((AnimationStatus s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
        newController.dispose();
        if (_itemTranslations[key].item2 == newController) {
          setItemTranslationY(key, null);
        }
      }
    });
    setItemTranslationY(key, newController);

    newController.animateTo(0.0, curve: Curves.easeInOut);
  }

  void setItemTranslationY(key, controller) {
    if (_itemTranslations.containsKey(key)) {
      _itemTranslations[key] = Tuple2(_itemTranslations[key].item1, controller);
    } else {
      _itemTranslations[key] = Tuple2(null, controller);
    }
  }

  void _adjustItemTranslationX(Key key, double delta, double max) {
    double current = 0.0;
    if (_itemTranslations.containsKey(key)) {
      var currentController = _itemTranslations[key].item1;
      if (currentController != null) {
        current = currentController.value;
        currentController.stop(canceled: true);
        currentController.dispose();
      }
    }

    current += delta;

    final newController = new AnimationController(
        vsync: this,
        lowerBound: current < 0.0 ? -max : 0.0,
        upperBound: current < 0.0 ? 0.0 : max,
        value: current,
        duration: const Duration(milliseconds: 300));
    newController.addListener(() {
      _items[key]?.setState(() {}); // update offset
    });
    newController.addStatusListener((AnimationStatus s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
        newController.dispose();
        if (_itemTranslations[key].item1 == newController) {
          setItemTranslationX(key, null);
        }
      }
    });
    setItemTranslationX(key, newController);

    newController.animateTo(0.0, curve: Curves.easeInOut);
  }

  void setItemTranslationX(key, controller) {
    if (_itemTranslations.containsKey(key)) {
      _itemTranslations[key] = Tuple2(controller, _itemTranslations[key].item2);
    } else {
      _itemTranslations[key] = Tuple2(controller, null);
    }
  }

  AnimationController _finalAnimation;
}

class _ReorderableItemState extends State<ReorderableItem> {
  get key => widget.key;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    _listState = _ReorderableListState.of(context);

    _listState.registerItem(this);
    bool dragging = _listState.dragging == key;
    Offset translation = _listState.itemTranslation(key);
    return Transform(
      transform: new Matrix4.translationValues(translation.dx, translation.dy, 0.0),
      child: widget.childBuilder(context, dragging ? ReorderableItemState.placeholder : ReorderableItemState.normal),
    );
  }

  @override
  void didUpdateWidget(ReorderableItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    _listState = _ReorderableListState.of(context);
    if (_listState.dragging == this.key) {
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

  _ReorderableListState _listState;
}

//
//
//

class _DragProxy extends StatefulWidget {
  final Widget Function(Widget child, double opacity) itemPlaceholder;
  double parentWidth;

  @override
  State<StatefulWidget> createState() => new _DragProxyState();

  _DragProxy(this.itemPlaceholder, this.parentWidth);
}

class _DragProxyState extends State<_DragProxy> {
  Widget _widget;
  Size _size;
  double _offsetY;
  double _offsetX;

  _DragProxyState();

  void setWidget(Widget widget, RenderBox position) {
    setState(() {
      _decorationOpacity = 1.0;
      _widget = widget;
      final state = _ReorderableListState.of(context);
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
    final state = _ReorderableListState.of(context);
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
    _ReorderableListState.of(context)?._dragProxy = null;
    super.deactivate();
  }
}

class _VerticalPointerState extends MultiDragPointerState {
  _VerticalPointerState(Offset initialPosition, PointerDeviceKind kind) : super(initialPosition, kind) {
    _resolveTimer = Timer(Duration(milliseconds: 150), () {
      resolve(GestureDisposition.accepted);
      _resolveTimer = null;
    });
  }

  @override
  void checkForResolutionAfterMove() {
    assert(pendingDelta != null);
    if (pendingDelta.dy.abs() > pendingDelta.dx.abs()) resolve(GestureDisposition.accepted);
  }

  @override
  void accepted(GestureMultiDragStartCallback starter) {
    starter(initialPosition);
    _resolveTimer?.cancel();
    _resolveTimer = null;
  }

  void dispose() {
    _resolveTimer?.cancel();
    _resolveTimer = null;
    super.dispose();
  }

  Timer _resolveTimer;
}

//
// VerticalDragGestureRecognizer waits for kTouchSlop to be reached; We don't want that
// when reordering items
//
class _Recognizer extends MultiDragGestureRecognizer<_VerticalPointerState> {
  _Recognizer({
    @required Object debugOwner,
    PointerDeviceKind kind,
  }) : super(debugOwner: debugOwner, kind: kind);

  @override
  _VerticalPointerState createNewPointerState(PointerDownEvent event) {
    return _VerticalPointerState(event.position, event.kind);
  }

  @override
  String get debugDescription => "Vertical recognizer";
}
