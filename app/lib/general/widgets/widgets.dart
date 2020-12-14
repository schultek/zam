library widgets;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jufa/general/areas/areas.dart';
import 'package:jufa/general/module/Module.dart';
import 'package:jufa/general/route/route.dart';
import 'package:jufa/general/templates/templates.dart';

part 'BodySegment.dart';
part 'QuickAction.dart';
part 'HeaderSegment.dart';

class ModuleWidgetBuilder<T extends ModuleWidget> extends StatelessWidget {
  final Key key;
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context) placeholderBuilder;

  ModuleWidgetBuilder({@required this.key, @required this.builder, @required this.placeholderBuilder});

  @override
  Widget build(BuildContext context) {
    if (WidgetSelector.existsIn(context)) {
      return ReorderableItem(
        key: key,
        builder: (context, state, child) {
          return state == ReorderableState.placeholder ? placeholderBuilder(context) : child;
        },
        child: ReorderableListener<T>(
          delay: Duration(milliseconds: 200),
          child: AbsorbPointer(child: builder(context)),
        ),
      );
    }

    var moduleWidget = builder(context);

    return ReorderableItem(
      key: key,
      builder: (context, state, child) {
        if (state == ReorderableState.placeholder) {
          return placeholderBuilder(context);
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
          return AbsorbPointer(child: moduleWidget);
        }
      },
      child: RemovableDraggableModuleWidget<T>(
        key: key,
        child: moduleWidget,
      ),
    );
  }
}

class RemovableDraggableModuleWidget<T extends ModuleWidget> extends StatelessWidget {
  final Key key;
  final Widget child;
  RemovableDraggableModuleWidget({this.key, this.child});

  @override
  Widget build(BuildContext context) {
    var templateState = WidgetTemplate.of(context, listen: true);

    if (templateState.isEditing) {
      return Stack(children: [
        ReorderableListener<T>(
          delay: Duration(milliseconds: 100),
          child: AbsorbPointer(child: child),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: templateState.transition,
            builder: (context, child) {
              return ClipOval(
                clipper: ScalingClipper(templateState.transition.value, const Offset(12, 12)),
                child: child,
              );
            },
            child: Material(
              color: Colors.red, // button color
              child: InkWell(
                splashColor: Colors.redAccent, // inkwell color
                child: SizedBox(width: 24, height: 24, child: Icon(Icons.close, size: 15, color: Colors.white)),
                onTap: () {
                  var areaState = WidgetArea.of(context, listen: false);
                  areaState.removeWidget(key);
                },
              ),
            ),
          ),
        ),
      ]);
    } else {
      return ModuleRouteTransition(child: child);
    }
  }
}

class PhasedAnimation extends CompoundAnimation<double> {
  double shift;

  PhasedAnimation({phase, intensity, this.shift = 0.0}) : super(first: phase, next: intensity);

  @override
  double get value {
    var phase = this.first.value + shift;
    phase = phase > 1 ? phase - 1 : phase;
    phase *= 2;
    phase = phase > 1 ? 2 - phase : phase;
    return phase * this.next.value;
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
      width: size.width * this.value,
      height: size.height * this.value,
    );
  }

  @override
  bool shouldReclip(ScalingClipper oldClipper) => oldClipper.value != value;
}
