import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';

class LabelWidget extends StatelessWidget {
  const LabelWidget({this.label, this.padding = const EdgeInsets.all(8), this.align, Key? key}) : super(key: key);

  final String? label;
  final EdgeInsets padding;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    Widget child = Padding(
      padding: padding,
      child: Text(
        label ?? context.tr.add_label,
        textAlign: align,
        style: context.theme.textTheme.headline6!
            .apply(color: context.onSurfaceColor.withOpacity(label != null ? 1 : 0.5)),
      ),
    );

    if (WidgetSelector.existsIn(context)) {
      child = IntrinsicWidth(child: child);
    }
    return child;
  }
}
