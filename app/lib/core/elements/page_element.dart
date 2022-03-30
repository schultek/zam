import 'package:flutter/material.dart';

import '../module/module_context.dart';
import 'module_element.dart';
import 'widgets/module_element_builder.dart';

class PageElement extends ModuleElement with ModuleElementBuilder<PageElement> {
  final bool keepAlive;
  final Widget Function(BuildContext context) builder;

  PageElement({
    required ModuleContext module,
    required this.builder,
    this.keepAlive = true,
    SettingsBuilder? settings,
  }) : super(module: module, settings: settings);

  @override
  PageElement get element => this;

  @override
  Widget buildElement(BuildContext context) {
    return decorator(context).decorateElement(context, this, builder(context));
  }
}