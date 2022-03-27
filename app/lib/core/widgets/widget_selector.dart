import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../modules/modules.dart';
import '../areas/widget_area.dart';
import '../elements/module_element.dart';
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

  static Future<WidgetSelectorController> show<T extends ModuleElement>(
      WidgetTemplateState template, WidgetAreaState<WidgetArea<T>, T> widgetArea) async {
    var selectorKey = GlobalKey<WidgetSelectorState<T>>();

    List<T> widgets = await registry.getWidgetsOf<T>(widgetArea.context);
    var widgetSelector = WidgetSelector<T>(selectorKey, widgets, widgetArea);

    var entry = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: InheritedWidgetTemplate(state: template, child: widgetSelector),
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

  T? toDeleteElement;

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double shrinkFactor(Size size) {
    var heightShrink = maxItemHeight / size.height;
    var widthShrink = maxItemWidth / size.width;

    return min(heightShrink, widthShrink);
  }

  void placeWidget(T toDelete) {
    setState(() {
      toDeleteElement = toDelete;
    });
  }

  void takeWidget(T toRemove) async {
    if (toRemove == toDeleteElement) {
      setState(() {
        toDeleteElement = null;
      });
      return;
    }

    var index = widgets.indexOf(toRemove);
    var newWidget = await registry.getWidget<T>(widget.widgetArea.context, toRemove.module.copyId());

    setState(() {
      widgets = [...widgets.take(index), newWidget!, ...widgets.skip(index + 1)];
    });
  }

  void endDeletion() {
    setState(() {
      toDeleteElement = null;
    });
  }

  double get outerPadding => 10;
  double get innerPadding => 10;
  double get headerHeight => 14;
  double get sheetHeight => widgets.isNotEmpty ? maxItemHeight + outerPadding * 2 + innerPadding * 2 + headerHeight : 0;
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
    var groups = widgets.fold<List<List<T>>>([], (groups, widget) {
      if (groups.isEmpty) {
        return [
          [widget]
        ];
      }
      var lastGroup = groups.last;
      if (lastGroup.isEmpty) {
        lastGroup.add(widget);
      } else {
        var lastWidget = lastGroup.last;
        if (lastWidget.module.parent == widget.module.parent) {
          lastGroup.add(widget);
        } else {
          groups.add([widget]);
        }
      }
      return groups;
    });

    return InheritedWidgetArea(
      state: widget.widgetArea,
      child: TripTheme(
        theme: widget.widgetArea.theme,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: sheetHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                color: widget.widgetArea.context.surfaceColor,
                boxShadow: const [BoxShadow(blurRadius: 8, spreadRadius: -4)],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(outerPadding),
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      slivers: [
                        for (var group in groups)
                          SliverStickyHeader(
                            overlapsContent: true,
                            header: Builder(builder: (context) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: innerPadding, right: innerPadding),
                                  child: Text(
                                    group.first.module.parent.getName(context),
                                    style: context.theme.textTheme.caption,
                                  ),
                                ),
                              );
                            }),
                            sliver: SliverPadding(
                              padding: EdgeInsets.only(top: headerHeight),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.all(innerPadding),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: maxItemWidth),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: ConstrainedBox(
                                            constraints: widget.widgetArea.constrainWidget(group[index]),
                                            child: group[index],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: group.length,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (toDeleteElement != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        color: context.theme.colorScheme.error.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(outerPadding + innerPadding) + EdgeInsets.only(top: headerHeight),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxItemWidth),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: ConstrainedBox(
                                constraints: widget.widgetArea.constrainWidget(toDeleteElement!),
                                child: toDeleteElement!,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
