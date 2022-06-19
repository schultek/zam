import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/groups/selected_group_provider.dart';
import '../../areas/area.dart';
import '../../providers/editing_providers.dart';
import '../../providers/selected_area_provider.dart';
import '../../reorderable/reorderable_item.dart';
import '../../reorderable/reorderable_listener.dart';
import '../../route/route.dart';
import '../../templates/template.dart';
import '../../themes/themes.dart';
import '../../widgets/widget_selector.dart';
import '../decorators/element_decorator.dart';
import '../module_element.dart';
import 'element_icon_button.dart';
import 'element_settings_button.dart';

mixin ElementMixin<T extends ModuleElement> on ModuleElement {
  ElementDecorator<T> decorator(BuildContext context) => Area.of<T>(context)!.elementDecorator;

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
          return Builder(builder: (context) {
            var editState = context.watch(editProvider);

            if (!editState) {
              Widget widget = ModuleRouteTransition<T>(child: child, element: element);
              if (context.read(isOrganizerProvider)) {
                widget = ReorderableListener<T>(
                  childKey: key,
                  delay: const Duration(milliseconds: 800),
                  child: widget,
                );
              }
              return widget;
            } else {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(clipBehavior: Clip.none, children: [
                    ConstrainedBox(
                      constraints: constraints,
                      child: Builder(builder: (context) {
                        var animation = CurvedAnimation(parent: PhasedAnimation.of(context), curve: Curves.easeInOut);
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) => Transform.rotate(
                            angle: (animation.value - 0.5) * 0.015,
                            child: child,
                          ),
                          child: ReorderableListener<T>(
                            childKey: key,
                            delay: const Duration(milliseconds: 300),
                            child: AbsorbPointer(child: child),
                          ),
                        );
                      }),
                    ),
                    Positioned(
                      top: -8,
                      left: -8,
                      child: ElementIconButton(
                        icon: Icons.close,
                        onPressed: () {
                          var areaState = Area.of<T>(context)!;
                          areaState.removeWidget(key);
                          context.read(selectedAreaProvider.notifier).selectWidgetAreaById(areaState.id);
                        },
                        color: context.theme.errorColor,
                        iconColor: Colors.white,
                      ),
                    ),
                    if (settings != null || settingsAction != null)
                      Positioned(
                        top: -8,
                        left: 25,
                        child: ElementSettingsButton(
                          module: element.module,
                          settings: settings,
                          settingsAction: settingsAction,
                        ),
                      ),
                  ]);
                },
              );
            }
          });
        } else {
          return AbsorbPointer(child: child);
        }
      },
      decorationBuilder: _decorationBuilder,
      child: Builder(builder: buildElement),
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
    var wiggle = TemplateState.wiggle;
    return PhasedAnimation(phase: wiggle, intensity: const AlwaysStoppedAnimation(1), shift: Random().nextDouble());
  }
}
