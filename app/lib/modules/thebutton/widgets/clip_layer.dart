import 'package:flutter/material.dart';

import '../../../core/themes/themes.dart';
import 'expand_clipper.dart';

class ClipLayer extends StatelessWidget {
  final Corner corner;
  final Widget child;
  final bool isOpen;
  final bool matchColor;

  const ClipLayer({
    Key? key,
    this.corner = Corner.topLeft,
    required this.child,
    this.isOpen = false,
    this.matchColor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: isOpen ? 1.0 : 0.0),
        builder: (context, double value, _) {
          return ClipOval(
            clipper: ExpandClipper(value, corner),
            child: FillColor(
              matchTextColor: matchColor,
              preference: matchColor ? null : ColorPreference(contrast: Contrast.veryLow),
              builder: (context, fillColor) => Material(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: fillColor,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
