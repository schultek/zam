import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../modules/modules.dart';
import '../areas/widget_area.dart';
import '../elements/module_element.dart';
import '../reorderable/logic_provider.dart';
import '../templates/widget_template.dart';
import '../themes/theme_context.dart';
import '../themes/widgets/trip_theme.dart';

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

    List<T> widgets = registry
        .getWidgetsOf<T>(template.context)
        .where((w) => !widgetArea.getWidgets().any((ww) => ww.id == w.id))
        .toList();

    var widgetSelector = WidgetSelector<T>(selectorKey, widgets, widgetArea);

    var entry = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: widgetArea.context.surfaceColor,
            boxShadow: const [BoxShadow(blurRadius: 8, spreadRadius: -4)],
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

class WidgetSelectorState<T extends ModuleElement> extends State<WidgetSelector<T>> {
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

  double shrinkFactor(Size size) {
    var heightShrink = maxItemHeight / size.height;
    var widthShrink = maxItemWidth / size.width;

    return min(heightShrink, widthShrink);
  }

  void addWidget(Offset? offset, T toAdd) {
    var logic = context.read(reorderableLogicProvider);
    int beforeIndex;
    if (offset == null) {
      beforeIndex = 0;
    } else {
      beforeIndex = widgets.indexWhere((w) {
        if (!logic.hasItem(w.key)) return false;
        var size = logic.itemSize(w.key);
        return logic.itemOffset(w.key).dx + maxItemHeight / size.height * size.width > offset.dx;
      });
      if (beforeIndex == -1) beforeIndex = widgets.length;
    }

    var itemSize = logic.itemSize(toAdd.key);
    double itemWidth = shrinkFactor(itemSize) * itemSize.width + 20;

    for (int i = beforeIndex; i < widgets.length; i++) {
      if (!logic.hasItem(widgets[i].key)) continue;

      var item2Size = logic.itemSize(widgets[i].key);
      double translate = itemWidth / shrinkFactor(item2Size);

      logic.translateItemX(widget.widgetArea, widgets[i].key, -translate);
    }

    setState(() {
      widgets.insert(beforeIndex, toAdd);
    });
  }

  void removeWidget(T toRemove) {
    var logic = context.read(reorderableLogicProvider);

    var index = widgets.indexOf(toRemove);
    var itemSize = logic.itemSize(toRemove.key);
    double itemWidth = shrinkFactor(itemSize) * itemSize.width + 20;

    for (int i = index + 1; i < widgets.length; i++) {
      if (!logic.hasItem(widgets[i].key)) continue;

      var item2Size = logic.itemSize(widgets[i].key);
      double translate = itemWidth / shrinkFactor(item2Size);

      logic.translateItemX(widget.widgetArea, widgets[i].key, translate);
    }

    setState(() {
      widgets.remove(toRemove);
    });
  }

  double get outerPadding => 10;
  double get innerPadding => 10;
  double get sheetHeight => widgets.isNotEmpty ? maxItemHeight + outerPadding * 2 + innerPadding * 2 : 0;
  double get maxItemHeight => 90;
  double get maxItemWidth => 100;
  double get topEdge => (context.findRenderObject()! as RenderBox).localToGlobal(Offset.zero).dy - 10;

  double startHeightFor(Size size) {
    var selectorHeight = maxItemHeight;
    var startItemWidth = size.width / (size.height / selectorHeight);
    if (startItemWidth > maxItemWidth) {
      var shrink = startItemWidth / maxItemWidth;
      return selectorHeight / shrink;
    } else {
      return selectorHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetArea(
      state: widget.widgetArea,
      child: TripTheme(
        theme: widget.widgetArea.theme,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: sheetHeight,
            child: Padding(
              padding: EdgeInsets.all(outerPadding),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: widgets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(innerPadding),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxItemWidth),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: ConstrainedBox(
                          constraints: widget.widgetArea.constrainWidget(widgets[index]),
                          child: widgets[index],
                        ),
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
