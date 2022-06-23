import 'package:flutter/material.dart';

class DragTabsPainter extends CustomPainter {
  final bool rightActive;
  final Color leftColor;
  final Color? rightColor;

  DragTabsPainter({required this.rightActive, required this.leftColor, required this.rightColor});

  @override
  bool? hitTest(Offset position) => false;

  @override
  void paint(Canvas canvas, Size size) {
    var w = size.width, h = size.height;

    if (rightColor == null) return;

    var cpath = Path();

    if (rightActive) {
      cpath.moveTo(0, 0);
      cpath.lineTo(w / 2 - 40, 0);
      cpath.arcToPoint(Offset(w / 2 - 40 - h / 2, h / 2), radius: Radius.circular(h / 2), clockwise: false);
      cpath.arcToPoint(Offset(w / 2 - 40 - h, h), radius: Radius.circular(h / 2));
      cpath.lineTo(0, h);
    } else {
      cpath.moveTo(w / 2 + 40, 0);
      cpath.arcToPoint(Offset(w / 2 + 40 + h / 2, h / 2), radius: Radius.circular(h / 2));
      cpath.arcToPoint(Offset(w / 2 + 40 + h, h), radius: Radius.circular(h / 2), clockwise: false);
      cpath.lineTo(w, h);
      cpath.lineTo(w, 0);
    }
    cpath.close();

    canvas.clipPath(cpath);

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 2), Paint()..color = (rightActive ? null : rightColor) ?? leftColor);

    var path = Path();

    if (rightActive) {
      path.moveTo(0, h);
      path.lineTo(w / 2 - 40 - size.height, h);
      path.arcToPoint(Offset(w / 2 - 40 - size.height / 2, h / 2),
          radius: Radius.circular(size.height / 2), clockwise: false);
      path.arcToPoint(Offset(w / 2 - 40, 0), radius: Radius.circular(size.height / 2));
      path.lineTo(w, 0);
      path.lineTo(w, h * 2);
      path.lineTo(0, h * 2);
    } else {
      path.moveTo(0, 0);
      path.lineTo(w / 2 + 40, 0);
      path.arcToPoint(Offset(w / 2 + 40 + h / 2, h / 2), radius: Radius.circular(h / 2));
      path.arcToPoint(Offset(w / 2 + 40 + h, h), radius: Radius.circular(h / 2), clockwise: false);
      path.lineTo(w, h);
      path.lineTo(w, h * 2);
      path.lineTo(0, h * 2);
    }
    path.close();

    canvas.drawShadow(path.shift(Offset(rightActive ? -1 : 1, -3)), Colors.black87, 3, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
