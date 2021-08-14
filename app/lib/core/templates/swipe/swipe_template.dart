part of templates;

@MappableClass(discriminatorValue: 'swipe')
class SwipeTemplateModel extends TemplateModel {
  SwipeTemplateModel({String? type}) : super(type ?? 'swipe');

  @override
  String get name => "Swipe Template";
  @override
  WidgetTemplate<TemplateModel> builder() => SwipeTemplate(this);
}

class SwipeTemplate extends WidgetTemplate<SwipeTemplateModel> {
  SwipeTemplate(SwipeTemplateModel model) : super(model);

  final _scrollController = ScrollController();
  final pageController = PageController(initialPage: 1);

  @override
  void onEdit(WidgetTemplateState state) {
    selectArea(state, pageController.page?.round() ?? 1);
  }

  void selectArea(WidgetTemplateState state, int areaIndex) {
    switch (areaIndex) {
      case 0:
        return state.selectWidgetAreaById<PageSegment>('left');
      case 1:
        return state.selectWidgetAreaById<ContentSegment>('body');
      case 2:
        return state.selectWidgetAreaById<PageSegment>('right');
    }
  }

  @override
  Widget build(BuildContext context, WidgetTemplateState state) {
    return TripTheme(
      theme: DarkTheme(),
      child: TemplateNavigator(
        home: Scaffold(
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
                  const KeepAlive(
                    key: ValueKey("left"),
                    child: ThemedBackground(child: FullPageArea(id: "left")),
                  ),
                  KeepAlive(
                    key: const ValueKey("body"),
                    child: ThemedBackground(
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        slivers: [
                          SliverTemplateHeader(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top + 20, left: 20, right: 20, bottom: 10),
                              child: Consumer(
                                builder: (context, watch, _) {
                                  var trip = watch(selectedTripProvider)!;
                                  var user = watch(tripUserProvider)!;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (user.isOrganizer)
                                        const SizedBox(
                                          width: 50,
                                          child: ReorderToggle(),
                                        )
                                      else
                                        const SizedBox(width: 50),
                                      Text(
                                        trip.name,
                                        style:
                                            Theme.of(context).textTheme.headline5!.apply(color: context.getTextColor()),
                                      ),
                                      if (user.isOrganizer)
                                        SizedBox(
                                          width: 50,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.settings,
                                              color: context.getTextColor(),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(SwipeTemplateSettings.route());
                                            },
                                          ),
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
                    ),
                  ),
                  const KeepAlive(
                    key: ValueKey("right"),
                    child: ThemedBackground(child: FullPageArea(id: "right")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KeepAlive extends StatefulWidget {
  final Widget child;
  const KeepAlive({Key? key, required this.child}) : super(key: key);

  @override
  _KeepAliveState createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
