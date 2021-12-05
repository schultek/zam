import 'package:flutter/material.dart';

import '../../core/core.dart';
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
                child: Text(
              'JUFA',
              style: TextStyle(
                fontSize: 30 + 30 * transform * transform,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
          );
        },
        child: const Icon(Icons.aspect_ratio),
      ),
    );
  }
}
