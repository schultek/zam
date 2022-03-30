part of elimination_module;

class GamesListContentElement with ElementBuilderMixin<ContentElement> {
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
