part of templates;

class BasicTemplate extends WidgetTemplate {
  BasicTemplate(ModuleData moduleData) : super("basic", moduleData);

  var _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverTemplateHeader(
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 50),
                Text(moduleData.trip.name, style: Theme.of(context).textTheme.headline5),
                SizedBox(width: 50, child: ReorderToggle()),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          sliver: SliverToBoxAdapter(child: QuickActionRowArea("hello")),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          sliver: SliverToBoxAdapter(child: BodyWidgetArea(_scrollController)),
        ),
        SliverToBoxAdapter(child: Container(height: 130)),
      ],
    );
  }
}

class SliverTemplateHeader extends SingleChildRenderObjectWidget {
  SliverTemplateHeader({Key key, Widget child}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => RenderSliverTemplateHeader();
}

class RenderSliverTemplateHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverTemplateHeader({RenderBox child}) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }

    final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );
    setChildParentData(child, constraints, geometry);
  }
}
