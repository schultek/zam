part of areas;

class FullPageArea extends WidgetArea<PageSegment> {
  const FullPageArea({required String id}) : super(id);

  @override
  State<StatefulWidget> createState() => FullPageAreaState();
}

class FullPageAreaState extends WidgetAreaState<FullPageArea, PageSegment> {
  PageSegment? content;

  @override
  void initArea(List<PageSegment> widgets) => content = widgets.isNotEmpty ? widgets.first : null;

  @override
  List<PageSegment> getWidgets() => [if (content != null) content!];

  @override
  EdgeInsetsGeometry getMargin() =>
      template.isEditing ? const EdgeInsets.symmetric(horizontal: 10, vertical: 40) : super.getMargin();

  @override
  EdgeInsetsGeometry getPadding() => template.isEditing ? super.getPadding() : EdgeInsets.zero;

  @override
  Widget buildArea(BuildContext context) {
    return content ?? const Center(child: Text("No Content"));
  }

  @override
  BoxConstraints constrainWidget(PageSegment widget) => BoxConstraints.tight(areaSize);

  @override
  PageSegment getWidgetFromKey(Key key) => content!;

  @override
  bool hasKey(Key key) => content?.key == key;

  @override
  bool canInsertItem(_) => true;

  @override
  void insertItem(PageSegment item) {
    if (content != null) removeWidget(content!.key);
    setState(() => content = item);
  }

  @override
  void removeItem(Key key) {
    if (key == content?.key) {
      setState(() => content = null);
    }
  }

  @override
  Widget? decorateElement(BuildContext context, PageSegment element) {
    return Material(
      textStyle: TextStyle(color: context.getTextColor()),
      color: Colors.transparent,
      child: element.builder(context),
    );
  }

  @override
  bool didReorderItem(Offset offset, Key key) => false;
}
