import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../areas/areas.dart';
import '../module/module.dart';
import '../templates/templates.dart';
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
        child: InheritedThemeState(
          theme: area.theme,
          reuseTheme: true,
          child: Consumer(
            builder: (context, watch, child) {
              var offset = watch(dragOffsetProvider).state!;
              var size = watch(dragSizeProvider).state!;
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
              builder: (context, watch, child) {
                var decOpacity = watch(dragDecorationOpacityProvider).state;
                return decorationBuilder(child!, decOpacity);
              },
              child: IgnorePointer(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: Consumer(builder: (context, watch, _) => watch(dragWidgetProvider).state!),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
