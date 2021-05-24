part of elements;

enum SegmentSize { Square, Wide }

class ContentSegment extends ModuleElement {
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context)? onNavigate;
  final void Function()? onTap;
  final SegmentSize size;

  ContentSegment({required this.builder, this.onNavigate, this.onTap, this.size = SegmentSize.Square})
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
        child: getSegment(context, false),
      ),
      placeholderBuilder: (context) => getSegment(context, true),
      decorationBuilder: (child, opacity) {
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

  Widget getSegment(BuildContext context, bool isPlaceholder) {
    var child = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FillColor(
        preference: ColorPreference(id: id),
        builder: (context, fillColor) => Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: fillColor.withOpacity(isPlaceholder ? 0.4 : 1),
          child: isPlaceholder ? Container() : builder(context),
        ),
      ),
    );

    if (size == SegmentSize.Wide) {
      return child;
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: child,
      );
    }
  }

  @override
  Widget buildPlaceholder(BuildContext context) {
    return getSegment(context, true);
  }
}
