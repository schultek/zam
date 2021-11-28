import 'package:flutter/material.dart';

import '../core/themes/themes.dart';

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
              color: context.getTextColor(),
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1!.apply(color: context.getTextColor(), fontSizeDelta: 2),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
