import 'package:flutter/material.dart';

import '../../module.dart';

class NoteCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool needsSurface;

  const NoteCard({required this.child, required this.onTap, this.needsSurface = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (needsSurface) {
      return ThemedSurface(builder: (context, color) => buildCard(context, color));
    } else {
      return buildCard(context, null);
    }
  }

  Widget buildCard(BuildContext context, Color? color) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: color ?? Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: AspectRatio(aspectRatio: 1, child: child),
      ),
    );
  }
}
