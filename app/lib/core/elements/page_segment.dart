part of elements;

@ModuleWidgetReflectable()
class PageSegment extends ModuleElement with ModuleElementBuilder<PageSegment> {
  final Widget Function(BuildContext context) builder;

  PageSegment({required this.builder}) : super(key: UniqueKey());

  @override
  Widget buildPlaceholder(BuildContext context) {
    return WidgetArea.of<PageSegment>(context)?.decoratePlaceholder(context, this) ?? _defaultDecorator();
  }

  @override
  Widget buildElement(BuildContext context) {
    return WidgetArea.of<PageSegment>(context)?.decorateElement(context, this) ?? _defaultDecorator(builder(context));
  }

  @override
  Widget decorationBuilder(Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: -2,
          color: Colors.black.withOpacity(opacity * 0.5),
        )
      ]),
      child: child,
    );
  }

  Widget _defaultDecorator([Widget? child]) {
    var w = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FillColor(
        preference: ColorPreference(id: id),
        builder: (context, fillColor) => Material(
          textStyle: TextStyle(color: context.getTextColor()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: fillColor.withOpacity(child != null ? 1 : 0.4),
          child: child ?? Container(),
        ),
      ),
    );
    return w;
  }
}
