import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../../main.mapper.g.dart';
import '../layouts/layout_model.dart';
import 'swipe/swipe_template.dart';
import 'template.dart';

@MappableClass(discriminatorKey: 'type')
abstract class TemplateModel with Mappable {
  const TemplateModel();

  String get name;
  Template builder();

  Widget preview();

  List<Widget> settings(BuildContext context) => [];

  static List<TemplateModel> get all => [
        SwipeTemplateModel(),
      ];
}

class LayoutIdModel {
  final LayoutModel layout;
  final String id;

  LayoutIdModel(this.id, this.layout);

  String? getAreaIdToFocus() {
    return '${id}_${layout.getAreaIdToFocus()}';
  }

  bool hasAreaId(String id) {
    var parts = id.split('_');
    return parts.length == 2 && parts[0] == this.id && layout.hasAreaId(parts[1]);
  }
}

extension LayoutWithId on LayoutModel {
  LayoutIdModel withId(String id) {
    return LayoutIdModel(id, this);
  }
}

@MappableClass(discriminatorKey: 'type')
class TemplatePage {
  const TemplatePage();
}
