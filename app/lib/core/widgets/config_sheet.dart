import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../core.dart';
import '../layouts/widgets/fill_overscroll.dart';
import '../providers/editing_providers.dart';
import '../providers/selected_area_provider.dart';

class ConfigSheet<T extends TemplateModel> extends StatefulWidget {
  const ConfigSheet({Key? key}) : super(key: key);

  @override
  State<ConfigSheet<T>> createState() => _ConfigSheetState<T>();
}

class _ConfigSheetState<T extends TemplateModel> extends State<ConfigSheet<T>> {
  final controller = DraggableScrollableController();

  WidgetSelector? widgetSelector;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    context.watch(currentPageProvider);

    var state = Template.of(context, listen: false);
    var settings = state.getPageSettings();

    return LayoutBuilder(
      builder: (context, constraints) {
        var dragSize = WidgetSelector.dragHandleHeight / constraints.maxHeight;
        var sheetSize = WidgetSelector.sheetHeight / constraints.maxHeight;
        return DraggableScrollableSheet(
          initialChildSize: sheetSize,
          minChildSize: dragSize,
          maxChildSize: 0.5,
          snap: true,
          snapSizes: [
            dragSize,
            sheetSize,
            0.5,
          ],
          controller: controller,
          builder: (context, scrollController) {
            var contentHeight = controller.pixels;
            var sheetHeight = WidgetSelector.sheetHeight;

            if (contentHeight <= WidgetSelector.dragHandleHeight * 2) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                context.read(editProvider.notifier).endEditing();
              });
            }

            return ThemedSurface(
              preference: const ColorPreference(deltaElevation: 0),
              builder: (context, color) => Container(
                decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -4)],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Material(
                    color: color,
                    child: Builder(builder: (context) {
                      var selectedArea = context.watch(selectedAreaProvider);

                      AreaState? area;
                      if (selectedArea != null) {
                        var template = Template.of(context, listen: false);
                        if (template.widgetAreas[selectedArea]?.mounted ?? false) {
                          area = template.widgetAreas[selectedArea]!;
                        }
                      }

                      var targetHeight = min(constraints.maxHeight / 2, sheetHeight * 2);

                      var scaleFactor = area == null
                          ? 0.0
                          : contentHeight < sheetHeight
                              ? 1.0
                              : max(0.0, 1 - (contentHeight - sheetHeight) / (targetHeight - sheetHeight));

                      return Stack(
                        children: [
                          FillOverscroll(
                            fill: Container(color: scaleFactor > 0 ? area?.context.surfaceColor : color),
                            child: ListView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              children: [
                                if (area != null)
                                  SizedBox(
                                    height: sheetHeight * Curves.easeIn.transform(scaleFactor),
                                    child: SingleChildScrollView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      child: area.callTyped(<E extends ModuleElement>() {
                                        return WidgetSelector<E>(area!.template, area as AreaState<Area<E>, E>,
                                            key: GlobalObjectKey(area));
                                      }),
                                    ),
                                  ),
                                const SizedBox(height: WidgetSelector.dragHandleHeight),
                                ...settings,
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              height: WidgetSelector.dragHandleHeight,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    color: Color.lerp(context.onSurfaceColor, area?.context.onSurfaceColor,
                                            scaleFactor < 0.1 ? scaleFactor * 10 : 1.0)!
                                        .withOpacity(0.8),
                                  ),
                                  height: 4,
                                  width: 80,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
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
