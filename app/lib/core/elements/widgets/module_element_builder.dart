import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../areas/widget_area.dart';
import '../../providers/editing_providers.dart';
import '../../reorderable/reorderable_item.dart';
import '../../reorderable/reorderable_listener.dart';
import '../../widgets/widget_selector.dart';
import '../decorators/element_decorator.dart';
import '../module_element.dart';
import 'removable_draggable_module_widget.dart';

mixin ModuleElementBuilder<T extends ModuleElement> on ModuleElement {
  ElementDecorator<T> decorator(BuildContext context) => WidgetArea.of<T>(context)!.elementDecorator;

  T get element;

  Widget buildElement(BuildContext context);

  Widget _decorationBuilder(BuildContext context, Widget child, double opacity) {
    return decorator(context).decorateDragged(context, element, child, opacity);
  }

  @override
  Widget build(BuildContext context) {
    if (WidgetSelector.existsIn(context)) {
      return ReorderableItem(
        key: key,
        builder: (context, state, child) {
          if (state == ReorderableState.placeholder) {
            return decorator(context).decoratePlaceholder(context, element);
          } else {
            return child;
          }
        },
        decorationBuilder: _decorationBuilder,
        child: ReorderableListener<T>(
          delay: const Duration(milliseconds: 200),
          child: AbsorbPointer(child: Builder(builder: buildElement)),
        ),
      );
    }

    return ReorderableItem(
      key: key,
      builder: (context, state, child) {
        if (state == ReorderableState.placeholder) {
          return decorator(context).decoratePlaceholder(context, element);
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
          return AbsorbPointer(child: Builder(builder: buildElement));
        }
      },
      decorationBuilder: _decorationBuilder,
      child: RemovableDraggableModuleWidget<T>(
        key: key,
        element: element,
        child: Builder(builder: buildElement),
      ),
    );
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
    var transition = context.read(transitionControllerProvider)!.view;
    var wiggle = context.read(wiggleControllerProvider)!.view;
    return PhasedAnimation(phase: wiggle, intensity: transition, shift: Random().nextDouble());
  }
}
