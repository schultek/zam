import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension LocalizedContext on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this)!;
}

final dateFormat = DateFormat('dd. MMM. yyyy');

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

String generateRandomId(int length) {
  var random = Random();
  var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
}

int gcd(int a, int b) {
  while (a != 0) {
    var tmp = a;
    a = b % a;
    b = tmp;
  }
  return b;
}

int mgcd(List<int> numbers) {
  var result = numbers.first;
  for (var i = 1; i < numbers.length; i++) {
    result = gcd(numbers[i], result);
    if (result == 1) {
      return 1;
    }
  }
  return result;
}

double round1000(double value) {
  return (value * 1000).roundToDouble() / 1000;
}

double round100(double value) {
  return (value * 100).roundToDouble() / 100;
}
