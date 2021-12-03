import 'package:flutter/material.dart';

import '../../areas/widget_area.dart';
import '../../reorderable/reorderable_listener.dart';
import '../../route/route.dart';
import '../../templates/widget_template.dart';
import '../../themes/widgets/trip_theme.dart';
import '../module_element.dart';

class RemovableDraggableModuleWidget<T extends ModuleElement> extends StatelessWidget {
  final Widget child;
  const RemovableDraggableModuleWidget({required Key key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var templateState = WidgetTemplate.of(context);

    if (templateState.isEditing) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Stack(clipBehavior: Clip.none, children: [
            ConstrainedBox(
              constraints: constraints,
              child: ReorderableListener<T>(
                delay: const Duration(milliseconds: 300),
                child: AbsorbPointer(child: child),
              ),
            ),
            Positioned(
              top: -5,
              left: -5,
              child: AnimatedBuilder(
                animation: templateState.transition,
                builder: (context, child) {
                  return Transform.scale(
                    scale: templateState.transition.value,
                    child: FittedBox(
                      child: child,
                    ),
                  );
                },
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  shadowColor: Colors.black54,
                  elevation: 4,
                  color: context.theme.errorColor, // button color
                  child: InkWell(
                    splashColor: Colors.redAccent,
                    onTap: () {
                      var areaState = WidgetArea.of<T>(context)!;
                      areaState.removeWidget(key!);
                    }, // inkwell color
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(Icons.close, size: 15, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ]);
        },
      );
    } else {
      return ModuleRouteTransition(child: child);
    }
  }
}
