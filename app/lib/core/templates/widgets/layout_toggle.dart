import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../providers/editing_providers.dart';
import '../../themes/themes.dart';
import 'reorder_toggle.dart';

class EditToggles extends StatelessWidget {
  const EditToggles({this.isEditing = true, this.notifyVisibility = true, Key? key}) : super(key: key);

  final bool notifyVisibility;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      children: [
        if (isEditing) const LayoutToggle(),
        const ReorderToggle(),
      ],
    );

    if (notifyVisibility) {
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      child = VisibilityDetector(
        key: const ValueKey('edit-toggles'),
        onVisibilityChanged: (visibilityInfo) {
          context.read(toggleVisibilityProvider.notifier).state = visibilityInfo.visibleFraction > 0.1;
        },
        child: child,
      );
    }

    return child;
  }
}

class LayoutToggle extends StatelessWidget {
  const LayoutToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLayoutMode = context.watch(editProvider.select((state) => state == EditState.layoutMode));

    return SizedBox(
      width: 50,
      child: Center(
        child: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isLayoutMode ? context.onSurfaceColor : null,
              border: Border.all(color: context.onSurfaceColor),
            ),
            padding: const EdgeInsets.all(1),
            child: Icon(
              Icons.tune,
              color: isLayoutMode ? context.surfaceColor : context.onSurfaceColor,
              size: 18,
            ),
          ),
          onPressed: () {
            context.read(editProvider.notifier).toggleLayoutMode();
          },
        ),
      ),
    );
  }
}
