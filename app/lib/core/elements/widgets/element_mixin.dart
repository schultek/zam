import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/groups/selected_group_provider.dart';
import '../../areas/area.dart';
import '../../editing/editing_providers.dart';
import '../../editing/selected_area_provider.dart';
import '../../editing/widgets/widget_selector.dart';
import '../../reorderable/reorderable_item.dart';
import '../../reorderable/reorderable_listener.dart';
import '../../route/route.dart';
import '../../templates/template.dart';
import '../../themes/themes.dart';
import '../decorators/element_decorator.dart';
import '../module_element.dart';
import 'element_icon_button.dart';
import 'element_settings_button.dart';
import 'needs_setup_card.dart';

mixin ElementMixin<T extends ModuleElement> on ModuleElement {
  ElementDecorator<T> _decorator(BuildContext context) => Area.of<T>(context)!.elementDecorator;

  T get element;

  @protected
  Widget buildElement(BuildContext context);

  @protected
  @mustCallSuper
  Widget decorateElement(BuildContext context, Widget child) {
    return _decorator(context).decorateElement(context, this as T, child);
  }

  Widget _decorationBuilder(BuildContext context, Widget child, double opacity) {
    return _decorator(context).decorateDragged(context, element, child, opacity);
  }

  Widget _wrapSettings(Widget w) {
    if (settings is SetupElementSettings) {
      return NeedsSetupCard(
        key: key.copy('setup'),
        setupHint: (settings as SetupElementSettings).hint,
        child: w,
      );
    } else {
      return w;
    }
  }

  Widget wrapElement(Widget Function(Widget) wrapper, Widget child) {
    return wrapper(child);
  }

  WidgetBuilder _wrap(WidgetBuilder builder, Widget Function(BuildContext, WidgetBuilder) wrapper) {
    return (context) => wrapper(context, builder);
  }

  @override
  Widget build(BuildContext context) {
    WidgetBuilder childBuilder = buildElement;

    if (settings is SetupElementSettings) {
      childBuilder = _wrap(childBuilder, (c, b) => wrapElement((child) => Opacity(opacity: 0.4, child: child), b(c)));
    }

    childBuilder = _wrap(childBuilder, (c, b) => decorateElement(c, b(c)));

    var child = KeyedSubtree(
      key: key.copy('element'),
      child: Builder(builder: childBuilder),
    );

    if (WidgetSelector.existsIn(context)) {
      return ReorderableItem(
        itemKey: key,
        builder: (context, state, child) {
          if (state == ReorderableState.placeholder) {
            return _decorator(context).decoratePlaceholder(context, element);
          } else {
            return child;
          }
        },
        decorationBuilder: _decorationBuilder,
        child: ReorderableListener<T>(
          delay: const Duration(milliseconds: 200),
          child: AbsorbPointer(
            child: _wrapSettings(child),
          ),
        ),
      );
    }

    return ReorderableItem(
      itemKey: key,
      builder: (context, state, child) {
        if (state == ReorderableState.placeholder) {
          return _decorator(context).decoratePlaceholder(context, element);
        } else if (state == ReorderableState.normal) {
          return Builder(builder: (context) {
            var editState = context.watch(editProvider);

            if (!editState) {
              Widget widget = ModuleRouteTransition<T>(child: child, element: element);
              if (context.read(isOrganizerProvider)) {
                widget = ReorderableListener<T>(
                  delay: const Duration(milliseconds: 800),
                  child: widget,
                );
              }
              return _wrapSettings(widget);
            } else {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(clipBehavior: Clip.none, children: [
                    ConstrainedBox(
                      constraints: constraints,
                      child: _wrapSettings(Builder(builder: (context) {
                        var animation = CurvedAnimation(parent: PhasedAnimation.of(context), curve: Curves.easeInOut);
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) => Transform.rotate(
                            angle: (animation.value - 0.5) * 0.015,
                            child: child,
                          ),
                          child: ReorderableListener<T>(
                            delay: const Duration(milliseconds: 300),
                            child: AbsorbPointer(child: child),
                          ),
                        );
                      })),
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
                    if (settings != null && settings!.showButton)
                      const Positioned(
                        top: -8,
                        left: 25,
                        child: ElementSettingsButton(),
                      ),
                  ]);
                },
              );
            }
          });
        } else {
          return AbsorbPointer(child: _wrapSettings(child));
        }
      },
      decorationBuilder: _decorationBuilder,
      child: child,
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
