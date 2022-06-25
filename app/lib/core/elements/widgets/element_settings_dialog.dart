import 'package:flutter/material.dart';

import '../../../helpers/extensions.dart';
import '../../module/module_context.dart';
import '../../widgets/settings_dialog.dart';
import '../../widgets/settings_section.dart';
import '../module_element.dart';

class SettingsDialogController {
  SettingsDialogController(this._module, this._settings);

  _ModuleElementSettingsDialogState? _state;

  DialogElementSettings _settings;
  DialogElementSettings get settings => _settings;

  ModuleContext _module;
  ModuleContext get module => _module;

  void update(ModuleContext module, DialogElementSettings settings) {
    _module = module;
    _settings = settings;
    _state?.update();
  }

  void close() {
    if (_state?.mounted ?? false) {
      Navigator.pop(_state!.context);
    }
  }
}

class ModuleElementSettingsDialog<T extends ModuleElement> extends StatefulWidget {
  const ModuleElementSettingsDialog({required this.controller, Key? key}) : super(key: key);

  final SettingsDialogController controller;

  @override
  State<ModuleElementSettingsDialog> createState() => _ModuleElementSettingsDialogState();

  static Future<void> show<T extends ModuleElement>(BuildContext context, SettingsDialogController controller) async {
    await showDialog(
      context: context,
      builder: (context) => ModuleElementSettingsDialog<T>(controller: controller),
      useRootNavigator: false,
      barrierColor: Colors.black26,
    );
  }
}

class _ModuleElementSettingsDialogState extends State<ModuleElementSettingsDialog> {
  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
  }

  @override
  void didUpdateWidget(covariant ModuleElementSettingsDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller._state = this;
  }

  void update() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsDialog(
      title: Text(widget.controller.module.parent.getName(context)),
      content: SettingsSection(
        margin: EdgeInsets.zero,
        children: widget.controller.settings.builder(context),
        backgroundOpacity: 0.3,
      ),
      actions: [
        TextButton(
          child: Text(context.tr.ok),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
