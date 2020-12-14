part of templates;

class BasicTemplate extends WidgetTemplate {
  BasicTemplate(ModuleData moduleData) : super("basic", moduleData);

  double scrollOffset = 200;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.grey.shade300,
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
        Positioned.fill(
          child: DraggableScrollableSheet(
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 8)],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                child: BodyWidgetArea(scrollController),
              );
            },
          ),
        ),
      ],
    );
  }
}
