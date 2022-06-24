import 'package:flutter/material.dart';

import '../module/module_context.dart';
import 'widgets/element_settings_dialog.dart';

class ModuleElementKey extends GlobalObjectKey {
  const ModuleElementKey._(String value) : super(value);

  factory ModuleElementKey(String value) {
    return _keyMap[value] ??= ModuleElementKey._(value);
  }

  static final _keyMap = <String, ModuleElementKey>{};

  ModuleElementKey copy(String suffix) {
    return ModuleElementKey('$value-$suffix');
  }
}

abstract class ModuleElement extends StatelessWidget {
  ModuleElement({required this.module, this.settings, this.settingsAction})
      : assert(settings == null || settingsAction == null),
        super(key: ModuleElementKey(module.keyId));

  String get id => module.id;

  final ModuleContext module;
  final SettingsBuilder? settings;
  final SettingsAction? settingsAction;

  @override
  ModuleElementKey get key => super.key! as ModuleElementKey;

  void onRemoved(BuildContext context) {}

  static ModuleElement? of(BuildContext context) {
    if (context is _ModuleElement) {
      return context.widget;
    } else {
      ModuleElement? element;
      context.visitAncestorElements((e) {
        if (e is _ModuleElement) {
          element = e.widget;
          return false;
        }
        return true;
      });
      return element;
    }
  }

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
