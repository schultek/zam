import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core.dart';
import '../../pages/group_settings_builder.dart';
import '../editing_providers.dart';
import '../selected_area_provider.dart';
import 'config_tabs_painter.dart';

class ConfigSheet<T extends TemplateModel> extends StatefulWidget {
  const ConfigSheet({Key? key}) : super(key: key);

  @override
  State<ConfigSheet<T>> createState() => _ConfigSheetState<T>();
}

final dragHeightProvider = Provider((ref) => 0.0);
final sheetExpandedProvider = Provider((ref) => 0.0);

enum ConfigTab { settings, layout, widgets }

class _ConfigSheetState<T extends TemplateModel> extends State<ConfigSheet<T>> {
  final controller = DraggableScrollableController();

  ConfigTab tab = ConfigTab.widgets;

  @override
  Widget build(BuildContext context) {
    var template = Template.of(context, listen: false);

    AreaState? area;
    var areaId = context.watch(selectedAreaProvider);
    if (areaId != null) {
      var candidate = template.widgetAreas[areaId];
      if (candidate != null && candidate.mounted && candidate.isActive) {
        area = template.widgetAreas[areaId]!;
      }
    }

    var currentTab = tab;
    if (area == null && currentTab == ConfigTab.widgets) {
      currentTab = ConfigTab.layout;
    }

    Widget? widgetSelector;
    if (area != null) {
      widgetSelector = area.callTyped(<E extends ModuleElement>() {
        return WidgetSelector<E>(
          template,
          area as AreaState<Area<E>, E>,
          key: GlobalObjectKey(area),
        );
      });
    }

    context.watch(activeLayoutProvider);
    var layoutSettings = template.getPageSettings();
    var groupSettings = GroupSettingsBuilder().build(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        var sh = WidgetSelector.sheetHeight;
        var dragSize = WidgetSelector.dragHandleHeight / constraints.maxHeight;
        var sheetSize = sh / constraints.maxHeight;

        return DraggableScrollableSheet(
          initialChildSize: sheetSize,
          minChildSize: dragSize,
          maxChildSize: currentTab == ConfigTab.widgets ? 0.5 : 0.8,
          snap: true,
          snapSizes: [sheetSize, 0.5],
          controller: controller,
          builder: (context, scrollController) {
            var contentHeight = controller.pixels;

            if (contentHeight <= WidgetSelector.dragHandleHeight + 2) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                context.read(editProvider.notifier).endEditing();
              });
            }

            var expand = max(0.0, min(1.0, (contentHeight - sh) / (constraints.maxHeight / 2 - sh)));

            return ProviderScope(
              overrides: [
                sheetExpandedProvider.overrideWithValue(expand),
              ],
              child: ThemedSurface(
                preference: const ColorPreference(deltaElevation: 0),
                builder: (context, color) => Container(
                  decoration: const BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -4)],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(WidgetSelector.dragHandleHeight / 2),
                    ),
                  ),
                  child: ConfigTabsPainter(
                    activeTab: currentTab,
                    onTabChanged: (nextTab) {
                      if (area == null && nextTab == ConfigTab.widgets) return;
                      setState(() => tab = nextTab);
                    },
                    area: area,
                    child: ListView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        if (widgetSelector != null)
                          Offstage(
                            offstage: currentTab != ConfigTab.widgets,
                            child: SizedBox(
                              height: max(WidgetSelector.sheetHeight, contentHeight),
                              child: widgetSelector,
                            ),
                          ),
                        if (currentTab != ConfigTab.widgets) const SizedBox(height: WidgetSelector.dragHandleHeight),
                        if (currentTab == ConfigTab.layout) ...layoutSettings,
                        if (currentTab == ConfigTab.settings) ...groupSettings,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
