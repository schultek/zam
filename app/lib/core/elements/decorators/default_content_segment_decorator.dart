import 'package:flutter/material.dart';

import '../../themes/themes.dart';
import '../content_element.dart';
import '../module_element.dart';
import 'element_decorator.dart';

class DefaultContentElementDecorator implements ElementDecorator<ContentElement> {
  const DefaultContentElementDecorator();
  @override
  Widget decorateDragged(BuildContext context, ContentElement element, Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -2, color: Colors.black.withOpacity(opacity * 0.5))],
      ),
      child: child,
    );
  }

  @override
  Widget decorateElement(BuildContext context, ContentElement element, Widget child) {
    if (child is ContentElementItems) {
      return child.builder(
          context, child.itemsBuilder(context).map((c) => _defaultDecorator(element.size, c)).toList());
    } else if (child is ContentElementText) {
      return Material(color: Colors.transparent, child: child.builder(context));
    } else {
      return _defaultDecorator(element.size, child);
    }
  }

  @override
  Widget decoratePlaceholder(BuildContext context, ContentElement element) {
    return _defaultDecorator(element.size);
  }

  @override
  Widget getPlaceholder(BuildContext context) {
    return _defaultDecorator(ElementSize.square, null);
  }

  Widget _defaultDecorator(ElementSize size, [Widget? child]) {
    var w = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ThemedSurface(
        builder: (context, fillColor) => Material(
          textStyle: TextStyle(color: context.onSurfaceColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: fillColor.withOpacity(child != null ? 1 : 0.4),
          child: child ?? Container(),
        ),
      ),
    );
    if (size == ElementSize.wide) {
      return w;
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: w,
      );
    }
  }
}
