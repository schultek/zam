part of templates;

class WidgetSelectorController<T extends ModuleWidget> {
  GlobalKey<WidgetSelectorState<T>> _selectorKey;
  WidgetSelector<T> _widgetSelector;
  PersistentBottomSheetController _bottomSheetController;

  WidgetSelectorController(this._selectorKey, this._widgetSelector, this._bottomSheetController);

  void close() {
    _bottomSheetController.close();
  }

  bool isForArea(WidgetAreaState area) {
    return _widgetSelector.widgetArea == area;
  }

  WidgetSelectorState get state => _selectorKey.currentState;
}

class WidgetSelector<T extends ModuleWidget> extends StatefulWidget {
  final List<T> widgets;
  final WidgetAreaState<WidgetArea<T>, T> widgetArea;

  WidgetSelector(Key key, this.widgets, this.widgetArea) : super(key: key);

  @override
  WidgetSelectorState createState() => WidgetSelectorState<T>();

  static WidgetSelectorController show<T extends ModuleWidget>(WidgetTemplateState template) {
    var selectorKey = GlobalKey<WidgetSelectorState<T>>();

    WidgetAreaState<WidgetArea<T>, T> widgetArea = template._widgetAreas[template._selectedArea];

    List<T> widgets = template._widgetFactories
        .where((f) => f.type == T)
        .map((f) => f.getWidget() as T)
        .where((w) => !widgetArea.selectedWidgets.any((ww) => ww.id == w.id))
        .toList();

    var widgetSelector = WidgetSelector<T>(selectorKey, widgets, widgetArea);

    var bottomSheetController = Scaffold.of(template.context).showBottomSheet(
      (context) => _InheritedWidgetTemplate(state: template, child: widgetSelector),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      elevation: 20,
    );

    return WidgetSelectorController(selectorKey, widgetSelector, bottomSheetController);
  }

  static bool existsIn(BuildContext context) {
    return context.findAncestorStateOfType<WidgetSelectorState>() != null;
  }
}

class WidgetSelectorState<T extends ModuleWidget> extends State<WidgetSelector<T>> {
  List<T> widgets;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    this.widgets = widget.widgets.sublist(0);

    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(1000, duration: Duration(seconds: 80), curve: Curves.linear);
    });
  }

  void addWidget(Offset offset, T widget) {
    var manager = WidgetTemplate.of(context, listen: false).reorderable;

    var beforeIndex;
    if (offset == null) {
      beforeIndex = 0;
    } else {
      beforeIndex = widgets.indexWhere((w) {
        var size = manager.itemSize(w.key);
        return manager.itemOffset(w.key).dx + itemHeight / size.height * size.width / 2 > offset.dx;
      });
      if (beforeIndex == -1) beforeIndex = widgets.length;
    }

    var itemSize = manager.itemSize(widget.key);
    var paddingX = itemSize.height / itemHeight * 20;

    for (int i = beforeIndex; i < widgets.length; i++) {
      manager.translateItemX(widgets[i].key, -itemSize.width - paddingX);
    }

    setState(() {
      widgets.insert(beforeIndex, widget);
    });
  }

  void removeWidget(T widget) {
    var index = widgets.indexOf(widget);

    var manager = WidgetTemplate.of(context, listen: false).reorderable;
    var itemSize = manager.itemSize(widget.key);
    var paddingX = itemSize.height / itemHeight * 20;

    for (int i = index + 1; i < widgets.length; i++) {
      manager.translateItemX(widgets[i].key, itemSize.width + paddingX);
    }

    setState(() {
      widgets.remove(widget);
    });
  }

  get itemHeight => 90;
  get topEdge => (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero).dy - 10;

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetArea(
      state: widget.widgetArea,
      child: Container(
        height: 130,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: ConstrainedBox(
                    constraints: widget.widgetArea.constrainWidget(widgets[index]),
                    child: widgets[index],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
