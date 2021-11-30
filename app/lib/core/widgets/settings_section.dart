import 'package:flutter/material.dart';

import '../themes/themes.dart';

class SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const SettingsSection({Key? key, this.title, required this.children, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ThemedSurface(
        builder: (context, color) => Material(
          color: color,
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
