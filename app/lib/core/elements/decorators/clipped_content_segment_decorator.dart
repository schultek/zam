import 'package:flutter/material.dart';

import '../content_segment.dart';
import '../module_element.dart';
import 'default_content_segment_decorator.dart';
import 'element_decorator.dart';

class ClippedContentSegmentDecorator implements ElementDecorator<ContentSegment> {
  const ClippedContentSegmentDecorator();
  @override
  Widget decorateDragged(BuildContext context, ContentSegment element, Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        boxShadow: [BoxShadow(blurRadius: 40, spreadRadius: -20, color: Colors.black.withOpacity(opacity * 0.4))],
      ),
      child: child,
    );
  }

  @override
  Widget decorateElement(BuildContext context, ContentSegment element, Widget child) {
    if (child is ContentSegmentItems) {
      var itemDecorator = const DefaultContentSegmentDecorator();
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: child.builder(
          context,
          child.itemsBuilder(context).map((c) => itemDecorator.decorateElement(context, element, c)).toList(),
        ),
      );
    } else if (child is ContentSegmentText) {
      return Material(color: Colors.transparent, child: child.builder(context));
    } else {
      return _defaultDecorator(element, child);
    }
  }

  @override
  Widget decoratePlaceholder(BuildContext context, ContentSegment element) {
    return _defaultDecorator(element);
  }

  Widget _defaultDecorator(ContentSegment element, [Widget? child]) {
    var w = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.transparent,
        child: child ?? Container(),
      ),
    );
    if (element.size == SegmentSize.wide) {
      return w;
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: w,
      );
    }
  }
}
