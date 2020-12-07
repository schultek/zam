part of widgets;

enum SegmentSize { Square, Wide }

class BodySegment extends ModuleWidget {
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context) onNavigate;
  final void Function() onTap;

  final SegmentSize size;

  BodySegment({this.builder, this.onNavigate, this.onTap, this.size = SegmentSize.Square}): super(key: UniqueKey());

  Widget build(BuildContext context) {
    return ModuleWidgetBuilder(
      key: key,
      builder: (context) => GestureDetector(
        child: AspectRatio(
          aspectRatio: size == SegmentSize.Square ? 1 / 1 : 2 / 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.grey[300],
              child: this.builder(context),
            ),
          ),
        ),
        onTap: () {
          if (this.onTap != null) {
            this.onTap();
          }
          if (this.onNavigate != null) {
            Navigator.of(context).push(ModulePageRoute(context, child: this.onNavigate(context)));
          }
        },
      ),
      placeholderBuilder: (context) => AspectRatio(
        aspectRatio: size == SegmentSize.Square ? 1 / 1 : 2 / 1,
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.grey[300].withOpacity(.2),
          child: Container(),
        ),
      ),
    );
  }
}
