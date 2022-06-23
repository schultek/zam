import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core.dart';
import '../editing_providers.dart';
import '../selected_area_provider.dart';
import 'drag_tabs_painter.dart';

class ConfigSheet<T extends TemplateModel> extends StatefulWidget {
  const ConfigSheet({Key? key}) : super(key: key);

  @override
  State<ConfigSheet<T>> createState() => _ConfigSheetState<T>();
}

final dragHeightProvider = Provider((ref) => 0.0);
final sheetExpandedProvider = Provider((ref) => 0.0);

class _ConfigSheetState<T extends TemplateModel> extends State<ConfigSheet<T>> {
  final controller = DraggableScrollableController();

  AreaState? area;
  bool widgetsTab = true;

  @override
  Widget build(BuildContext context) {
    area = null;
    var areaId = context.watch(selectedAreaProvider);
    if (areaId != null) {
      var template = Template.of(context, listen: false);
      var candidate = template.widgetAreas[areaId];
      if (candidate != null && candidate.mounted && candidate.isActive) {
        area = template.widgetAreas[areaId]!;
      }
    }

    Widget? widgetSelector;
    if (area != null) {
      widgetSelector = area!.callTyped(<E extends ModuleElement>() {
        return WidgetSelector<E>(
          Template.of(context, listen: false),
          area as AreaState<Area<E>, E>,
          key: GlobalObjectKey(area!),
        );
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        var sh = WidgetSelector.sheetHeight;
        var dragSize = WidgetSelector.dragHandleHeight / constraints.maxHeight;
        var sheetSize = sh / constraints.maxHeight;

        return DraggableScrollableSheet(
          initialChildSize: sheetSize,
          minChildSize: dragSize,
          maxChildSize: 0.5,
          snap: true,
          snapSizes: [dragSize, sheetSize, 0.5],
          controller: controller,
          builder: (context, scrollController) {
            var contentHeight = controller.pixels;

            if (contentHeight <= WidgetSelector.dragHandleHeight + 2) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                context.read(editProvider.notifier).endEditing();
              });
            }

            var expand = max(0.0, (contentHeight - sh) / (constraints.maxHeight / 2 - sh));

            return ProviderScope(
              overrides: [
                sheetExpandedProvider.overrideWithValue(expand),
              ],
              child: _dragSheet(scrollController, contentHeight, widgetSelector),
            );
          },
        );
      },
    );
  }

  Widget _dragSheet(ScrollController scrollController, double contentHeight, Widget? widgetSelector) {
    return ThemedSurface(
      preference: const ColorPreference(deltaElevation: 0),
      builder: (context, color) => Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -4)],
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(WidgetSelector.dragHandleHeight / 2),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(WidgetSelector.dragHandleHeight / 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(WidgetSelector.dragHandleHeight / 2),
            ),
            child: Stack(
              children: [
                _configPanel(scrollController, contentHeight, widgetSelector),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: WidgetSelector.dragHandleHeight,
                  child: _dragTabs(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _configPanel(
    ScrollController scrollController,
    double contentHeight,
    Widget? widgetSelector,
  ) {
    return Container(
      color: widgetsTab && area != null ? area!.context.surfaceColor : context.surfaceColor,
      child: Builder(builder: (context) {
        context.watch(activeLayoutProvider);

        var template = Template.of(context, listen: false);
        var settings = template.getPageSettings();

        return ListView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            if (widgetSelector != null)
              Offstage(
                offstage: !widgetsTab,
                child: SizedBox(
                  height: max(WidgetSelector.sheetHeight, contentHeight),
                  child: widgetSelector,
                ),
              ),
            if (area == null || !widgetsTab) ...[
              const SizedBox(height: WidgetSelector.dragHandleHeight),
              ...settings,
            ],
          ],
        );
      }),
    );
  }

  Widget _dragTabs() {
    return CustomPaint(
      painter: DragTabsPainter(
        rightActive: widgetsTab && area != null,
        leftColor: context.surfaceColor,
        rightColor: area?.context.surfaceColor ??
            Color.alphaBlend(context.onSurfaceColor.withOpacity(0.04), context.surfaceColor),
      ),
      child: Row(
        children: [
          _tabTitle(
            label: 'LAYOUT',
            active: widgetsTab && area != null,
            value: false,
            color: context.onSurfaceColor.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: WidgetSelector.dragHandleHeight / 2),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: (widgetsTab && area != null ? area!.context.onSurfaceColor : context.onSurfaceColor)
                      .withOpacity(0.8),
                ),
                height: 4,
                width: 80,
              ),
            ),
          ),
          _tabTitle(
            label: 'WIDGETS',
            active: !widgetsTab || area == null,
            value: true,
            color: area?.context.onSurfaceColor.withOpacity(0.5) ??
                Color.alphaBlend(context.onSurfaceColor.withOpacity(0.08), context.surfaceColor),
          ),
        ],
      ),
    );
  }

  Widget _tabTitle({required String label, required bool active, required bool value, required Color color}) {
    return Flexible(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() => widgetsTab = value);
        },
        child: active
            ? Align(
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: context.theme.textTheme.caption!.copyWith(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
