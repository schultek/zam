part of templates;

@MappableClass(discriminatorValue: 'swipe')
class SwipeTemplateModel extends TemplateModel {
  bool showLeftPage;
  bool showRightPage;

  SwipeTemplateModel({String? type, this.showLeftPage = true, this.showRightPage = true}) : super(type ?? 'swipe');

  @override
  String get name => 'Swipe Template';
  @override
  WidgetTemplate<TemplateModel> builder() => SwipeTemplate(this);

  @override
  List<Widget>? settings(BuildContext context) => SwipeTemplate.settings(context, this);
}

class SwipeTemplate extends WidgetTemplate<SwipeTemplateModel> {
  SwipeTemplate(SwipeTemplateModel model, {Key? key}) : super(model, key: key);

  final _scrollController = ScrollController();
  late final PageController pageController;

  static List<Widget> settings(BuildContext context, SwipeTemplateModel model) {
    return [
      SwitchListTile(
        title: const Text('Show left page'),
        value: model.showLeftPage,
        onChanged: (v) {
          model.update(context, (m) => m.copyWith(showLeftPage: v));
        },
      ),
      SwitchListTile(
        title: const Text('Show right page'),
        value: model.showRightPage,
        onChanged: (v) {
          model.update(context, (m) => m.copyWith(showRightPage: v));
        },
      )
    ];
  }

  @override
  void init([covariant SwipeTemplate? oldWidget]) {
    pageController = PageController(initialPage: config.showLeftPage ? 1 : 0);
  }

  @override
  void dispose() {
    pageController.dispose();
  }

  @override
  void onEdit(WidgetTemplateState state) {
    selectArea(state, pageController.page?.round() ?? 1);
  }

  void selectArea(WidgetTemplateState state, int areaIndex) {
    if (areaIndex == 0 && config.showLeftPage) {
      return state.selectWidgetAreaById<PageSegment>('left');
    }

    if ((areaIndex == 1 && !config.showLeftPage) || (areaIndex == 2 && config.showRightPage)) {
      return state.selectWidgetAreaById<PageSegment>('right');
    }

    return state.selectWidgetAreaById<ContentSegment>('body');
  }

  @override
  Widget build(BuildContext context, WidgetTemplateState state) {
    return Scaffold(
      body: Builder(
        builder: (context) => NestedWillPopScope(
          onWillPop: () async {
            if (!Navigator.of(context).canPop() && pageController.page != 1) {
              pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              return false;
            }
            return true;
          },
          child: PageView(
            physics: const BouncingScrollPhysics(),
            controller: pageController,
            onPageChanged: (index) {
              if (state.isEditing) {
                selectArea(state, index);
              }
            },
            children: [
              if (config.showLeftPage) const FullPageArea(id: 'left'),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                slivers: [
                  SliverTemplateHeader(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 20, left: 20, right: 20, bottom: 10),
                      child: Consumer(
                        builder: (context, ref, _) {
                          var trip = ref.watch(selectedTripProvider)!;
                          var user = ref.watch(tripUserProvider)!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TripSelectorButton(),
                              Text(
                                trip.name,
                                style: Theme.of(context).textTheme.headline5!.apply(color: context.getTextColor()),
                              ),
                              if (user.isOrganizer)
                                const SizedBox(
                                  width: 50,
                                  child: ReorderToggle(),
                                )
                              else
                                const SizedBox(width: 50),
                            ],
                          );
                        },
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
              if (config.showRightPage) const FullPageArea(id: 'right'),
            ],
          ),
        ),
      ),
    );
  }
}
