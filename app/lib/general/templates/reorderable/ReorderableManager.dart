part of templates;

class ReorderableManager with Drag {
  WidgetTemplateState templateState;

  // Returns currently dragged key
  Key get dragging => _dragging;

  Key _dragging;
  Key _maybeDragging;
  Map<Key, ReorderableItemState> _items = Map<Key, ReorderableItemState>();
  MultiDragGestureRecognizer _recognizer;

  OverlayEntry _entry;

  Offset _dragOffset;
  Size _dragSize;
  Widget _dragWidget;
  double _dragDecorationOpacity;
  ModuleWidget _dragModuleWidget;
  AnimationController _dragScaleAnimation;
  WidgetAreaState _focusedArea;

  bool _isOverWidgetSelector = false;
  bool _isDropAccepted = false;

  WidgetSelectorState get widgetSelector => templateState._widgetSelector.state;

  ReorderableManager(this.templateState) {
    _dragScaleAnimation = AnimationController(
      vsync: templateState,
      duration: Duration(milliseconds: 200),
      value: 0,
    )..addListener(() {
        if (_entry != null) {
          _entry.markNeedsBuild();
        }
      });
  }

  void dispose() {
    _finalAnimation?.dispose();
    for (final c in _itemTranslations.values) {
      if (c.item1 != null) c.item1.dispose();
      if (c.item2 != null) c.item2.dispose();
    }
    _recognizer?.dispose();
  }

  Widget _buildDragProxy(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromCenter(
          center: _dragOffset,
          width: lerpDouble(widgetSelector.itemHeight, _dragSize.height, _dragScaleAnimation.value) /
              _dragSize.height *
              _dragSize.width,
          height: lerpDouble(widgetSelector.itemHeight, _dragSize.height, _dragScaleAnimation.value)),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: SizedBox.fromSize(
          size: _dragSize,
          child: templateState.decorateItem(
              IgnorePointer(
                child: MediaQuery.removePadding(
                  context: context,
                  child: _dragWidget,
                  removeTop: true,
                  removeBottom: true,
                ),
              ),
              _dragDecorationOpacity),
        ),
      ),
    );
  }

  void startDragging<T extends ModuleWidget>({
    Key key,
    PointerEvent event,
    MultiDragGestureRecognizer recognizer,
    WidgetAreaState<WidgetArea<T>, T> widgetArea,
  }) {
    _focusedArea = widgetArea;

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
    _recognizer.onStart = (position) => _dragStart<T>(position);
    _recognizer.addPointer(event);
  }

  Drag _dragStart<T extends ModuleWidget>(Offset position) {
    if (_dragging == null && _maybeDragging != null) {
      _dragging = _maybeDragging;
      _maybeDragging = null;
    }

    if (templateState._widgetSelector == null || widgetSelector == null) {
      templateState.selectWidgetArea<T>(_focusedArea);

      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        _dragStart<T>(position);
      });

      return this;
    }

    _hapticFeedback();

    final draggedItem = _items[_dragging];
    draggedItem.update();

    _dragWidget = draggedItem.widget.builder(draggedItem.context, ReorderableState.dragging, draggedItem.widget.child);
    _dragModuleWidget = draggedItem.context.findAncestorWidgetOfExactType<T>();

    _dragDecorationOpacity = 1.0;

    _isDropAccepted = _focusedArea.onDrag(_dragging);

    _dragScaleAnimation.value = _isDropAccepted ? 1 : 0;
    _isOverWidgetSelector = !_isDropAccepted;

    var renderBox = draggedItem.context.findRenderObject() as RenderBox;
    _dragSize = Size(renderBox.size.width, renderBox.size.height);

    var height = _isDropAccepted ? _dragSize.height : widgetSelector.itemHeight;
    var width = height / _dragSize.height * _dragSize.width;

    _dragOffset = renderBox.localToGlobal(Offset.zero) + Offset(width / 2, height / 2);

    var overlayState = Overlay.of(templateState.context);
    _entry =
        OverlayEntry(builder: (ctx) => _InheritedWidgetTemplate(state: templateState, child: _buildDragProxy(ctx)));
    overlayState.insert(_entry);

    return this;
  }

  void _draggedItemWidgetUpdated() {
    final draggedItem = _items[_dragging];
    if (draggedItem != null) {
      _dragWidget =
          draggedItem.widget.builder(draggedItem.context, ReorderableState.dragging, draggedItem.widget.child);
      _entry.markNeedsBuild();
    }
  }

  void update(DragUpdateDetails details) {
    if (_dragOffset == null || widgetSelector == null) return;
    _dragOffset = _dragOffset + details.delta;

    if (details.globalPosition.dy < widgetSelector.topEdge) {
      if (_isOverWidgetSelector) {
        _isOverWidgetSelector = false;
        _dragScaleAnimation.forward();
      }

      var areaOffset = _focusedArea.areaOffset;
      var localDragOffset = _dragOffset - Offset(_dragSize.width / 2, _dragSize.height / 2) - areaOffset;

      var accepted = _focusedArea.checkDropPosition(localDragOffset, _dragModuleWidget);
      if (accepted != _isDropAccepted) {
        if (accepted) {
          widgetSelector.removeWidget(_dragModuleWidget);
        } else {
          widgetSelector.addWidget(_dragOffset, _dragModuleWidget);
        }
      }
      _isDropAccepted = accepted;
    } else {
      if (!_isOverWidgetSelector) {
        _isOverWidgetSelector = true;
        _dragScaleAnimation.reverse();
      }
      if (_isDropAccepted) {
        _isDropAccepted = false;
        _focusedArea.cancelDrop(_dragging);
        widgetSelector.addWidget(_dragOffset, _dragModuleWidget);
      }
    }

    if (_entry != null) {
      _entry.markNeedsBuild();
    }
  }

  void cancel() {
    end(null);
  }

  end(DragEndDetails details) async {
    if (_dragging == null) {
      return;
    }

    _hapticFeedback();

    var draggedItem = _items[_dragging];
    if (draggedItem == null) return;

    _finalAnimation = new AnimationController(
        vsync: templateState, lowerBound: 0.0, upperBound: 1.0, value: 0.0, duration: Duration(milliseconds: 300));

    if (_isDropAccepted) {
      _focusedArea.onDrop();
    }

    final dragOffset = _dragOffset;

    var renderBox = draggedItem.context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    final dragScale = _dragScaleAnimation.value;
    final targetScale = _isDropAccepted ? 1 : 0;

    var targetHeight = _isDropAccepted ? size.height : widgetSelector.itemHeight;
    var targetWidth = targetHeight / size.height * size.width;

    final targetOffset = renderBox.localToGlobal(Offset.zero) + Offset(targetWidth / 2, targetHeight / 2);

    _dragScaleAnimation.stop();

    _finalAnimation.addListener(() {
      _dragOffset = Offset.lerp(dragOffset, targetOffset, _finalAnimation.value);
      _dragDecorationOpacity = 1.0 - _finalAnimation.value;
      _dragScaleAnimation.value = lerpDouble(dragScale, targetScale, _finalAnimation.value);
      _entry.markNeedsBuild();
    });

    _recognizer?.dispose();
    _recognizer = null;

    await _finalAnimation.animateTo(1.0, curve: Curves.easeOut);

    if (_finalAnimation != null) {
      _finalAnimation.dispose();
      _finalAnimation = null;

      _dragging = null;
      _onDragFinished();
      draggedItem.update();
    }
  }

  void _onDragFinished() {
    _entry.remove();
    _entry = null;
  }

  void _hapticFeedback() {
    HapticFeedback.lightImpact();
  }

  void registerItem(ReorderableItemState item) {
    _items[item.key] = item;
  }

  void unregisterItem(ReorderableItemState item) {
    if (_items[item.key] == item) _items.remove(item.key);
  }

  Offset _itemOffset(ReorderableItemState item) {
    return (item.context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
  }

  Offset itemOffset(Key key) {
    return _itemOffset(_items[key]);
  }

  Size itemSize(Key key) {
    return _items[key].context.size;
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

  void translateItemY(Key key, double delta) {
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
        vsync: templateState,
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

  void translateItemX(Key key, double delta) {
    double current = 0.0;
    double max = delta.abs();
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
        vsync: templateState,
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
