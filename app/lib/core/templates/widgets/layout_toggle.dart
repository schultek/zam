import 'package:flutter/material.dart';

import '../../themes/themes.dart';
import '../widget_template.dart';

class LayoutToggle extends StatelessWidget {
  const LayoutToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLayoutMode = WidgetTemplate.of(context).isLayoutMode;

    return SizedBox(
      width: 50,
      child: Center(
        child: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isLayoutMode ? context.onSurfaceColor : context.surfaceColor,
              border: Border.all(color: context.onSurfaceColor),
            ),
            padding: const EdgeInsets.all(2),
            child: Icon(
              Icons.tune,
              color: isLayoutMode ? context.surfaceColor : context.onSurfaceColor,
              size: 18,
            ),
          ),
          onPressed: () {
            WidgetTemplate.of(context, listen: false).toggleLayoutMode();
          },
        ),
      ),
    );
  }
}
