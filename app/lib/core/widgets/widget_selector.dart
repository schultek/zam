import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../modules/modules.dart';
import '../core.dart';

final widgetSelectorProvider = StateProvider<WidgetSelectorState?>((ref) => null);

class WidgetSelector<T extends ModuleElement> extends StatefulWidget {
  static const double outerPadding = 10;
  static const double innerPadding = 10;
  static const double headerHeight = 14;
  static const double maxItemHeight = 90;
  static const double maxItemWidth = 100;
  static const double dragHandleHeight = 20;
  static late double sheetHeight =
      maxItemHeight + outerPadding * 2 + innerPadding * 2 + headerHeight + dragHandleHeight;

  static double startHeightFor(Size size) {
    var selectorHeight = maxItemHeight;
    var startItemWidth = size.width / (size.height / selectorHeight);
    if (startItemWidth > maxItemWidth) {
      var shrink = startItemWidth / maxItemWidth;
      return selectorHeight / shrink;
    } else {
      return selectorHeight;
    }
  }

  final TemplateState templateState;
  final AreaState<Area<T>, T> areaState;

  const WidgetSelector(this.templateState, this.areaState, {Key? key}) : super(key: key);

  @override
  WidgetSelectorState createState() => WidgetSelectorState<T>();

  static bool existsIn(BuildContext context) {
    return context.findAncestorStateOfType<WidgetSelectorState>() != null;
  }
}

class WidgetSelectorState<T extends ModuleElement> extends State<WidgetSelector<T>> with TickerProviderStateMixin {
  List<ElementResolver<T>> widgets = [];
  late ScrollController _scrollController;

  T? toDeleteElement;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(widgetSelectorProvider.notifier).state = this;
    });
    loadWidgets();
    _scrollController = ScrollController();
  }

  void loadWidgets() {
    widgets = registry.getWidgetsOf<T>(widget.areaState.context);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      var endScroll = _scrollController.position.maxScrollExtent;
      if (endScroll != 0) {
        _scrollController.customAnimateTo(
          endScroll,
          duration: Duration(milliseconds: (endScroll * 60).round()),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double shrinkFactor(Size size) {
    var heightShrink = WidgetSelector.maxItemHeight / size.height;
    var widthShrink = WidgetSelector.maxItemWidth / size.width;

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

    var index = widgets.indexWhere((r) => r.result == toRemove);
    var newWidget = await registry.getWidget<T>(widget.areaState.context, toRemove.module.copyId());

    setState(() {
      widgets = [
        ...widgets.take(index),
        ElementResolver(newWidget!, toRemove.module.parent),
        ...widgets.skip(index + 1)
      ];
    });
  }

  void onNullElementResolved(ElementResolver<T> element) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        widgets = [...widgets]..remove(element);
      });
    });
  }

  void endDeletion() {
    if (mounted) {
      setState(() {
        toDeleteElement = null;
      });
    }
  }

  double get topEdge => (context.findRenderObject()! as RenderBox).localToGlobal(Offset.zero).dy - 10;

  @override
  Widget build(BuildContext context) {
    List<List<ElementResolver<T>>> groups = [];

    groups = widgets.fold<List<List<ElementResolver<T>>>>([], (groups, widget) {
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
        if (lastWidget.module == widget.module) {
          lastGroup.add(widget);
        } else {
          groups.add([widget]);
        }
      }
      return groups;
    });

    return InheritedTemplate(
      state: widget.templateState,
      child: InheritedArea(
        state: widget.areaState,
        child: GroupTheme(
          theme: widget.areaState.theme,
          child: SizedBox(
            height: WidgetSelector.sheetHeight,
            child: Container(
              decoration: BoxDecoration(
                color: widget.areaState.context.surfaceColor,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: WidgetSelector.outerPadding) +
                        const EdgeInsets.only(top: WidgetSelector.dragHandleHeight),
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      slivers: [
                        const SliverPadding(
                          padding: EdgeInsets.only(left: WidgetSelector.outerPadding),
                        ),
                        for (var group in groups)
                          SliverStickyHeader(
                            overlapsContent: true,
                            header: Builder(builder: (context) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: WidgetSelector.innerPadding, right: WidgetSelector.innerPadding),
                                  child: Text(
                                    group.first.module.getName(context),
                                    style: context.theme.textTheme.caption!.copyWith(color: context.onSurfaceColor),
                                  ),
                                ),
                              );
                            }),
                            sliver: SliverPadding(
                              padding: const EdgeInsets.only(top: WidgetSelector.headerHeight),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(WidgetSelector.innerPadding),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: WidgetSelector.maxItemWidth),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: ValueListenableBuilder<ElementResolver<T>>(
                                            valueListenable: group[index],
                                            builder: (BuildContext context, ElementResolver<T> element, _) {
                                              if (element.result == null) {
                                                if (element.isResolved) {
                                                  onNullElementResolved(element);
                                                }
                                                return ConstrainedBox(
                                                  constraints: widget.areaState.constrainWidget(null),
                                                  child: widget.areaState.elementDecorator.getPlaceholder(context),
                                                );
                                              }
                                              return ConstrainedBox(
                                                constraints: widget.areaState.constrainWidget(element.result!),
                                                child: element.result!,
                                              );
                                            },
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
                        const SliverPadding(
                          padding: EdgeInsets.only(right: WidgetSelector.outerPadding),
                        ),
                      ],
                    ),
                  ),
                  if (toDeleteElement != null)
                    Container(
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.error.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(WidgetSelector.outerPadding + WidgetSelector.innerPadding) +
                              const EdgeInsets.only(top: WidgetSelector.headerHeight + WidgetSelector.dragHandleHeight),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: WidgetSelector.maxItemWidth),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: ConstrainedBox(
                                constraints: widget.areaState.constrainWidget(toDeleteElement!),
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

extension on ScrollController {
  void customAnimateTo(double to, {required Duration duration, required Curve curve}) {
    var pos = position;
    var activity = CustomScrollActivity(
      pos as ScrollActivityDelegate,
      from: pos.pixels,
      to: to,
      duration: duration,
      curve: curve,
      vsync: pos.context.vsync,
    );
    pos.beginActivity(activity);
  }
}

class CustomScrollActivity extends DrivenScrollActivity {
  CustomScrollActivity(ScrollActivityDelegate delegate,
      {required double from,
      required double to,
      required Duration duration,
      required Curve curve,
      required TickerProvider vsync})
      : super(
          delegate,
          from: from,
          to: to,
          duration: duration,
          curve: curve,
          vsync: vsync,
        );

  @override
  bool get shouldIgnorePointer => false;
}
