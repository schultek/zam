import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../helpers/extensions.dart';
import '../../providers/links/shortcuts_provider.dart';
import '../../widgets/ju_background.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var launchTheme = context.watch(launchThemeProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: launchTheme != null ? 1000 : 800),
        curve: Curves.elasticOut,
        builder: (BuildContext context, double transform, Widget? child) {
          return JuBackground(
            transform: transform * transform,
            theme: launchTheme?.theme,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Transform.scale(
                  scale: 1.6 - (transform * transform * 0.6),
                  child: child,
                ),
              ),
            ),
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.passthrough,
          children: [
            Text(
              launchTheme?.name ?? context.tr.jufa,
              style: TextStyle(
                fontSize: 70,
                fontFamily: 'BiffBamBoom',
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
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              launchTheme?.name ?? context.tr.jufa,
              style: const TextStyle(
                fontSize: 70,
                fontFamily: 'BiffBamBoom',
                color: Colors.white,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
