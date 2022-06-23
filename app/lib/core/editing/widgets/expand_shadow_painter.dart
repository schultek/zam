import 'package:flutter/material.dart';

import 'widget_selector.dart';

class ShadowPainter extends CustomPainter {
  final double expand;

  ShadowPainter(this.expand);

  @override
  void paint(Canvas canvas, Size size) {
    var w = size.width + WidgetSelector.itemPadding, h = size.height - WidgetSelector.itemPadding;
    canvas.clipRect(Offset.zero & Size(w, h));

    var spath = Path();
    spath.moveTo(w, 0);
    spath.lineTo(w, h);
    spath.lineTo(w + WidgetSelector.itemPadding * 2, h);
    spath.lineTo(w + WidgetSelector.itemPadding * 2, 0);
    spath.close();

    var opacity = 1 - ((0.5 - expand).abs() * 2);

    canvas.drawShadow(spath, Colors.black.withOpacity(opacity), 8, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
