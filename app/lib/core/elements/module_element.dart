import 'package:flutter/material.dart';

import '../module/module_context.dart';

abstract class ModuleElement extends StatelessWidget {
  ModuleElement({required this.module, this.settings}) : super(key: ValueKey(module.keyId));

  String get id => module.id;

  final ModuleContext module;
  final SettingsBuilder? settings;

  @override
  Key get key => super.key!;

  void onRemoved(BuildContext context) {}
}

typedef SettingsBuilder = List<Widget> Function(BuildContext context);

enum ElementSize { square, wide }
