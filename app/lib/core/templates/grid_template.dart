part of templates;

@MappableClass(discriminatorValue: 'grid')
class GridTemplateModel extends TemplateModel {
  GridTemplateModel({String? type}) : super(type ?? 'grid');

  @override
  String get name => "Grid Template";
  @override
  WidgetTemplate<TemplateModel> builder(ModuleData moduleData) {
    return GridTemplate(this, moduleData);
  }
}

class GridTemplate extends WidgetTemplate<GridTemplateModel> {
  GridTemplate(GridTemplateModel model, ModuleData moduleData) : super(model, moduleData);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetTemplateState state) {
    return TripTheme(
      theme: DarkTheme(),
      child: TemplateNavigator(
        home: Scaffold(
          body: ThemedBackground(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverTemplateHeader(
                  child: Container(
                    padding:
                        EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 20, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 50),
                        Text(
                          moduleData.trip.name,
                          style: Theme.of(context).textTheme.headline5!.apply(color: context.getTextColor()),
                        ),
                        SizedBox(width: 50, child: ReorderToggle()),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                  sliver: SliverToBoxAdapter(child: BodyWidgetArea(_scrollController)),
                ),
                if (state.isEditing) SliverToBoxAdapter(child: Container(height: 130)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SliverTemplateHeader extends SingleChildRenderObjectWidget {
  const SliverTemplateHeader({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => RenderSliverTemplateHeader();
}

class RenderSliverTemplateHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverTemplateHeader({RenderBox? child}) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

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
    setChildParentData(child!, constraints, geometry!);
  }
}
