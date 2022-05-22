import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../core/core.dart';
import '../providers/groups/selected_group_provider.dart';

class NeedsSetupCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const NeedsSetupCard({required this.title, required this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (context.read(isOrganizerProvider)) {
          ModuleElement.openSettings(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Stack(
                children: [
                  Icon(
                    Icons.settings,
                    color: context.onSurfaceHighlightColor.withOpacity(0.2),
                    size: 26,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: Icon(
                      Icons.priority_high,
                      color: context.theme.colorScheme.error,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 0.4,
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
            ),
          ],
        ),
      ),
    );
  }
}
