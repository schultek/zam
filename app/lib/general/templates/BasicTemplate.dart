part of templates;

class BasicTemplate extends TripTemplate {
  BasicTemplate(ModuleData moduleData) : super("basic", moduleData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 50),
              Text(moduleData.trip.name, style: Theme.of(context).textTheme.headline5),
              SizedBox(width: 50, child: ReorderToggle()),
            ],
          ),
        ),
        Expanded(child: BodyWidgetArea())
      ],
    );
  }
}
