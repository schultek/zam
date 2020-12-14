part of widgets;

enum SegmentSize { Square, Wide }

class BodySegment extends ModuleWidget {
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context) onNavigate;
  final void Function() onTap;

  final SegmentSize size;

  BodySegment({this.builder, this.onNavigate, this.onTap, this.size = SegmentSize.Square}) : super(key: UniqueKey());

  Widget build(BuildContext context) {
    return ModuleWidgetBuilder<BodySegment>(
      key: key,
      builder: (context) => GestureDetector(
        child: getSegment(context, false),
        onTap: () {
          if (this.onTap != null) {
            this.onTap();
          }
          if (this.onNavigate != null) {
            Navigator.of(context).push(ModulePageRoute(context, child: this.onNavigate(context)));
          }
        },
      ),
      placeholderBuilder: (context) => getSegment(context, true),
    );
  }

  Widget getSegment(BuildContext context, bool isPlaceholder) {
    var child = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.grey[300].withOpacity(isPlaceholder ? 0.4 : 1),
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
