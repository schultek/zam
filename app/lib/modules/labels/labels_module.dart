import 'dart:async';
import 'dart:convert';

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

  FutureOr<ContentSegment?> buildTextLabel(ModuleContext context) {
    var idProvider = IdProvider();
    return context.when(
      withId: (id) {
        var label = utf8.decode(base64.decode(id));
        return ContentSegment.text(
          context: context,
          idProvider: idProvider,
          builder: (context) => LabelWidget(label: label, idProvider: idProvider),
        );
      },
      withoutId: () {
        if (context.context.read(isOrganizerProvider)) {
          var idProvider = IdProvider();
          return ContentSegment.text(
            context: context,
            idProvider: idProvider,
            builder: (context) => LabelWidget(idProvider: idProvider),
          );
        }
        return null;
      },
    );
  }
}
