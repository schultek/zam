import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../elements/elements.dart';
import '../../providers/editing_providers.dart';
import '../area.dart';

mixin ScrollMixin<T extends Area<E>, E extends ModuleElement> on AreaState<T, E> {
  ScrollController get scrollController;

  Function? _afterScrollCb;
  Timer? _scrollDownDebounce;

  @override
  void cancelDrop(Key key) {
    _afterScrollCb = null;
    super.cancelDrop(key);
  }

  @override
  void onDrop() {
    _afterScrollCb = null;
    super.onDrop();
  }

  Future<void> maybeScroll(Offset dragOffset, Key itemKey, Size itemSize) async {
    if (!context.read(isEditingProvider)) {
      _afterScrollCb = null;
      return;
    }

    maybeAfterScrollCb() {
      _afterScrollCb = null;
      if (hasKey(itemKey)) {
        reorderItem(dragOffset, itemKey);
      }
    }

    if (_afterScrollCb != null) {
      _afterScrollCb = maybeAfterScrollCb;
      return;
    }

    var position = scrollController.position;

    MediaQueryData d = MediaQuery.of(context);
    double padding = 0;

    if (position.axis == Axis.vertical) {
      double top = d.padding.top + padding;
      double bottom = position.viewportDimension - (d.padding.bottom) - padding;

      double? newOffset = checkScrollPosition(position, dragOffset.dy, itemSize.height, top, bottom);

      if (newOffset != null && newOffset > position.pixels && _scrollDownDebounce == null) {
        _afterScrollCb = maybeAfterScrollCb;

        _scrollDownDebounce = Timer(const Duration(seconds: 2), () {
          if (_afterScrollCb != null) {
            _afterScrollCb!();
          } else {
            _scrollDownDebounce = null;
          }
        });

        return;
      }

      _scrollDownDebounce?.cancel();
      _scrollDownDebounce = null;

      performScroll(newOffset, maybeAfterScrollCb);
    } else {
      double left = padding;
      double right = position.viewportDimension - padding;

      double? newOffset = checkScrollPosition(position, dragOffset.dx, itemSize.width, left, right);
      performScroll(newOffset, maybeAfterScrollCb);
    }
  }

  Future<void> performScroll(double? newOffset, void Function() afterScrollCb) async {
    var position = scrollController.position;

    if (newOffset != null && (newOffset - position.pixels).abs() >= 1.0) {
      _afterScrollCb = afterScrollCb;

      await scrollController.position.animateTo(
        newOffset,
        duration: const Duration(milliseconds: 15),
        curve: Curves.linear,
      );

      if (_afterScrollCb != null) {
        _afterScrollCb!();
      }
    }
  }

  double? checkScrollPosition(ScrollPosition position, double dragOffset, double dragSize, double top, double bottom) {
    double step = 1.0;
    double overdragMax = 40.0;
    double overdragCoef = 5.0;

    if (dragOffset < top && position.pixels > position.minScrollExtent) {
      var overdrag = max(top - dragOffset, overdragMax);
      return max(position.minScrollExtent, position.pixels - step * overdrag / overdragCoef);
    } else if (dragOffset + dragSize > bottom && position.pixels < position.maxScrollExtent) {
      var overdrag = max<double>(dragOffset + dragSize - bottom, overdragMax);
      return min(position.maxScrollExtent, position.pixels + step * overdrag / overdragCoef);
    } else {
      return null;
    }
  }
}
