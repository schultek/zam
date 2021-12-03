import 'package:flutter/material.dart';

import '../module/module_context.dart';
import 'module_element.dart';
import 'widgets/module_element_builder.dart';

class QuickAction extends ModuleElement with ModuleElementBuilder<QuickAction> {
  final IconData icon;
  final String text;
  final Function(BuildContext)? onTap;

  QuickAction({
    required ModuleContext context,
    required this.icon,
    required this.text,
    this.onTap,
  }) : super(key: UniqueKey(), context: context);

  @override
  QuickAction get element => this;

  @override
  Widget buildElement(BuildContext context) {
    var child = decorator(context).decorateElement(context, this, Container());
    return GestureDetector(onTap: onTap != null ? () => onTap!(context) : null, child: child);
  }
}
