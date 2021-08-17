import 'package:flutter/material.dart';

import '../helpers/theme.dart';

class JuBackground extends StatelessWidget {
  final Widget child;
  final double transform;
  const JuBackground({Key? key, required this.child, this.transform = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: JuBackgroundPainter(transform),
      child: child,
    );
  }
}

class JuBackgroundPainter extends CustomPainter {
  final double transform;

  JuBackgroundPainter(this.transform);

  @override
  void paint(Canvas canvas, Size size) {
    double w(double g, [double n = 0]) => size.width * (g + (1 - transform) * n);
    double h(double g, [double n = 0]) => size.height * (g + n * (1 - transform));

    var topPath = Path();
    topPath.lineTo(0, h(0.2));
    topPath.cubicTo(w(0.1), h(0.25), w(0.15), h(0.3, -0.04), w(0.3), h(0.32));
    topPath.cubicTo(w(0.45), h(0.34, 0.04), w(0.5), h(0.35, 0.05), w(0.58), h(0.38, 0.05));
    topPath.cubicTo(w(0.66), h(0.41, 0.05), w(0.7), h(0.45, 0.03), w(0.75), h(0.5));
    topPath.cubicTo(w(0.8), h(0.55, -0.03), w(0.9), h(0.59, -0.03), w(1), h(0.6));
    topPath.lineTo(w(1), 0);
    topPath.close();

    var bottomPath = Path();
    bottomPath.moveTo(0, h(0.85));
    bottomPath.cubicTo(w(0.3), h(0.9, 0.04), w(0.25), h(0.95, -0.03), w(0.5), h(1));
    bottomPath.lineTo(0, h(1));
    bottomPath.close();

    canvas.drawRect(Rect.fromLTWH(0, 0, w(1), h(1)), Paint()..color = juGreen);

    canvas.drawPath(topPath, Paint()..color = juOrange);
    canvas.drawPath(bottomPath, Paint()..color = juBlue);
  }

  @override
  bool shouldRepaint(covariant JuBackgroundPainter oldDelegate) => oldDelegate.transform != transform;
}
