part of reorderable;


class ReorderableList extends StatefulWidget {
  ReorderableList({
    Key key,
    @required this.child,
    @required this.service,
    this.decorateItem,
    this.cancellationToken,
  }) : super(key: key);

  final Widget child;
  final ReorderableService service;

  Widget Function(Widget widget, double decorationOpacity) decorateItem;
  final CancellationToken cancellationToken;

  @override
  State<StatefulWidget> createState() => new ReorderableListState();

  static ReorderableListState of(BuildContext context) {
    return ReorderableListState.of(context);
  }
}


class ReorderableListState extends State<ReorderableList> with TickerProviderStateMixin, Drag {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.passthrough,
        children: <Widget>[widget.child, new DragProxy(widget.decorateItem, constraints.maxWidth)],
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

      widget.service.onReorderDone(dragging);
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
    _dragProxy.setWidget(draggedItem.widget.builder(draggedItem.context, ReorderableItemState.dragProxy, draggedItem.widget.child),
        draggedItem.context.findRenderObject());
    this._scrollable.position.addListener(this._scrolled);

    return this;
  }

  void _draggedItemWidgetUpdated() {
    final draggedItem = _items[_dragging];
    if (draggedItem != null) {
      _dragProxy.updateWidget(draggedItem.widget.builder(draggedItem.context, ReorderableItemState.dragProxy, draggedItem.widget.child));
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

    _dragProxy.updateWidget(current.widget.builder(current.context, ReorderableItemState.dragProxyFinished, current.widget.child));

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

      widget.service.onReorderDone(dragging);
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

    if (widget.service.checkDragPosition(
      offset: _dragProxy.offset,
      itemOffset: _itemOffset(draggingState),
      itemSize: draggingState.context.size,
      itemKey: _dragging,
      listState: this,
    )) {
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _scheduledRebuild = false;
      });
      _scheduledRebuild = true;
    }

  }

  void _hapticFeedback() {
    HapticFeedback.lightImpact();
  }

  bool _scheduledRebuild = false;

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

  static ReorderableListState of(BuildContext context) {
    return context.findAncestorStateOfType<ReorderableListState>();
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

  void adjustItemTranslationY(Key key, double delta) {
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

  void adjustItemTranslationX(Key key, double delta, double max) {
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
