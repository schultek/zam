import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../modules/modules.dart';
import '../../core.dart';
import '../../reorderable/drag_item.dart';
import '../../widgets/child_builder.dart';
import 'config_sheet.dart';
import 'expand_shadow_painter.dart';
import 'measure_size.dart';

final widgetSelectorProvider = StateProvider<WidgetSelectorState?>((ref) => null);

typedef ElementGroup<T extends ModuleElement> = List<MapEntry<int, ElementResolver<T>>>;

class WidgetSelector<T extends ModuleElement> extends StatefulWidget {
  static const double itemPadding = 10;
  static const double headerHeight = 12;
  static const double maxItemHeight = 90;
  static const double maxItemWidth = 100;
  static const double dragHandleHeight = 32;
  static late double sheetHeight = maxItemHeight + itemPadding * 4 + headerHeight + dragHandleHeight;

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
  Map<int, Size> childSizes = {};
  double extentPadding = 100;

  ValueNotifier<double> scrollFocus = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(widgetSelectorProvider.notifier).state = this;
    });
    loadWidgets();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      var index = calcScrollIndex(_scrollController.offset, context.read(sheetExpandedProvider));
      scrollFocus.value = index;
    });
  }

  double calcScrollIndex(double offset, double expand) {
    var padding = WidgetSelector.itemPadding * 2 + expand * extentPadding;
    var curr = 0.0;
    var f = 0.0;
    for (var i = 0; i < widgets.length; i++) {
      var itemWidth = childSizes[i]?.width ?? WidgetSelector.maxItemWidth;
      if (curr + itemWidth + padding > offset) {
        f += (offset - curr) / (itemWidth + padding);
        break;
      } else {
        curr += itemWidth + padding;
        f++;
      }
    }
    return max(0, f);
  }

  void setScrollIndex(double index, double expand) {
    var padding = WidgetSelector.itemPadding * 2 + expand * extentPadding;
    var offset = 0.0;
    for (var i = 0; i < widgets.length; i++) {
      var itemWidth = childSizes[i]?.width ?? WidgetSelector.maxItemWidth;
      if (i == index.floor()) {
        offset += (itemWidth + padding) * (index - i);
        break;
      } else {
        offset += itemWidth + padding;
      }
    }
    _scrollController.jumpTo(offset);
  }

  void loadWidgets() {
    widgets = registry.getElementsOf<T>(widget.areaState.context);
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

    var resolver = widgets.firstWhere((r) => r.result == toRemove);
    var index = widgets.indexOf(resolver);
    var newWidget = await registry.getWidget<T>(widget.areaState.context, toRemove.module.copyId());

    setState(() {
      widgets = [
        ...widgets.take(index),
        ElementResolver(newWidget!, resolver.element, resolver.module),
        ...widgets.skip(index + 1)
      ];
    });
  }

  void onNullElementResolved(ElementResolver<T> element) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          widgets = [...widgets]..remove(element);
        });
      }
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

  double childWidth(int index) => childSizes[index]?.width ?? WidgetSelector.maxItemHeight;

  @override
  Widget build(BuildContext context) {
    context.listen<double>(sheetExpandedProvider, (prev, next) {
      if (prev != null && _scrollController.hasClients && _scrollController.position.haveDimensions) {
        var oldIndex = calcScrollIndex(_scrollController.offset, prev);
        setScrollIndex(oldIndex, next);
      }
    });

    extentPadding = MediaQuery.of(context).size.width -
        WidgetSelector.maxItemWidth -
        WidgetSelector.itemPadding * 4 -
        WidgetSelector.maxItemHeight / 2;

    List<ElementGroup<T>> groups = [];

    groups = widgets.foldIndexed<List<ElementGroup<T>>>([], (index, groups, widget) {
      if (groups.isEmpty) {
        return [
          [MapEntry(index, widget)]
        ];
      }
      var lastGroup = groups.last;
      if (lastGroup.isEmpty) {
        lastGroup.add(MapEntry(index, widget));
      } else {
        var lastWidget = lastGroup.last;
        if (lastWidget.value.module == widget.module) {
          lastGroup.add(MapEntry(index, widget));
        } else {
          groups.add([MapEntry(index, widget)]);
        }
      }
      return groups;
    });

    return InheritedDragState(
      state: ElementDragState.selectable,
      child: InheritedTemplate(
        state: widget.templateState,
        child: InheritedArea(
          state: widget.areaState,
          child: GroupTheme(
            theme: widget.areaState.theme,
            child: Container(
              decoration: BoxDecoration(
                color: widget.areaState.context.surfaceColor,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: WidgetSelector.dragHandleHeight + WidgetSelector.itemPadding,
                    ),
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      cacheExtent: double.infinity,
                      slivers: [
                        for (var group in groups) _groupSliver(group),
                        const SliverToBoxAdapter(
                          child: SizedBox(width: WidgetSelector.itemPadding * 2),
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
                          padding: const EdgeInsets.all(WidgetSelector.itemPadding * 2) +
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

  Widget _groupSliver(ElementGroup<T> group) {
    return SliverStickyHeader(
      overlapsContent: true,
      header: Builder(builder: (context) {
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: WidgetSelector.itemPadding * 2,
            ),
            child: Builder(builder: (context) {
              var expand = context.watch(sheetExpandedProvider);
              return Text(
                group.first.value.module.getName(context),
                style: context.theme.textTheme.caption!.apply(
                  color: context.onSurfaceColor,
                  fontSizeDelta: -2 + 4 * expand,
                  fontWeightDelta: 100,
                ),
              );
            }),
          ),
        );
      }),
      sliver: ChildBuilder(
        builder: (context, child) {
          var expand = context.watch(sheetExpandedProvider);
          return SliverPadding(
            padding: EdgeInsets.only(
              top: WidgetSelector.headerHeight + 4 * expand,
            ),
            sliver: child,
          );
        },
        child: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ChildBuilder(
                builder: (context, child) {
                  var expand = context.watch(sheetExpandedProvider);
                  return CustomPaint(
                    foregroundPainter: ShadowPainter(expand),
                    child: ValueListenableBuilder<double>(
                      valueListenable: scrollFocus,
                      builder: (context, focus, _) {
                        var i = group[index].key;
                        var inFocus = max(0, 1 - (focus - i).abs());
                        return Opacity(
                          opacity: min(1.0, (1 - expand) + Curves.easeOut.transform(0.4 + inFocus * 0.6)),
                          child: Transform.scale(
                            scale: min(1.0, (1 - expand) + Curves.easeOut.transform(0.7 + inFocus * 0.3)),
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: WidgetSelector.itemPadding,
                    left: WidgetSelector.itemPadding * 2,
                  ),
                  child: Stack(
                    fit: StackFit.passthrough,
                    clipBehavior: Clip.none,
                    children: [
                      ChildBuilder(
                        builder: (context, child) {
                          var expand = context.watch(sheetExpandedProvider);
                          return Positioned(
                            top: 0,
                            left: 0,
                            width: childWidth(group[index].key) + WidgetSelector.itemPadding + expand * extentPadding,
                            height: WidgetSelector.maxItemHeight,
                            child: AnimatedPadding(
                              padding: EdgeInsets.only(
                                left: childWidth(group[index].key) + WidgetSelector.itemPadding + (1 - expand) * -20,
                              ),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutBack,
                              child: Opacity(
                                opacity: Curves.easeOutExpo.transform(expand),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                            width: extentPadding,
                            padding: const EdgeInsets.only(
                              left: WidgetSelector.itemPadding,
                              right: WidgetSelector.itemPadding,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group[index].value.element.getTitle(context),
                                  style: context.theme.textTheme.titleLarge!.copyWith(color: context.onSurfaceColor),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  group[index].value.element.getSubtitle(context),
                                  style: TextStyle(color: context.onSurfaceColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ChildBuilder(
                        builder: (context, child) {
                          var expand = context.watch(sheetExpandedProvider);
                          return Padding(
                            padding: EdgeInsets.only(
                              right: expand * extentPadding,
                              bottom: WidgetSelector.itemPadding * 2,
                            ),
                            child: child,
                          );
                        },
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            height: WidgetSelector.maxItemHeight,
                            child: MeasureSize(
                              onChange: (size) {
                                setState(() => childSizes[group[index].key] = size);
                              },
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: WidgetSelector.maxItemHeight,
                                  maxWidth: WidgetSelector.maxItemWidth,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: ValueListenableBuilder<ElementResolver<T>>(
                                    valueListenable: group[index].value,
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
                            ),
                          ),
                        ),
                      ),
                      ChildBuilder(
                        builder: (context, child) {
                          var expand = context.watch(sheetExpandedProvider);
                          return Positioned(
                            top: WidgetSelector.maxItemHeight,
                            left: 0,
                            bottom: 0,
                            width: childWidth(group[index].key) + expand * extentPadding + WidgetSelector.itemPadding,
                            child: child,
                          );
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Container(
                              width: childWidth(group[index].key) + extentPadding,
                              padding: const EdgeInsets.only(
                                top: WidgetSelector.itemPadding * 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.onSurfaceHighlightColor.withOpacity(0.05),
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                ),
                                padding: const EdgeInsets.all(WidgetSelector.itemPadding),
                                child: DefaultTextStyle(
                                  style: TextStyle(color: context.onSurfaceColor),
                                  textAlign: TextAlign.justify,
                                  child: group[index].value.element.buildDescription(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: group.length,
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
