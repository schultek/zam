import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../areas/areas.dart';
import '../elements/elements.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';
import 'drag_provider.dart';
import 'reorderable_item.dart';

class DragItemWidget<T extends ModuleElement> extends StatelessWidget {
  final AreaState<Area<T>, T> area;
  final BoxConstraints elementConstraints;
  final Animation<double> scaleAnimation;
  final DecorationBuilder decorationBuilder;

  const DragItemWidget(
      {Key? key,
      required this.area,
      required this.elementConstraints,
      required this.scaleAnimation,
      required this.decorationBuilder})
      : super(key: key);

  double scaledHeight(Size size) => lerpDouble(
        area.template.widgetSelector?.state?.startHeightFor(size) ?? size.height,
        size.height,
        scaleAnimation.value,
      )!;

  @override
  Widget build(BuildContext context) {
    return InheritedTemplate(
      state: area.template,
      child: InheritedArea<T>(
        state: area,
        child: GroupTheme(
          theme: area.theme,
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
                  child: ConstrainedBox(
                    constraints: elementConstraints,
                    child: child,
                  ),
                ),
              );
            },
            child: IgnorePointer(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: Consumer(
                  builder: (context, ref, child) {
                    var decOpacity = ref.watch(dragDecorationOpacityProvider);
                    return decorationBuilder(context, child!, decOpacity);
                  },
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
