import 'package:flutter/material.dart';

import '../../../helpers/theme.dart';
import '../../core.dart';

class JuLogo extends StatelessWidget {
  const JuLogo({
    required this.size,
    this.name = 'JUFA',
    this.theme,
    Key? key,
  }) : super(key: key);

  final double size;
  final String name;
  final ThemeModel? theme;

  @override
  Widget build(BuildContext context) {
    var colorScheme = theme == null ? null : GroupThemeData.fromModel(theme!).themeData.colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: JuLogoPainter(
          colorA: colorScheme?.secondary ?? juOrange,
          colorB: colorScheme?.primary ?? juGreen,
          // ignore: deprecated_member_use
          colorC: colorScheme?.secondaryVariant ?? juBlue,
        ),
        child: Center(
          child: Text(
            name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              fontFamily: 'BiffBamBoom',
              color: Colors.white,
              fontSize: size * 0.7,
              shadows: [
                Shadow(
                  color: Colors.grey.shade300,
                  offset: const Offset(-2, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JuLogoPainter extends CustomPainter {
  final Color colorA, colorB, colorC;

  JuLogoPainter({
    this.colorA = juOrange,
    this.colorB = juGreen,
    this.colorC = juBlue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double w(double g) => size.width * g;
    double h(double g) => size.height * g;

    var topPath = Path();
    topPath.lineTo(0, h(0.2));
    topPath.cubicTo(w(0.1), h(0.25), w(0.15), h(0.3), w(0.3), h(0.32));
    topPath.cubicTo(w(0.45), h(0.34), w(0.5), h(0.35), w(0.58), h(0.38));
    topPath.cubicTo(w(0.66), h(0.41), w(0.7), h(0.45), w(0.75), h(0.5));
    topPath.cubicTo(w(0.8), h(0.55), w(0.9), h(0.59), w(1), h(0.6));
    topPath.lineTo(w(1), 0);
    topPath.close();

    var bottomPath = Path();
    bottomPath.moveTo(0, h(0.65));
    bottomPath.cubicTo(w(0.2), h(0.9), w(0.45), h(0.75), w(0.7), h(1));
    bottomPath.lineTo(0, h(1));
    bottomPath.close();

    canvas.drawRect(Rect.fromLTWH(0, 0, w(1), h(1)), Paint()..color = colorB);

    canvas.drawPath(topPath, Paint()..color = colorA);
    canvas.drawPath(bottomPath, Paint()..color = colorC);
  }

  @override
  bool shouldRepaint(covariant JuLogoPainter oldDelegate) =>
      oldDelegate.colorA != colorA || oldDelegate.colorB != colorB || oldDelegate.colorC != colorC;
}
