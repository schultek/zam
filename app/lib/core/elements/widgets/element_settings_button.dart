import 'package:flutter/material.dart';

import '../../module/module_context.dart';
import '../../themes/themes.dart';
import '../module_element.dart';
import 'element_icon_button.dart';

class ElementSettingsButton extends StatelessWidget {
  const ElementSettingsButton({required this.module, this.settings, this.settingsAction, Key? key})
      : assert(settings != null || settingsAction != null),
        super(key: key);

  final ModuleContext module;
  final SettingsBuilder? settings;
  final SettingsAction? settingsAction;

  @override
  Widget build(BuildContext context) {
    return ElementIconButton(
      icon: Icons.settings,
      onPressed: () async {
        ModuleElement.openSettings(context);
      }, // inkwell
      color: context.onSurfaceColor,
      iconColor: context.surfaceColor,
    );
  }
}
