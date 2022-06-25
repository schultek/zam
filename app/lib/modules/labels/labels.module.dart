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
  final LabelColor color;

  const LabelParams({this.label, this.centered = false, this.color = LabelColor.text});
}

@MappableEnum()
enum LabelColor { text, primary, secondary }

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

    if (params.label != null || module.context.read(isOrganizerProvider)) {
      return ContentElement.text(
        module: module,
        builder: (_) => LabelWidget(
          label: params.label,
          color: params.color,
          align: params.centered ? TextAlign.center : null,
        ),
        settings: DialogElementSettings(builder: LabelSettingsBuilder(params, module)),
      );
    }

    return null;
  }
}

class LabelSettingsBuilder {
  LabelParams params;
  ModuleContext module;

  LabelSettingsBuilder(this.params, this.module);

  List<Widget> call(BuildContext context) {
    Widget colorItem(LabelColor color) {
      var c = color == LabelColor.text
          ? context.onSurfaceColor
          : color == LabelColor.primary
              ? context.theme.colorScheme.primary
              : context.theme.colorScheme.secondary;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: c,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            color.name.toUpperCase(),
            style: context.theme.textTheme.bodySmall,
          ),
        ],
      );
    }

    return [
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
      PopupMenuButton<LabelColor>(
        itemBuilder: (context) => [
          for (var color in LabelColor.values)
            PopupMenuItem(
              value: color,
              child: colorItem(color),
            ),
        ],
        onSelected: (value) {
          module.updateParams(params.copyWith(color: value));
        },
        child: ListTile(
          title: Text(context.tr.text_color),
          trailing: colorItem(params.color),
        ),
      ),
    ];
  }
}
