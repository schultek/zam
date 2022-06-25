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

  @override
  String toString() {
    return '[ModuleElementKey $value]';
  }
}

abstract class ModuleElement extends StatelessWidget {
  ModuleElement({required this.module, this.settings}) : super(key: ModuleElementKey(module.keyId));

  String get id => module.id;

  final ModuleContext module;
  final ElementSettings? settings;

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
      var settings = widget.settings;
      if (settings is DialogElementSettings) {
        controller!.update(widget.module, settings);
      } else {
        controller!.close();
      }
    }
  }

  Future<void> openSettings() async {
    var settings = widget.settings;
    if (settings is DialogElementSettings) {
      controller = SettingsDialogController(widget.module, settings);
      await ModuleElementSettingsDialog.show(this, controller!);
      controller = null;
    } else if (settings is ActionElementSettings) {
      settings.action(this);
    }
  }
}

typedef SettingsAction = void Function(BuildContext context);
typedef SettingsBuilder = List<Widget> Function(BuildContext context);

enum ElementSize { square, wide }

class ElementSettings {
  bool get showButton => this is! SetupElementSettings;
}

class DialogElementSettings extends ElementSettings {
  final SettingsBuilder builder;

  DialogElementSettings({required this.builder});
}

class ActionElementSettings extends ElementSettings {
  final SettingsAction action;

  ActionElementSettings({required this.action});
}

abstract class SetupElementSettings extends ElementSettings {
  final String hint;

  SetupElementSettings({required this.hint});
}

class SetupActionElementSettings extends SetupElementSettings implements ActionElementSettings {
  @override
  final SettingsAction action;

  SetupActionElementSettings({
    required String hint,
    required this.action,
  }) : super(hint: hint);
}

class SetupDialogElementSettings extends SetupElementSettings implements DialogElementSettings {
  @override
  final SettingsBuilder builder;

  SetupDialogElementSettings({
    required String hint,
    required this.builder,
  }) : super(hint: hint);
}
