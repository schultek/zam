import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../thebutton_provider.dart';
import 'thebutton_shape.dart';

class TheButton extends StatefulWidget {
  const TheButton({Key? key}) : super(key: key);

  @override
  _TheButtonState createState() => _TheButtonState();
}

class _TheButtonState extends State<TheButton> with TickerProviderStateMixin {
  late AnimationController tapAnimation;

  @override
  void initState() {
    super.initState();
    tapAnimation = AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (event) {
        if (context.read(theButtonLevelProvider) != -1) {
          tapAnimation.forward();
        }
      },
      onTapUp: (event) {
        if (tapAnimation.value == 1) {
          context.read(theButtonLogicProvider).resetState().whenComplete(() {
            tapAnimation.value = 0;
          });
        } else {
          tapAnimation.reverse();
        }
      },
      onTapCancel: () {
        tapAnimation.reverse();
      },
      child: ThemedSurface(
        preference: const ColorPreference(useHighlightColor: true),
        builder: (context, highlightColor) => AnimatedBuilder(
          animation: tapAnimation,
          builder: (context, child) {
            var level = context.read(theButtonLevelProvider);
            return CustomPaint(
              painter: TapProgressPainter(tapAnimation.value, level, context),
              child: child,
            );
          },
          child: AbsorbPointer(
            child: ThemedSurface(
              builder: (context, color) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: TheButtonShape(highlightColor: highlightColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TapProgressPainter extends CustomPainter {
  final double value;
  final int level;
  final BuildContext context;
  TapProgressPainter(this.value, this.level, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var strokeWidth = size.width / 25;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      2 * pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = context.surfaceColor,
    );
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      value * 2 * pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = value == 1 ? getColorForLevel(level, context) : context.onSurfaceColor,
    );
  }

  @override
  bool shouldRepaint(TapProgressPainter oldDelegate) => oldDelegate.value != value;
}
