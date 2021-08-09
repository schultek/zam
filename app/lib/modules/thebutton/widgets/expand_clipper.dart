import 'dart:math';

import 'package:flutter/material.dart';

enum Corner { topLeft, topRight, bottomLeft, bottomRight }

extension on Corner {
  bool get isLeft => index % 2 == 0;
  bool get isTop => index < 2;
}

class ExpandClipper extends CustomClipper<Rect> {
  double value;
  Corner corner;

  ExpandClipper(this.value, [this.corner = Corner.topLeft]);

  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
      center: Offset(corner.isLeft ? 20 : size.width - 20, corner.isTop ? 20 : size.height - 20),
      width: size.width * 2 * sqrt(2) * value,
      height: size.height * 2 * sqrt(2) * value,
    );
  }

  @override
  bool shouldReclip(ExpandClipper oldClipper) => oldClipper.value != value;
}
