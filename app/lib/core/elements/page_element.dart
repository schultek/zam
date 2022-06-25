import 'package:flutter/material.dart';

import '../module/module_context.dart';
import 'module_element.dart';
import 'widgets/element_mixin.dart';

class PageElement extends ModuleElement with ElementMixin<PageElement> {
  final bool keepAlive;
  final Widget Function(BuildContext context) builder;

  PageElement({
    required ModuleContext module,
    required this.builder,
    this.keepAlive = true,
    ElementSettings? settings,
  }) : super(module: module, settings: settings);

  @override
  PageElement get element => this;

  @override
  Widget buildElement(BuildContext context) {
    return builder(context);
  }
}
