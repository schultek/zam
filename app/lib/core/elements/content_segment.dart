part of elements;

class IdProvider {
  String? _id;

  void provide(BuildContext context, String id) {
    _id = id;
    WidgetArea.of<ContentSegment>(context)!.updateWidgetsInTrip();
  }

  String? _getId(String id) {
    return _id != null ? id.split('/').take(2).followedBy([_id!]).join('/') : id;
  }
}

enum SegmentSize { square, wide }

class ContentSegment extends ModuleElement with ModuleElementBuilder<ContentSegment> {
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context)? onNavigate;
  final void Function()? onTap;
  final SegmentSize size;
  final IdProvider? idProvider;
  final void Function(BuildContext context)? whenRemoved;

  ContentSegment({
    required ModuleContext context,
    required this.builder,
    this.onNavigate,
    this.onTap,
    this.size = SegmentSize.square,
    this.idProvider,
    this.whenRemoved,
  }) : super(key: UniqueKey(), context: context);

  @override
  String get id => idProvider?._getId(super.id) ?? super.id;

  @override
  void onRemoved(BuildContext context) => whenRemoved?.call(context);

  @override
  Widget buildPlaceholder(BuildContext context) {
    return WidgetArea.of<ContentSegment>(context)?.decoratePlaceholder(context, this) ?? _defaultDecorator();
  }

  @override
  Widget buildElement(BuildContext context) {
    var child =
        WidgetArea.of<ContentSegment>(context)?.decorateElement(context, this) ?? _defaultDecorator(builder(context));
    if (onTap != null || onNavigate != null) {
      child = GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
          if (onNavigate != null) {
            Navigator.of(context).push(ModulePageRoute(context, child: onNavigate!(context)));
          }
        },
        child: child,
      );
    }
    return child;
  }

  @override
  Widget decorationBuilder(Widget child, double opacity) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: -2,
            color: Colors.black.withOpacity(opacity * 0.5),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _defaultDecorator([Widget? child]) {
    var w = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ThemedSurface(
        builder: (context, fillColor) => Material(
          textStyle: TextStyle(color: context.getTextColor()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: fillColor.withOpacity(child != null ? 1 : 0.4),
          child: child ?? Container(),
        ),
      ),
    );
    if (size == SegmentSize.wide) {
      return w;
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: w,
      );
    }
  }
}
