import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'widgets/label_widget.dart';

class LabelModule extends ModuleBuilder {
  LabelModule() : super('label');

  @override
  String getName(BuildContext context) => context.tr.labels;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'text': buildTextLabel,
      };

  FutureOr<ContentSegment?> buildTextLabel(ModuleContext module) {
    if (module.hasParams) {
      var label = module.getParams<String>();
      return ContentSegment.text(
        module: module,
        builder: (_) => LabelWidget(label: label, module: module),
      );
    } else {
      if (module.context.read(isOrganizerProvider)) {
        return ContentSegment.text(
          module: module,
          builder: (_) => LabelWidget(module: module),
        );
      }
      return null;
    }
  }
}
