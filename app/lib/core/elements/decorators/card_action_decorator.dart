import 'package:flutter/material.dart';

import '../../themes/themes.dart';
import '../action_element.dart';
import 'element_decorator.dart';

class CardActionDecorator implements ElementDecorator<ActionElement> {
  const CardActionDecorator();
  @override
  Widget decorateDragged(BuildContext context, ActionElement element, Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: -2, color: Colors.black.withOpacity(opacity * 0.5))],
      ),
      child: child,
    );
  }

  @override
  Widget decorateElement(BuildContext context, ActionElement element, Widget child) {
    return actionLayout(context, element);
  }

  @override
  Widget decoratePlaceholder(BuildContext context, ActionElement element) {
    return actionLayout(context, null);
  }

  @override
  Widget getPlaceholder(BuildContext context) {
    return actionLayout(context, null);
  }

  Widget actionLayout(BuildContext context, ActionElement? element) {
    return AspectRatio(
      aspectRatio: 1,
      child: ThemedSurface(
        preference: const ColorPreference(useHighlightColor: true),
        builder: (context, fillColor) => DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(color: context.onSurfaceColor, blurRadius: 20, spreadRadius: -15),
          ]),
          child: Material(
            textStyle: TextStyle(color: context.onSurfaceColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: fillColor.withOpacity(element == null ? 0.8 : 1),
            child: element == null
                ? Container()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      element.icon != null
                          ? Icon(element.icon, color: context.onSurfaceColor)
                          : element.iconWidget ?? Container(),
                      const SizedBox(height: 8),
                      Text(
                        element.textBuilder(context),
                        style: context.theme.textTheme.bodyText1!.apply(color: context.onSurfaceColor),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
