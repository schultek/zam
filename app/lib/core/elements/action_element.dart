import 'package:flutter/material.dart';

import '../module/module_context.dart';
import '../route/route.dart';
import 'module_element.dart';
import 'widgets/element_mixin.dart';

class ActionElement extends ModuleElement with ElementMixin<ActionElement> {
  final IconData? icon;
  final Widget? iconWidget;
  final String Function(BuildContext) textBuilder;
  final void Function(BuildContext)? onTap;
  final Widget Function(BuildContext)? onNavigate;

  ActionElement({
    required ModuleContext module,
    this.icon,
    this.iconWidget,
    required String text,
    this.onTap,
    this.onNavigate,
    ElementSettings? settings,
  })  : textBuilder = ((_) => text),
        super(module: module, settings: settings);

  ActionElement.builder({
    required ModuleContext module,
    this.icon,
    this.iconWidget,
    required String Function(BuildContext) text,
    this.onTap,
    this.onNavigate,
    ElementSettings? settings,
  })  : textBuilder = text,
        super(module: module, settings: settings);

  @override
  ActionElement get element => this;

  @override
  Widget buildElement(BuildContext context) {
    return Container();
  }

  @override
  Widget decorateElement(BuildContext context, Widget child) {
    child = super.decorateElement(context, child);
    if (onTap != null || onNavigate != null) {
      return GestureDetector(
        onTap: () {
          onTap?.call(context);
          if (onNavigate != null) {
            Navigator.of(context).push(ModulePageRoute(context, child: onNavigate!(context)));
          }
        },
        child: child,
      );
    }
    return child;
  }
}
