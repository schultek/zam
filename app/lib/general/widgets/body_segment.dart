part of widgets;

enum SegmentSize { Square, Wide }

class BodySegment extends ModuleWidget {
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context)? onNavigate;
  final void Function()? onTap;
  final SegmentSize size;

  BodySegment({required this.builder, this.onNavigate, this.onTap, this.size = SegmentSize.Square})
      : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return ModuleWidgetBuilder<BodySegment>(
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
    );
  }

  Widget getSegment(BuildContext context, bool isPlaceholder) {
    var child = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.grey.shade300.withOpacity(isPlaceholder ? 0.4 : 1),
        child: isPlaceholder ? Container() : builder(context),
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
