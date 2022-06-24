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
    var games = await module.context.read(gamesProvider.future);
    if (games.isNotEmpty) {
      return ContentElement.list(
        module: module,
        builder: GamesListBuilder(),
        spacing: 10,
      );
    }
    return null;
  }
}
