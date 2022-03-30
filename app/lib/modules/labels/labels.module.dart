import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../module.dart';
import 'widgets/label_widget.dart';

class LabelModule extends ModuleBuilder {
  LabelModule() : super('label');

  @override
  String getName(BuildContext context) => context.tr.labels;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'text': TextLabel(),
      };
}

class TextLabel with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    if (module.hasParams) {
      var label = module.getParams<String>();
      return ContentElement.text(
        module: module,
        builder: (_) => LabelWidget(label: label, module: module),
      );
    } else {
      if (module.context.read(isOrganizerProvider)) {
        return ContentElement.text(
          module: module,
          builder: (_) => LabelWidget(module: module),
        );
      }
      return null;
    }
  }
}
