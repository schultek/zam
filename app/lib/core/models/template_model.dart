part of models;

@MappableClass(discriminatorKey: 'type')
abstract class TemplateModel {
  String type;
  TemplateModel(this.type);

  String get name;
  WidgetTemplate builder();
}
