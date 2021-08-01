part of elements;

enum SegmentSize { Square, Wide }
enum SegmentAllow { FullScreen, Card }

class ContentSegment extends ModuleElement {
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context)? onNavigate;
  final void Function()? onTap;
  final SegmentSize size;
  final List<SegmentAllow>? allow;

  ContentSegment({required this.builder, this.onNavigate, this.onTap, this.size = SegmentSize.Square, this.allow})
      : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return ModuleElementBuilder<ContentSegment>(
      key: key,
      builder: (context) => GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
          if (onNavigate != null) {
            Navigator.of(context).push(ModulePageRoute(context, child: onNavigate!(context)));
          }
        },
        child: buildElement(context),
      ),
      placeholderBuilder: buildPlaceholder,
      draggingBuilder: (child, opacity) {
        print("BUILD DRAGGING");
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
      },
    );
  }

  Widget buildPlaceholder(BuildContext context) {
    return WidgetArea.of<ContentSegment>(context)?.decoratePlaceholder(context, this) ?? _defaultDecorator();
  }

  Widget buildElement(BuildContext context) {
    return WidgetArea.of<ContentSegment>(context)?.decorateElement(context, this) ??
        _defaultDecorator(builder(context));
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
    if (size == SegmentSize.Wide) {
      return w;
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: w,
      );
    }
  }
}
