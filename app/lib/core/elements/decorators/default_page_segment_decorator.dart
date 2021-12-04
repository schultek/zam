import 'package:flutter/material.dart';

import '../../themes/widgets/trip_theme.dart';
import '../page_segment.dart';
import 'element_decorator.dart';

class DefaultPageSegmentDecorator implements ElementDecorator<PageSegment> {
  @override
  Widget decorateDragged(BuildContext context, PageSegment element, Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -2, color: Colors.black.withOpacity(opacity * 0.5))],
      ),
      child: child,
    );
  }

  @override
  Widget decorateElement(BuildContext context, PageSegment element, Widget child) {
    return Material(
      textStyle: TextStyle(color: context.onSurfaceColor),
      color: Colors.transparent,
      child: child,
    );
  }

  @override
  Widget decoratePlaceholder(BuildContext context, PageSegment element) {
    return Container();
  }
}
