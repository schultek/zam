import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../areas/areas.dart';
import '../module/module.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';
import 'drag_provider.dart';
import 'reorderable_item.dart';

class DragItemWidget<T extends ModuleElement> extends StatelessWidget {
  final WidgetAreaState<WidgetArea<T>, T> area;
  final Animation<double> scaleAnimation;
  final DecorationBuilder decorationBuilder;

  const DragItemWidget({Key? key, required this.area, required this.scaleAnimation, required this.decorationBuilder})
      : super(key: key);

  double scaledHeight(Size size) =>
      lerpDouble(area.template.widgetSelector!.state!.itemHeight, size.height, scaleAnimation.value)!;

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetTemplate(
      state: area.template,
      child: InheritedWidgetArea<T>(
        state: area,
        child: TripTheme(
          theme: area.theme,
          reuseTheme: true,
          child: Consumer(
            builder: (context, ref, child) {
              var offset = ref.watch(dragOffsetProvider)!;
              var size = ref.watch(dragSizeProvider)!;
              return AnimatedBuilder(
                animation: scaleAnimation,
                builder: (context, child) {
                  return Positioned.fromRect(
                    rect: Rect.fromCenter(
                      center: offset,
                      width: scaledHeight(size) / size.height * size.width,
                      height: scaledHeight(size),
                    ),
                    child: child!,
                  );
                },
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: SizedBox.fromSize(
                    size: size,
                    child: child,
                  ),
                ),
              );
            },
            child: Consumer(
              builder: (context, ref, child) {
                var decOpacity = ref.watch(dragDecorationOpacityProvider);
                return decorationBuilder(child!, decOpacity);
              },
              child: IgnorePointer(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: Consumer(builder: (context, ref, _) => ref.watch(dragWidgetProvider)!),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
