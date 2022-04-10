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
          icon: CustomPaint(
            size: const Size.square(20),
            painter: LayoutTogglePainter(isLayoutMode, context.onSurfaceColor),
          ),
          onPressed: () {
            context.read(editProvider.notifier).toggleLayoutMode();
          },
        ),
      ),
    );
  }
}

class LayoutTogglePainter extends CustomPainter {
  final bool isLayoutMode;
  final Color color;
  LayoutTogglePainter(this.isLayoutMode, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var p = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(4)));
    Path sub(Path p, RRect rrect) {
      return Path.combine(PathOperation.difference, p, Path()..addRRect(rrect));
    }

    var m = 3.5;
    var s = size.width - m * 2;
    var e = s / 9;

    var tune = Path()
      ..addRect(Rect.fromLTWH(0, e, 5 * e, e))
      ..addRect(Rect.fromLTWH(6 * e, 0, e, 3 * e))
      ..addRect(Rect.fromLTWH(7 * e, e, 2 * e, e))
      ..addRect(Rect.fromLTWH(0, 4 * e, 2 * e, e))
      ..addRect(Rect.fromLTWH(2 * e, 3 * e, e, 3 * e))
      ..addRect(Rect.fromLTWH(4 * e, 4 * e, 5 * e, e))
      ..addRect(Rect.fromLTWH(0, 7 * e, 3 * e, e))
      ..addRect(Rect.fromLTWH(4 * e, 6 * e, e, 3 * e))
      ..addRect(Rect.fromLTWH(5 * e, 7 * e, 4 * e, e));
    tune = tune.shift(Offset(m, m));

    if (!isLayoutMode) {
      p = sub(p, RRect.fromLTRBR(1, 1, size.width - 1, size.height - 1, const Radius.circular(3)));
      p = Path.combine(PathOperation.union, p, tune);
    } else {
      p = Path.combine(PathOperation.difference, p, tune);
    }
    canvas.drawPath(p, Paint()..color = color);
  }

  @override
  bool shouldRepaint(LayoutTogglePainter oldDelegate) {
    return oldDelegate.isLayoutMode != isLayoutMode || oldDelegate.color != color;
  }
}
