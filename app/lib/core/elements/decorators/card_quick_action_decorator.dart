import 'package:flutter/material.dart';

import '../../themes/widgets/themed_surface.dart';
import '../../themes/widgets/trip_theme.dart';
import '../quick_action.dart';
import 'element_decorator.dart';

class CardQuickActionDecorator implements ElementDecorator<QuickAction> {
  const CardQuickActionDecorator();
  @override
  Widget decorateDragged(BuildContext context, QuickAction element, Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -2, color: Colors.black.withOpacity(opacity * 0.5))],
      ),
      child: child,
    );
  }

  @override
  Widget decorateElement(BuildContext context, QuickAction element, Widget child) {
    return actionLayout(context, element);
  }

  @override
  Widget decoratePlaceholder(BuildContext context, QuickAction element) {
    return actionLayout(context, element, isPlaceholder: true);
  }

  Widget actionLayout(BuildContext context, QuickAction element, {bool isPlaceholder = false}) {
    var textColor = context.getTextColor();
    var textStyle = Theme.of(context).textTheme.bodyText1!;
    return AspectRatio(
      aspectRatio: 1,
      child: ThemedSurface(
        builder: (context, fillColor) => Material(
          textStyle: TextStyle(color: context.getTextColor()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: fillColor.withOpacity(isPlaceholder ? 0.8 : 1),
          child: isPlaceholder
              ? Container()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(element.icon, color: context.getTextColor()),
                    const SizedBox(height: 8),
                    Text(
                      element.text,
                      style: textStyle.apply(color: textColor),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
