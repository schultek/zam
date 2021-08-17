library elements;

import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/segment_size.dart';
import '../areas/areas.dart';
import '../module/module.dart';
import '../reorderable/reorderable_item.dart';
import '../reorderable/reorderable_listener.dart';
import '../route/route.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';
import '../widgets/widget_selector.dart';

part 'content_segment.dart';
part 'page_segment.dart';
part 'quick_action.dart';

mixin ModuleElementBuilder<T extends ModuleElement> on ModuleElement {
  Widget buildElement(BuildContext context);
  Widget buildPlaceholder(BuildContext context);
  Widget decorationBuilder(Widget child, double opacity);

  @override
  Widget build(BuildContext context) {
    if (WidgetSelector.existsIn(context)) {
      return ReorderableItem(
        key: key,
        builder: (context, state, child) {
          return state == ReorderableState.placeholder ? buildPlaceholder(context) : child;
        },
        decorationBuilder: decorationBuilder,
        child: ReorderableListener<T>(
          delay: const Duration(milliseconds: 200),
          child: AbsorbPointer(child: buildElement(context)),
        ),
      );
    }

    return ReorderableItem(
      key: key,
      builder: (context, state, child) {
        if (state == ReorderableState.placeholder) {
          return buildPlaceholder(context);
        } else if (state == ReorderableState.normal) {
          var animation = CurvedAnimation(parent: PhasedAnimation.of(context), curve: Curves.easeInOut);
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: (animation.value - 0.5) * 0.015,
                child: child,
              );
            },
            child: child,
          );
        } else {
          return AbsorbPointer(child: buildElement(context));
        }
      },
      decorationBuilder: decorationBuilder,
      child: RemovableDraggableModuleWidget<T>(
        key: key,
        child: Builder(builder: buildElement),
      ),
    );
  }
}

class RemovableDraggableModuleWidget<T extends ModuleElement> extends StatelessWidget {
  final Widget child;
  const RemovableDraggableModuleWidget({required Key key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var templateState = WidgetTemplate.of(context);

    if (templateState.isEditing) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Stack(clipBehavior: Clip.none, children: [
            ConstrainedBox(
              constraints: constraints,
              child: ReorderableListener<T>(
                delay: const Duration(milliseconds: 300),
                child: AbsorbPointer(child: child),
              ),
            ),
            Positioned(
              top: -5,
              left: -5,
              child: AnimatedBuilder(
                animation: templateState.transition,
                builder: (context, child) {
                  return Transform.scale(
                    scale: templateState.transition.value,
                    child: FittedBox(
                      child: child,
                    ),
                  );
                },
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  shadowColor: Colors.black54,
                  elevation: 4,
                  color: Colors.red, // button color
                  child: InkWell(
                    splashColor: Colors.redAccent,
                    onTap: () {
                      var areaState = WidgetArea.of<T>(context)!;
                      areaState.removeWidget(key!);
                    }, // inkwell color
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(Icons.close, size: 15, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ]);
        },
      );
    } else {
      return ModuleRouteTransition(child: child);
    }
  }
}

class PhasedAnimation extends CompoundAnimation<double> {
  double shift;

  PhasedAnimation({required Animation<double> phase, required Animation<double> intensity, this.shift = 0.0})
      : super(first: phase, next: intensity);

  @override
  double get value {
    var phase = (first.value + shift > 1 ? first.value + shift - 1 : first.value + shift) * 2;
    phase = phase > 1 ? 2 - phase : phase;
    return ((phase - 0.5) * next.value) + 0.5;
  }

  factory PhasedAnimation.of(BuildContext context) {
    var state = WidgetTemplate.of(context, listen: false);
    return PhasedAnimation(phase: state.wiggle, intensity: state.transition, shift: Random().nextDouble());
  }
}

class ScalingClipper extends CustomClipper<Rect> {
  double value;
  Offset center;

  ScalingClipper(this.value, this.center);

  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
      center: center,
      width: size.width * value,
      height: size.height * value,
    );
  }

  @override
  bool shouldReclip(ScalingClipper oldClipper) => oldClipper.value != value;
}
