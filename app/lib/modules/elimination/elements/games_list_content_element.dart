part of elimination_module;

class GamesListContentElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.games_list;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.games_list_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.games_list_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    module.context.listen(gamesProvider, (_, __) {
      module.reload();
    });

    var games = await module.context.read(gamesProvider.future);

    if (games.isNotEmpty) {
      return ContentElement.list(
        module: module,
        builder: GamesListBuilder(),
        spacing: 10,
      );
    }

    if (module.context.read(isOrganizerProvider)) {
      return ContentElement.list(
        module: module,
        builder: (context) => [
          const MockGameTile(),
          const MockGameTile(),
          const MockGameTile(),
        ],
        spacing: 10,
        settings: SetupActionElementSettings(
          hint: 'Create a first game',
          action: (context) {},
        ),
      );
    }

    return null;
  }
}

class MockGameTile extends StatelessWidget {
  const MockGameTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var area = Area.of<ContentElement>(context);

    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: constraints.hasBoundedWidth
            ? constraints
            : BoxConstraints(maxWidth: min(300, area?.areaSize.width ?? 300) * 0.9),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 130,
                    height: 14,
                    color: context.onSurfaceColor.withOpacity(0.4),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 210,
                    height: 10,
                    color: context.onSurfaceColor.withOpacity(0.2),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var i = 0; i < 4; i++) ...[
                          ThemedSurface(
                            preference: const ColorPreference(useHighlightColor: true),
                            builder: (context, color) => CircleAvatar(
                              radius: 20,
                              backgroundColor: context.surfaceColor,
                              foregroundColor: context.onSurfaceColor,
                              child: const Icon(Icons.account_circle),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 110,
                    height: 12,
                    color: context.onSurfaceColor.withOpacity(0.2),
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
