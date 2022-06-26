import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../providers/groups/selected_group_provider.dart';
import '../labels.module.dart';

class LabelWidget extends StatelessWidget {
  const LabelWidget(
      {this.label, this.color = LabelColor.text, this.padding = const EdgeInsets.all(8), this.align, Key? key})
      : super(key: key);

  final String? label;
  final LabelColor color;
  final EdgeInsets padding;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    Color color = this.color == LabelColor.text
        ? context.onSurfaceColor
        : this.color == LabelColor.primary
            ? context.theme.colorScheme.primary
            : context.theme.colorScheme.secondary;

    Widget child = Padding(
      padding: padding,
      child: Text(
        label ?? context.tr.add_label,
        textAlign: align,
        style: context.theme.textTheme.headline6!.apply(color: color.withOpacity(label != null ? 1 : 0.5)),
      ),
    );

    if (label == null && context.read(isOrganizerProvider)) {
      child = GestureDetector(
        onTap: () {
          ModuleElement.openSettings(context);
        },
        child: child,
      );
    }

    if (WidgetSelector.existsIn(context)) {
      child = IntrinsicWidth(child: child);
    }
    return child;
  }
}
