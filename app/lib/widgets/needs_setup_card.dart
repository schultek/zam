import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../core/core.dart';
import '../providers/groups/selected_group_provider.dart';

class NeedsSetupCard extends StatelessWidget {
  final Widget child;

  const NeedsSetupCard({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (context.read(isOrganizerProvider)) {
          ModuleElement.openSettings(context);
        }
      },
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
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
            child: child,
          ),
        ],
      ),
    );
  }
}
