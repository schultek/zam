import 'package:flutter/material.dart';

import '../themes/widgets/themed_surface.dart';

class SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double backgroundOpacity;

  const SettingsSection(
      {Key? key, this.title, required this.children, this.padding, this.margin, this.backgroundOpacity = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(vertical: 8),
      child: ThemedSurface(
        builder: (context, color) => Material(
          color: color.withOpacity(backgroundOpacity),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      title!,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
