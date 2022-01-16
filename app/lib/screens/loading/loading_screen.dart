import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../widgets/ju_background.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.elasticOut,
        builder: (BuildContext context, double transform, Widget? child) {
          return JuBackground(
            transform: transform * transform,
            child: Center(
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Text(context.tr.jufa,
                      style: TextStyle(
                        fontSize: 30 + 40 * transform * transform,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..strokeJoin = StrokeJoin.round
                          ..color = Colors.grey.shade300,
                        shadows: [
                          Shadow(
                            offset: const Offset(-2, 2),
                            color: Colors.grey.shade300,
                          )
                        ],
                      )),
                  Text(
                    context.tr.jufa,
                    style: TextStyle(
                      fontSize: 30 + 40 * transform * transform,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.aspect_ratio),
      ),
    );
  }
}
