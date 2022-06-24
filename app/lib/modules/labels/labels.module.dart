import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/widgets/input_list_tile.dart';
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

@MappableClass()
class LabelParams {
  final String? label;
  final bool centered;

  const LabelParams({this.label, this.centered = false});
}

class TextLabel with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.labels;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.labels_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.labels_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    var params = module.getParams<LabelParams?>() ?? const LabelParams();

    if (params.label == null && !module.context.read(isOrganizerProvider)) {
      return null;
    }

    return ContentElement.text(
      module: module,
      builder: (_) => LabelWidget(
        label: params.label,
        align: params.centered ? TextAlign.center : null,
      ),
      settings: (context) => [
        InputListTile(
          label: context.tr.label,
          value: params.label,
          onChanged: (value) {
            module.updateParams(params.copyWith(label: value));
          },
        ),
        SwitchListTile(
          title: Text(context.tr.centered),
          value: params.centered,
          onChanged: (value) {
            module.updateParams(params.copyWith(centered: value));
          },
        ),
      ],
    );
  }
}
