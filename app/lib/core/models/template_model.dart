part of models;

@MappableClass(discriminatorKey: 'type')
abstract class TemplateModel {
  String type;
  TemplateModel(this.type);

  String get name;
  WidgetTemplate builder();

  List<Widget>? settings(BuildContext context) => null;
}

extension ModelUpdate<T extends TemplateModel> on T {
  Future<void> update(BuildContext context, T Function(T model) fn) async {
    var updated = fn(this);
    await context.read(tripsLogicProvider).updateTemplateModel(updated);
  }
}
