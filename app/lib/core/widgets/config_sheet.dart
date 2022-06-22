import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../core.dart';
import '../providers/editing_providers.dart';
import '../providers/selected_area_provider.dart';

class ConfigSheet<T extends TemplateModel> extends StatefulWidget {
  const ConfigSheet({Key? key}) : super(key: key);

  @override
  State<ConfigSheet<T>> createState() => _ConfigSheetState<T>();
}

class _ConfigSheetState<T extends TemplateModel> extends State<ConfigSheet<T>> {
  final controller = DraggableScrollableController();

  bool widgetsTab = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    context.watch(activeLayoutProvider);

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

            if (contentHeight <= WidgetSelector.dragHandleHeight + 2) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                context.read(editProvider.notifier).endEditing();
              });
            }

            var f = max(
                0.0,
                (contentHeight - WidgetSelector.sheetHeight) /
                    (constraints.maxHeight / 2 - WidgetSelector.sheetHeight));

            return ThemedSurface(
              preference: const ColorPreference(deltaElevation: 0),
              builder: (context, color) => Container(
                decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -4)],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(WidgetSelector.dragHandleHeight / 2)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(WidgetSelector.dragHandleHeight / 2)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Material(
                    color: color,
                    child: Builder(builder: (context) {
                      var selectedArea = context.watch(selectedAreaProvider);

                      AreaState? area;
                      TemplateState? template;
                      if (selectedArea != null) {
                        template = Template.of(context, listen: false);
                        var candidate = template.widgetAreas[selectedArea];
                        if (candidate != null && candidate.mounted && candidate.isActive) {
                          area = template.widgetAreas[selectedArea]!;
                        }
                      }

                      return Stack(
                        children: [
                          Container(
                            color: (widgetsTab && area != null ? area.context.surfaceColor : color),
                            child: ListView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              children: [
                                if (area != null)
                                  Offstage(
                                    offstage: !widgetsTab,
                                    child: SizedBox(
                                      height: max(WidgetSelector.sheetHeight, contentHeight),
                                      child: area.callTyped(<E extends ModuleElement>() {
                                        return WidgetSelector<E>(
                                          template!,
                                          area as AreaState<Area<E>, E>,
                                          expand: f,
                                          key: GlobalObjectKey(area),
                                        );
                                      }),
                                    ),
                                  ),
                                if (area == null || !widgetsTab) ...[
                                  const SizedBox(height: WidgetSelector.dragHandleHeight),
                                  ...settings,
                                ],
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            height: WidgetSelector.dragHandleHeight,
                            child: CustomPaint(
                              painter: DragTabsPainter(
                                rightActive: widgetsTab && area != null,
                                leftColor: color,
                                rightColor: area?.context.surfaceColor ??
                                    Color.alphaBlend(context.onSurfaceColor.withOpacity(0.04), color),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        setState(() => widgetsTab = false);
                                      },
                                      child: widgetsTab && area != null
                                          ? Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'LAYOUT',
                                                style: context.theme.textTheme.caption!.copyWith(
                                                    color: context.onSurfaceColor.withOpacity(0.5),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: WidgetSelector.dragHandleHeight / 2),
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                                          color: (widgetsTab && area != null
                                                  ? area.context.onSurfaceColor
                                                  : context.onSurfaceColor)
                                              .withOpacity(0.8),
                                        ),
                                        height: 4,
                                        width: 80,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        setState(() => widgetsTab = true);
                                      },
                                      child: !widgetsTab || area == null
                                          ? Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'WIDGETS',
                                                style: context.theme.textTheme.caption!.copyWith(
                                                    color: area?.context.onSurfaceColor.withOpacity(0.5) ??
                                                        Color.alphaBlend(
                                                            context.onSurfaceColor.withOpacity(0.08), color),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ],
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

class DragTabsPainter extends CustomPainter {
  final bool rightActive;
  final Color leftColor;
  final Color? rightColor;

  DragTabsPainter({required this.rightActive, required this.leftColor, required this.rightColor});

  @override
  bool? hitTest(Offset position) => false;

  @override
  void paint(Canvas canvas, Size size) {
    var w = size.width, h = size.height;

    if (rightColor == null) return;

    var cpath = Path();

    if (rightActive) {
      cpath.moveTo(0, 0);
      cpath.lineTo(w / 2 - 40, 0);
      cpath.arcToPoint(Offset(w / 2 - 40 - h / 2, h / 2), radius: Radius.circular(h / 2), clockwise: false);
      cpath.arcToPoint(Offset(w / 2 - 40 - h, h), radius: Radius.circular(h / 2));
      cpath.lineTo(0, h);
    } else {
      cpath.moveTo(w / 2 + 40, 0);
      cpath.arcToPoint(Offset(w / 2 + 40 + h / 2, h / 2), radius: Radius.circular(h / 2));
      cpath.arcToPoint(Offset(w / 2 + 40 + h, h), radius: Radius.circular(h / 2), clockwise: false);
      cpath.lineTo(w, h);
      cpath.lineTo(w, 0);
    }
    cpath.close();

    canvas.clipPath(cpath);

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 2), Paint()..color = (rightActive ? null : rightColor) ?? leftColor);

    var path = Path();

    if (rightActive) {
      path.moveTo(0, h);
      path.lineTo(w / 2 - 40 - size.height, h);
      path.arcToPoint(Offset(w / 2 - 40 - size.height / 2, h / 2),
          radius: Radius.circular(size.height / 2), clockwise: false);
      path.arcToPoint(Offset(w / 2 - 40, 0), radius: Radius.circular(size.height / 2));
      path.lineTo(w, 0);
      path.lineTo(w, h * 2);
      path.lineTo(0, h * 2);
    } else {
      path.moveTo(0, 0);
      path.lineTo(w / 2 + 40, 0);
      path.arcToPoint(Offset(w / 2 + 40 + h / 2, h / 2), radius: Radius.circular(h / 2));
      path.arcToPoint(Offset(w / 2 + 40 + h, h), radius: Radius.circular(h / 2), clockwise: false);
      path.lineTo(w, h);
      path.lineTo(w, h * 2);
      path.lineTo(0, h * 2);
    }
    path.close();

    canvas.drawShadow(path.shift(Offset(rightActive ? -1 : 1, -3)), Colors.black87, 3, true);

    //canvas.drawPath(path, Paint()..color = rightActive ? rightColor! : leftColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
