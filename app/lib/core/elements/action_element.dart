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
    SettingsBuilder? settings,
    SettingsAction? settingsAction,
  })  : textBuilder = ((_) => text),
        super(module: module, settings: settings, settingsAction: settingsAction);

  ActionElement.builder({
    required ModuleContext module,
    this.icon,
    this.iconWidget,
    required String Function(BuildContext) text,
    this.onTap,
    this.onNavigate,
    SettingsBuilder? settings,
    SettingsAction? settingsAction,
  })  : textBuilder = text,
        super(module: module, settings: settings, settingsAction: settingsAction);

  @override
  ActionElement get element => this;

  @override
  Widget buildElement(BuildContext context) {
    var child = decorator(context).decorateElement(context, this, Container());
    if (onTap != null || onNavigate != null) {
      child = GestureDetector(
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
