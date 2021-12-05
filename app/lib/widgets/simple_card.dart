import 'package:flutter/material.dart';

import '../core/core.dart';

class SimpleCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const SimpleCard({required this.title, required this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: context.onSurfaceHighlightColor,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: context.theme.textTheme.bodyText1!.apply(color: context.onSurfaceColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
