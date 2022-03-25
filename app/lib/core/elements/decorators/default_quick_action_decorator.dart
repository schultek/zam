import 'package:flutter/material.dart';

import '../../themes/theme_context.dart';
import '../../themes/trip_theme_data.dart';
import '../../themes/widgets/themed_surface.dart';
import '../quick_action.dart';
import 'element_decorator.dart';

class DefaultQuickActionDecorator implements ElementDecorator<QuickAction> {
  final ColorPreference colorPreference;
  const DefaultQuickActionDecorator([this.colorPreference = const ColorPreference()]);
  @override
  Widget decorateDragged(BuildContext context, QuickAction element, Widget child, double opacity) {
    return actionLayout(context, element, opacity: opacity);
  }

  @override
  Widget decorateElement(BuildContext context, QuickAction element, Widget child) {
    return actionLayout(context, element);
  }

  @override
  Widget decoratePlaceholder(BuildContext context, QuickAction element) {
    return actionLayout(context, element, isPlaceholder: true);
  }

  Widget actionLayout(BuildContext context, QuickAction element, {bool isPlaceholder = false, double opacity = 0}) {
    var textColor = context.onSurfaceColor;
    var textStyle = context.theme.textTheme.bodyText1!.apply(fontSizeDelta: -2);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ThemedSurface(
        preference: colorPreference,
        builder: (context, fillColor) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fillColor.withOpacity(isPlaceholder ? 0.8 : 1),
                boxShadow: [
                  if (!isPlaceholder)
                    BoxShadow(
                      blurRadius: 8,
                      color: textColor.withOpacity(opacity * 0.5),
                    )
                ],
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              child: Icon(element.icon, color: isPlaceholder ? Colors.transparent : context.onSurfaceColor),
            ),
            if (isPlaceholder)
              Container(
                width: _textSize(element.text, textStyle).width,
                height: 16,
                color: fillColor.withOpacity(0.8),
              )
            else
              Text(
                element.text,
                style: textStyle.apply(
                  color: textColor,
                  shadows: [Shadow(blurRadius: 10, color: textColor.withOpacity(opacity * 0.5))],
                ),
                overflow: TextOverflow.visible,
                softWrap: false,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
