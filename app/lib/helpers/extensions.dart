import 'dart:math';

import 'package:flutter/widgets.dart';

extension PropertyCompare<T> on Set<T> {
  bool containsAllBy<U>(Iterable<T> other, U Function(T object) propertyGetter) {
    return map(propertyGetter).toSet().containsAll(other.map(propertyGetter));
  }

  Set<U> intersectionBy<U>(Iterable<T> other, U Function(T object) propertyGetter) {
    return map(propertyGetter).toSet().intersection(other.map(propertyGetter).toSet());
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect get globalPaintBounds {
    var renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject != null) {
      return renderObject.paintBounds.shift(Offset(translation.x, translation.y));
    } else {
      return Rect.zero;
    }
  }
}

extension DateString on DateTime {
  String toDateString() {
    return '${day.fill()}.${month.fill()}.$year ${hour.fill()}:${minute.fill()}';
  }
}

extension FillZero on num {
  String fill([int n = 2]) {
    return toString().padLeft(n, '0');
  }
}

extension ListHelper<T> on Iterable<T> {
  Iterable<T> intersperse(T separator) sync* {
    Iterator<T> it = iterator;

    var isFirst = true;
    while (it.moveNext()) {
      if (!isFirst) {
        yield separator;
      }
      yield it.current;
      isFirst = false;
    }
  }
}

String generateRandomId([int length = 20]) {
  var random = Random();
  var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
}
