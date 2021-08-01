import 'package:flutter/material.dart';

import '../areas/areas.dart';
import '../module/module.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';

class WidgetSelectorController<T extends ModuleElement> {
  final GlobalKey<WidgetSelectorState<T>> _selectorKey;
  final WidgetSelector<T> _widgetSelector;
  final OverlayEntry _entry;

  void close() => _entry.remove();
  bool isForArea(WidgetAreaState area) => _widgetSelector.widgetArea == area;
  WidgetSelectorState? get state => _selectorKey.currentState;

  const WidgetSelectorController(this._selectorKey, this._widgetSelector, this._entry);
}

class WidgetSelector<T extends ModuleElement> extends StatefulWidget {
  final List<T> widgets;
  final WidgetAreaState<WidgetArea<T>, T> widgetArea;

  const WidgetSelector(Key key, this.widgets, this.widgetArea) : super(key: key);

  @override
  WidgetSelectorState createState() => WidgetSelectorState<T>();

  static WidgetSelectorController show<T extends ModuleElement>(WidgetTemplateState template) {
    var selectorKey = GlobalKey<WidgetSelectorState<T>>();

    WidgetAreaState<WidgetArea<T>, T> widgetArea =
        template.widgetAreas[template.selectedArea]! as WidgetAreaState<WidgetArea<T>, T>;

    List<T> widgets = template.widgetFactories
        .where((f) => f.type == T)
        .map((f) => f.getWidget() as T)
        .where((w) => !widgetArea.getWidgets().any((ww) => ww.id == w.id) && widgetArea.isAllowed(w))
        .toList();

    var widgetSelector = WidgetSelector<T>(selectorKey, widgets, widgetArea);

    var entry = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: widgetArea.context.getFillColor(),
          ),
          child: InheritedWidgetTemplate(state: template, child: widgetSelector),
        ),
      ),
    );

    Overlay.of(template.context)!.insert(entry);

    return WidgetSelectorController(selectorKey, widgetSelector, entry);
  }

  static bool existsIn(BuildContext context) {
    return context.findAncestorStateOfType<WidgetSelectorState>() != null;
  }
}

class WidgetSelectorState<T extends ModuleElement> extends State<WidgetSelector<T>> with TickerProviderStateMixin {
  late List<T> widgets;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    widgets = widget.widgets.sublist(0);

    _scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(
        1000,
        duration: const Duration(seconds: 80),
        curve: Curves.linear,
      );
    });
  }

  void addWidget(Offset? offset, T widget) {
    var manager = WidgetTemplate.of(context, listen: false).reorderable;

    int beforeIndex;
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

  double get itemHeight => 90;
  double get topEdge => (context.findRenderObject()! as RenderBox).localToGlobal(Offset.zero).dy - 10;

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetArea(
      state: widget.widgetArea,
      child: InheritedThemeState(
        theme: widget.widgetArea.theme,
        reuseTheme: true,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          vsync: this,
          child: SizedBox(
            height: widgets.isNotEmpty ? 130 : 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: widgets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
        ),
      ),
    );
  }
}
