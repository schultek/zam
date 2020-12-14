import 'dart:ui';

import 'package:flutter/widgets.dart';

extension PropertyCompare<T> on Set<T> {

  bool containsAllBy<U>(Iterable<T> other, U Function(T object) propertyGetter) {
    return this.map(propertyGetter).toSet().containsAll(other.map(propertyGetter));
  }

  Set<U> intersectionBy<U>(Iterable<T> other, U Function(T object) propertyGetter) {
    return this.map(propertyGetter).toSet().intersection(other.map(propertyGetter).toSet());
  }

}

extension GlobalKeyExtension on GlobalKey {
  Rect get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    if (translation != null && renderObject.paintBounds != null) {
      return renderObject.paintBounds.shift(Offset(translation.x, translation.y));
    } else {
      return Rect.zero;
    }
  }
}