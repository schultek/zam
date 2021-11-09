import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../thebutton_animation_controller.dart';
import '../thebutton_provider.dart';

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
        if (context.read(theButtonLogicProvider).isAlive ?? false) {
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
          return CustomPaint(
            painter: TapProgressPainter(tapAnimation.value),
            child: child,
          );
        },
        child: AnimatedBuilder(
          animation: pointsAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                child!,
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
              child: const TheButtonAnimation(),
            ),
          ),
        ),
      ),
    );
  }
}

class TapProgressPainter extends CustomPainter {
  final double value;
  TapProgressPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      2 * pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Colors.grey.shade600,
    );
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      value * 2 * pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = value == 1 ? Colors.green : Colors.white,
    );
  }

  @override
  bool shouldRepaint(TapProgressPainter oldDelegate) => oldDelegate.value != value;
}

class TheButtonAnimation extends StatefulWidget {
  const TheButtonAnimation({Key? key}) : super(key: key);

  @override
  _TheButtonAnimationState createState() => _TheButtonAnimationState();
}

class _TheButtonAnimationState extends State<TheButtonAnimation> {
  static Future<Artboard> animationFuture = rootBundle.load('assets/animations/the_button.riv').then((data) async {
    var file = RiveFile.import(data);

    var artboard = file.mainArtboard;

    var waveController = SimpleAnimation('Wave');
    artboard.addController(waveController);
    waveController.instance!.animation.speed = 0.1;

    return artboard;
  });

  static Artboard? artboard;

  @override
  void initState() {
    super.initState();
    if (artboard == null) {
      loadAnimation().catchError((e) {
        print('ERROR ON BUTTON $e');
      });
    }
  }

  Future<void> loadAnimation() async {
    artboard = await animationFuture;

    var fillController = TheButtonAnimationController();
    artboard!.addController(fillController);

    SimpleAnimation deadController;
    SimpleAnimation deadEntryController;

    deadController = SimpleAnimation('Dead');
    deadEntryController = SimpleAnimation('Dead Entry');

    void runDeadAnimation() {
      artboard!.addController(deadController);
      artboard!.addController(deadEntryController);
    }

    void clearDeadAnimation() {
      deadEntryController.instance?.animation.apply(0, coreContext: artboard!.context);
      artboard!.removeController(deadController);
      artboard!.removeController(deadEntryController);
    }

    var valueNotifier = context.read(theButtonValueProvider.stream);
    var initialValue = await valueNotifier.first;

    fillController.jumpTo(initialValue);
    if (initialValue >= 1) {
      runDeadAnimation();
    }

    valueNotifier.listen((value) {
      if (value < 1) {
        clearDeadAnimation();
        fillController.animateTo(value);
      } else {
        runDeadAnimation();
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (artboard != null) {
      return Rive(artboard: artboard!);
    } else {
      return Container();
    }
  }
}
