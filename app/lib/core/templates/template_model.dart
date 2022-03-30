import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import 'swipe/swipe_template.dart';
import 'template.dart';

@MappableClass(discriminatorKey: 'type')
abstract class TemplateModel {
  const TemplateModel();

  String get name;
  Template builder();

  Widget preview();

  List<Widget> settings(BuildContext context) => [];

  static List<TemplateModel> get all => [
        // GridTemplateModel(),
        const SwipeTemplateModel(),
        // FocusTemplateModel(),
        // DropsTemplateModel(),
      ];
}

@MappableClass(discriminatorKey: 'type')
class TemplatePage {
  const TemplatePage();
}
