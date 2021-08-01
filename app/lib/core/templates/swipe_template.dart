part of templates;

@MappableClass(discriminatorValue: 'swipe')
class SwipeTemplateModel extends TemplateModel {
  SwipeTemplateModel({String? type}) : super(type ?? 'swipe');

  @override
  String get name => "Swipe Template";
  @override
  WidgetTemplate<TemplateModel> builder(ModuleData moduleData) {
    return SwipeTemplate(this, moduleData);
  }
}

class SwipeTemplate extends WidgetTemplate<SwipeTemplateModel> {
  SwipeTemplate(SwipeTemplateModel model, ModuleData moduleData) : super(model, moduleData);

  final _scrollController = ScrollController();
  final pageController = PageController(initialPage: 1);

  @override
  void onEdit(WidgetTemplateState state) {
    selectArea(state, pageController.page?.round() ?? 1);
  }

  void selectArea(WidgetTemplateState state, int areaIndex) {
    switch (areaIndex) {
      case 0:
        return state.selectWidgetAreaById<ContentSegment>('left');
      case 1:
        return state.selectWidgetAreaById<ContentSegment>('body');
      case 2:
        return state.selectWidgetAreaById<ContentSegment>('right');
    }
  }

  @override
  Widget build(BuildContext context, WidgetTemplateState state) {
    return TripTheme(
      theme: DarkTheme(),
      child: TemplateNavigator(
        home: Scaffold(
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              if (state.isEditing) {
                selectArea(state, index);
              }
            },
            children: [
              const ThemedBackground(child: FullPageArea(id: "left")),
              ThemedBackground(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverTemplateHeader(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 20, left: 20, right: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 50),
                            Builder(
                              builder: (context) => Text(
                                moduleData.trip.name,
                                style: Theme.of(context).textTheme.headline5!.apply(color: context.getTextColor()),
                              ),
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
              const ThemedBackground(child: FullPageArea(id: "right")),
            ],
          ),
        ),
      ),
    );
  }
}
