import 'package:flutter/material.dart';

import '../areas/widget_area.dart';
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
  Widget buildPlaceholder(BuildContext context) {
    return WidgetArea.of<PageSegment>(context)?.decoratePlaceholder(context, this) ?? _defaultDecorator();
  }

  @override
  Widget buildElement(BuildContext context) {
    return builder(context);
  }

  @override
  Widget decorationBuilder(Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: -2,
          color: Colors.black.withOpacity(opacity * 0.5),
        )
      ]),
      child: child,
    );
  }

  Widget _defaultDecorator([Widget? child]) {
    var w = child ?? Container();
    return w;
  }
}
