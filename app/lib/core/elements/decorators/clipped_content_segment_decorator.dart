import 'package:flutter/material.dart';

import '../content_element.dart';
import '../module_element.dart';
import 'default_content_segment_decorator.dart';
import 'element_decorator.dart';

class ClippedContentElementDecorator implements ElementDecorator<ContentElement> {
  const ClippedContentElementDecorator();
  @override
  Widget decorateDragged(BuildContext context, ContentElement element, Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        boxShadow: [BoxShadow(blurRadius: 40, spreadRadius: -20, color: Colors.black.withOpacity(opacity * 0.4))],
      ),
      child: child,
    );
  }

  @override
  Widget decorateElement(BuildContext context, ContentElement element, Widget child) {
    if (child is ContentElementItems) {
      var itemDecorator = const DefaultContentElementDecorator();
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: child.builder(
          context,
          child.itemsBuilder(context).map((c) => itemDecorator.decorateElement(context, element, c)).toList(),
        ),
      );
    } else if (child is ContentElementText) {
      return Material(color: Colors.transparent, child: child.builder(context));
    } else {
      return _defaultDecorator(element, child);
    }
  }

  @override
  Widget decoratePlaceholder(BuildContext context, ContentElement element) {
    return _defaultDecorator(element);
  }

  Widget _defaultDecorator(ContentElement element, [Widget? child]) {
    var w = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.transparent,
        child: child ?? Container(),
      ),
    );
    if (element.size == ElementSize.wide) {
      return w;
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: w,
      );
    }
  }
}
