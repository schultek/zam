import 'package:flutter/material.dart';

import '../module/module_context.dart';

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
}

typedef SettingsAction = void Function(BuildContext context);
typedef SettingsBuilder = List<Widget> Function(BuildContext context);

enum ElementSize { square, wide }
