import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

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
    var userLevel = context.watch(theButtonProvider).value?.leaderboard[userId];
    return CustomPaint(
      painter: TheButtonPainter(currentLevel, userLevel),
    );
  }
}

class TheButtonPainter extends CustomPainter {
  final int currentLevel;
  final int? userLevel;

  TheButtonPainter(this.currentLevel, this.userLevel);

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
      canvas.drawPath(star().shift(Offset(c + cos(ua) * c * f, c + sin(ua) * c * f)), Paint()..color = Colors.white);
    }
  }

  Paint paintLevel(int level) {
    var paint = Paint()..color = theButtonLevels[level];
    if (currentLevel == -1 || currentLevel > level) {
      paint.color = Colors.grey.withAlpha(200 - level * 30);
    }
    return paint;
  }

  Path star() {
    Path path = Path();
    var size = 20.0;
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
  bool shouldRepaint(covariant TheButtonPainter oldDelegate) {
    return currentLevel != oldDelegate.currentLevel;
  }
}
