import 'package:flutter/material.dart';

import '../helpers/theme.dart';

class JuBackground extends StatelessWidget {
  final Widget child;
  const JuBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: JuBackgroundPainter(),
      child: child,
    );
  }
}

class JuBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var w = size.width, h = size.height;

    var topPath = Path();
    topPath.lineTo(0, h * 0.2);
    topPath.cubicTo(w * 0.1, h * 0.25, w * 0.15, h * 0.30, w * 0.3, h * 0.32);
    topPath.cubicTo(w * 0.45, h * 0.34, w * 0.5, h * 0.35, w * 0.58, h * 0.38);
    topPath.cubicTo(w * 0.66, h * 0.41, w * 0.7, h * 0.45, w * 0.75, h * 0.5);
    topPath.cubicTo(w * 0.8, h * 0.55, w * 0.9, h * 0.59, w, h * 0.6);
    topPath.lineTo(w, 0);
    topPath.close();

    var bottomPath = Path();
    bottomPath.moveTo(0, h * 0.85);
    bottomPath.cubicTo(w * 0.3, h * 0.9, w * 0.25, h * 0.95, w * 0.5, h);
    bottomPath.lineTo(0, h);
    bottomPath.close();

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = juGreen);

    canvas.drawPath(topPath, Paint()..color = juOrange);
    canvas.drawPath(bottomPath, Paint()..color = juBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
