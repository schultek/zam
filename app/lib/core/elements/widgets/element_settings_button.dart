import 'package:flutter/material.dart';

import '../../module/module_context.dart';
import '../../themes/themes.dart';
import '../module_element.dart';
import 'element_icon_button.dart';
import 'element_settings_dialog.dart';

class ElementSettingsButton extends StatefulWidget {
  const ElementSettingsButton({required this.module, required this.settings, Key? key}) : super(key: key);

  final ModuleContext module;
  final SettingsBuilder settings;

  @override
  State<ElementSettingsButton> createState() => _ElementSettingsButtonState();
}

class _ElementSettingsButtonState extends State<ElementSettingsButton> {
  late int currentIndex;

  SettingsDialogController? controller;
  NavigatorState? navigator;

  @override
  void didUpdateWidget(covariant ElementSettingsButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller != null) {
      controller!.update(widget.module, widget.settings);
    }
  }

  @override
  void didChangeDependencies() {
    navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (controller != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        navigator?.pop();
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElementIconButton(
      icon: Icons.settings,
      onPressed: () async {
        controller = SettingsDialogController(widget.module, widget.settings);
        await ModuleElementSettingsDialog.show(context, controller!);
        controller = null;
      }, // inkwell
      color: context.onSurfaceColor,
      iconColor: context.surfaceColor,
    );
  }
}
