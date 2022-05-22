import 'package:flutter/material.dart';

import '../module/module_context.dart';
import 'widgets/element_settings_dialog.dart';

abstract class ModuleElement extends StatelessWidget {
  ModuleElement({required this.module, this.settings, this.settingsAction})
      : assert(settings == null || settingsAction == null),
        super(key: ValueKey(module.keyId));

  String get id => module.id;

  final ModuleContext module;
  final SettingsBuilder? settings;
  final SettingsAction? settingsAction;

  @override
  Key get key => super.key!;

  void onRemoved(BuildContext context) {}

  static void openSettings(BuildContext context) {
    if (context is _ModuleElement) {
      context.openSettings();
    } else {
      context.visitAncestorElements((e) {
        if (e is _ModuleElement) {
          e.openSettings();
          return false;
        }
        return true;
      });
    }
  }

  @override
  StatelessElement createElement() => _ModuleElement(this);
}

class _ModuleElement extends StatelessElement {
  _ModuleElement(ModuleElement widget) : super(widget);

  @override
  ModuleElement get widget => super.widget as ModuleElement;

  SettingsDialogController? controller;

  @override
  void update(covariant StatelessWidget newWidget) {
    super.update(newWidget);
    if (controller != null) {
      if (widget.settings != null) {
        controller!.update(widget.module, widget.settings!);
      } else {
        controller!.close();
      }
    }
  }

  Future<void> openSettings() async {
    if (widget.settings != null) {
      controller = SettingsDialogController(widget.module, widget.settings!);
      await ModuleElementSettingsDialog.show(this, controller!);
      controller = null;
    } else {
      widget.settingsAction!.call(this);
    }
  }
}

typedef SettingsAction = void Function(BuildContext context);
typedef SettingsBuilder = List<Widget> Function(BuildContext context);

enum ElementSize { square, wide }
