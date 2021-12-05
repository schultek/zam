import 'dart:math';

import 'package:flutter/material.dart';

import '../../elements/module_element.dart';
import '../widget_area.dart';

mixin ScrollMixin<T extends WidgetArea<E>, E extends ModuleElement> on WidgetAreaState<T, E> {
  ScrollController get scrollController;

  Function? _activeScrollCb;

  bool get scrollDownEnabled => true;

  Future<void> maybeScroll(Offset dragOffset, Key itemKey, Size itemSize) async {
    scrollCb() {
      _activeScrollCb = null;
      if (hasKey(itemKey)) {
        reorderItem(dragOffset, itemKey);
      }
    }

    if (_activeScrollCb != null) {
      _activeScrollCb = scrollCb;
      return;
    }

    var position = scrollController.position;
    int duration = 15; // in ms

    MediaQueryData d = MediaQuery.of(context);
    double padding = 0;

    if (position.axis == Axis.vertical) {
      double top = d.padding.top + padding;
      double bottom = position.viewportDimension - (d.padding.bottom) - padding;

      double? newOffset = checkScrollPosition(position, dragOffset.dy, itemSize, top, bottom);

      if (newOffset != null && (newOffset - position.pixels).abs() >= 1.0) {
        _activeScrollCb = scrollCb;

        await scrollController.position.animateTo(
          newOffset,
          duration: Duration(milliseconds: duration),
          curve: Curves.linear,
        );

        if (_activeScrollCb != null) {
          _activeScrollCb!();
        }
      }
    } else {
      // TODO
    }
  }

  double? checkScrollPosition(ScrollPosition position, double dragOffset, Size dragSize, double top, double bottom) {
    double step = 1.0;
    double overdragMax = 40.0;
    double overdragCoef = 5.0;

    if (dragOffset < top && position.pixels > position.minScrollExtent) {
      var overdrag = max(top - dragOffset, overdragMax);
      return max(position.minScrollExtent, position.pixels - step * overdrag / overdragCoef);
    } else if (scrollDownEnabled &&
        dragOffset + dragSize.height > bottom &&
        position.pixels < position.maxScrollExtent) {
      var overdrag = max<double>(dragOffset + dragSize.height - bottom, overdragMax);
      return min(position.maxScrollExtent, position.pixels + step * overdrag / overdragCoef);
    } else {
      return null;
    }
  }
}
