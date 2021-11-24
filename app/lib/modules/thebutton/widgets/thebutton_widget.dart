import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../thebutton_provider.dart';
import 'thebutton_shape.dart';

class TheButton extends StatefulWidget {
  const TheButton({Key? key}) : super(key: key);

  @override
  _TheButtonState createState() => _TheButtonState();
}

class _TheButtonState extends State<TheButton> with TickerProviderStateMixin {
  late AnimationController tapAnimation;
  late AnimationController pointsAnimation;
  int? points;

  @override
  void initState() {
    super.initState();
    tapAnimation = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    pointsAnimation = AnimationController(vsync: this, duration: const Duration(seconds: 1));
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
          context.read(theButtonLogicProvider).resetState().then((points) {
            if (points != null) {
              this.points = points;
              pointsAnimation.forward(from: 0);
            }
          }).whenComplete(() {
            tapAnimation.value = 0;
          });
        } else {
          tapAnimation.reverse();
        }
      },
      onTapCancel: () {
        tapAnimation.reverse();
      },
      child: AnimatedBuilder(
        animation: tapAnimation,
        builder: (context, child) {
          var level = context.read(theButtonLevelProvider);
          return CustomPaint(
            painter: TapProgressPainter(tapAnimation.value, level),
            child: child,
          );
        },
        child: AnimatedBuilder(
          animation: pointsAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned.fill(child: child!),
                if (points != null && pointsAnimation.isAnimating)
                  Center(
                    child: Text(
                      '+ $points',
                      style: TextStyle(
                        fontSize: Curves.easeOut.transform(pointsAnimation.value) * 25,
                        color: Colors.white.withOpacity(1 - Curves.easeInExpo.transform(pointsAnimation.value)),
                      ),
                    ),
                  ),
              ],
            );
          },
          child: AbsorbPointer(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black26,
              ),
              child: const TheButtonShape(),
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
  TapProgressPainter(this.value, this.level);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      2 * pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = Colors.grey.shade600,
    );
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      value * 2 * pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = value == 1 ? theButtonLevels[level] : Colors.white,
    );
  }

  @override
  bool shouldRepaint(TapProgressPainter oldDelegate) => oldDelegate.value != value;
}
