import 'dart:math';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../providers/auth/user_provider.dart';
import '../thebutton_provider.dart';

class TheButtonShape extends StatefulWidget {
  const TheButtonShape({Key? key}) : super(key: key);

  @override
  _TheButtonShapeState createState() => _TheButtonShapeState();
}

class _TheButtonShapeState extends State<TheButtonShape> {
  @override
  Widget build(BuildContext context) {
    var currentLevel = context.watch(theButtonLevelProvider);
    var userId = context.read(userIdProvider);
    var userLevel = context.watch(theButtonUserLevelProvider(userId));
    return CustomPaint(
      painter: TheButtonPainter(currentLevel, userLevel, context),
    );
  }
}

class TheButtonPainter extends CustomPainter {
  final int currentLevel;
  final int? userLevel;
  final BuildContext context;

  TheButtonPainter(this.currentLevel, this.userLevel, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var a = 2 * pi / 6;
    canvas.drawArc(rect, pi * 1.5, a, true, paintLevel(0));
    canvas.drawArc(rect, pi * 1.5 + a, a, true, paintLevel(1));
    canvas.drawArc(rect, pi * 1.5 + 2 * a, a, true, paintLevel(2));
    canvas.drawArc(rect, pi * 1.5 + 3 * a, a, true, paintLevel(3));
    canvas.drawArc(rect, pi * 1.5 + 4 * a, a, true, paintLevel(4));
    canvas.drawArc(rect, pi * 1.5 + 5 * a, a, true, paintLevel(5));

    if (userLevel != null) {
      var ua = pi * 1.5 + userLevel! * a + a / 2;
      var c = size.width / 2;
      var f = 0.7;

      var onEmpty = currentLevel == -1 || (userLevel ?? -1) < currentLevel;
      var starColor = !onEmpty ? context.theme.colorScheme.onPrimary : context.theme.colorScheme.primary;

      canvas.drawPath(
          StarPainter.star().shift(Offset(c + cos(ua) * c * f, c + sin(ua) * c * f)), Paint()..color = starColor);
    }
  }

  Paint paintLevel(int level) {
    var paint = Paint();
    if (currentLevel == -1 || currentLevel > level) {
      if (context.theme.brightness == Brightness.dark) {
        paint.color = context.getFillColor().lighten(10 - level * 2);
      } else {
        paint.color = context.getFillColor().darken(level * 2);
      }
    } else {
      paint.color = getColorForLevel(level, context);
    }
    return paint;
  }

  @override
  bool shouldRepaint(covariant TheButtonPainter oldDelegate) {
    return currentLevel != oldDelegate.currentLevel;
  }
}

class StarPaint extends StatelessWidget {
  final Color color;
  const StarPaint({required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarPainter(color),
      size: const Size(20, 20),
    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(StarPainter.star(size.width), Paint()..color = color);
  }

  static Path star([double size = 20.0]) {
    Path path = Path();
    path.moveTo(size * 0.5000000, size * 0.02445833);
    path.lineTo(size * 0.6528333, size * 0.3397917);
    path.lineTo(size, size * 0.3877500);
    path.lineTo(size * 0.7473333, size * 0.6305833);
    path.lineTo(size * 0.8090000, size * 0.9755417);
    path.lineTo(size * 0.5000000, size * 0.8102500);
    path.lineTo(size * 0.1909583, size * 0.9755417);
    path.lineTo(size * 0.2526667, size * 0.6305833);
    path.lineTo(0, size * 0.3877500);
    path.lineTo(size * 0.3471667, size * 0.3397917);
    path.close();
    return path.shift(Offset(-size / 2, -size / 2));
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
