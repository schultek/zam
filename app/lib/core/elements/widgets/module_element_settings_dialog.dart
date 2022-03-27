import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../helpers/extensions.dart';
import '../../module/module_context.dart';
import '../../themes/themes.dart';
import '../../widgets/settings_section.dart';
import '../module_element.dart';
import 'module_element_builder.dart';

class SettingsDialogController {
  SettingsDialogController(this._module, this._settings);

  _ModuleElementSettingsDialogState? _state;

  SettingsBuilder _settings;
  SettingsBuilder get settings => _settings;

  ModuleContext _module;
  ModuleContext get module => _module;

  void update(ModuleContext module, SettingsBuilder settings) {
    _module = module;
    _settings = settings;
    _state?.update();
  }
}

class ModuleSettingsButton extends StatefulWidget {
  const ModuleSettingsButton({required this.module, required this.settings, Key? key}) : super(key: key);

  final ModuleContext module;
  final SettingsBuilder settings;

  @override
  State<ModuleSettingsButton> createState() => _ModuleSettingsButtonState();
}

class _ModuleSettingsButtonState extends State<ModuleSettingsButton> {
  late int currentIndex;

  SettingsDialogController? controller;
  NavigatorState? navigator;

  @override
  void didUpdateWidget(covariant ModuleSettingsButton oldWidget) {
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
      navigator?.pop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModuleIconButton(
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ThemedSurface(
        preference: const ColorPreference(deltaElevation: 2),
        builder: (context, color) => ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: color.withOpacity(0.4),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 20),
                      child: DefaultTextStyle(
                        style: DialogTheme.of(context).titleTextStyle ?? Theme.of(context).textTheme.headline6!,
                        child: Text(widget.controller.module.parent.getName(context)),
                      ),
                    ),
                    DefaultTextStyle(
                      style: DialogTheme.of(context).contentTextStyle ?? Theme.of(context).textTheme.subtitle1!,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SettingsSection(
                          children: widget.controller.settings(context),
                          backgroundOpacity: 0.4,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 2),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          child: Text(context.tr.ok),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
