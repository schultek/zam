import 'package:flutter/material.dart';

import '../../module/module_context.dart';
import '../../themes/themes.dart';
import '../module_element.dart';
import 'element_icon_button.dart';
import 'element_settings_dialog.dart';

class ElementSettingsButton extends StatefulWidget {
  const ElementSettingsButton({required this.module, this.settings, this.settingsAction, Key? key})
      : assert(settings != null || settingsAction != null),
        super(key: key);

  final ModuleContext module;
  final SettingsBuilder? settings;
  final SettingsAction? settingsAction;

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
      if (widget.settings != null) {
        controller!.update(widget.module, widget.settings!);
      } else {
        maybeCloseDialog();
      }
    }
  }

  @override
  void didChangeDependencies() {
    navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    maybeCloseDialog();
    super.dispose();
  }

  void maybeCloseDialog() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (controller != null) {
        navigator?.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElementIconButton(
      icon: Icons.settings,
      onPressed: () async {
        if (widget.settings != null) {
          controller = SettingsDialogController(widget.module, widget.settings!);
          await ModuleElementSettingsDialog.show(context, controller!);
          controller = null;
        } else {
          widget.settingsAction!.call(context);
        }
      }, // inkwell
      color: context.onSurfaceColor,
      iconColor: context.surfaceColor,
    );
  }
}
