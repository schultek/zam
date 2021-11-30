import 'package:flutter/material.dart';

import '../module/module_context.dart';

abstract class ModuleElement extends StatelessWidget {
  ModuleElement({required Key key, required ModuleContext context})
      : id = context.id,
        super(key: key);

  final String id;

  @override
  Key get key => super.key!;

  void onRemoved(BuildContext context) {}
}

enum SegmentSize { square, wide }
