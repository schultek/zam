import 'package:flutter/material.dart';

import '../../themes/themes.dart';
import '../page_element.dart';
import 'element_decorator.dart';

class DefaultPageElementDecorator implements ElementDecorator<PageElement> {
  @override
  Widget decorateDragged(BuildContext context, PageElement element, Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -2, color: Colors.black.withOpacity(opacity * 0.5))],
      ),
      child: child,
    );
  }

  @override
  Widget decorateElement(BuildContext context, PageElement element, Widget child) {
    return Material(
      textStyle: TextStyle(color: context.onSurfaceColor),
      color: Colors.transparent,
      child: child,
    );
  }

  @override
  Widget decoratePlaceholder(BuildContext context, PageElement element) {
    return Container();
  }
}
