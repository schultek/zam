import 'package:flutter/material.dart';

import '../../themes/themes.dart';
import '../module_element.dart';
import 'element_icon_button.dart';

class ElementSettingsButton extends StatelessWidget {
  const ElementSettingsButton({Key? key}) : super(key: key);

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
