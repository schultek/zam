import 'package:flutter/material.dart';

import '../module/module_context.dart';
import '../route/route.dart';
import 'module_element.dart';
import 'widgets/module_element_builder.dart';

class ActionElement extends ModuleElement with ModuleElementBuilder<ActionElement> {
  final IconData icon;
  final String text;
  final void Function(BuildContext)? onTap;
  final Widget Function(BuildContext)? onNavigate;

  ActionElement({
    required ModuleContext module,
    required this.icon,
    required this.text,
    this.onTap,
    this.onNavigate,
  }) : super(module: module);

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
