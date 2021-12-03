import 'package:flutter/material.dart';

import '../module/module_context.dart';
import 'module_element.dart';
import 'widgets/module_element_builder.dart';

class PageSegment extends ModuleElement with ModuleElementBuilder<PageSegment> {
  final bool keepAlive;
  final Widget Function(BuildContext context) builder;

  PageSegment({
    required ModuleContext context,
    required this.builder,
    this.keepAlive = true,
  }) : super(key: UniqueKey(), context: context);

  @override
  PageSegment get element => this;

  @override
  Widget buildElement(BuildContext context) {
    return decorator(context).decorateElement(context, this, builder(context));
  }
}
