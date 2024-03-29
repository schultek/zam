import 'package:flutter/material.dart';

import '../core/themes/themes.dart';
import '../helpers/theme.dart';

class JuBackground extends StatelessWidget {
  const JuBackground({
    Key? key,
    this.child,
    this.transform = 1,
    this.theme,
  }) : super(key: key);

  final Widget? child;
  final double transform;
  final ThemeModel? theme;

  @override
  Widget build(BuildContext context) {
    var colorScheme = theme == null ? null : GroupThemeData.fromModel(theme!).themeData.colorScheme;

    return CustomPaint(
      painter: JuBackgroundPainter(
        transform,
        colorA: colorScheme?.secondary ?? juOrange,
        colorB: colorScheme?.primary ?? juGreen,
        // ignore: deprecated_member_use
        colorC: colorScheme?.secondaryVariant ?? juBlue,
      ),
      child: child,
    );
  }
}

class JuBackgroundPainter extends CustomPainter {
  final double transform;
  final Color colorA, colorB, colorC;

  JuBackgroundPainter(
    this.transform, {
    this.colorA = juOrange,
    this.colorB = juGreen,
    this.colorC = juBlue,
  });

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

    canvas.drawRect(Rect.fromLTWH(0, 0, w(1), h(1)), Paint()..color = colorB);

    canvas.drawPath(topPath, Paint()..color = colorA);
    canvas.drawPath(bottomPath, Paint()..color = colorC);
  }

  @override
  bool shouldRepaint(covariant JuBackgroundPainter oldDelegate) => oldDelegate.transform != transform;
}
