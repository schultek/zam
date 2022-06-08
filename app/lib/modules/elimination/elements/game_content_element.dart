part of elimination_module;

class GameContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    if (module.hasParams) {
      var gameId = module.getParams<String>();
      return ContentElement(
        module: module,
        builder: (context) => EliminationGameCard(gameId),
        settingsAction: (context) async {
          var gameId = await Navigator.of(context).push(SelectGamePage.route());
          if (gameId != null) {
            module.updateParams(gameId);
          }
        },
      );
    } else {
      if (!module.context.read(isOrganizerProvider)) {
        return null;
      }
      return ContentElement(
        module: module,
        builder: (context) => NeedsSetupCard(child: SimpleCard(title: context.tr.new_game, icon: Icons.casino)),
        settingsAction: (context) async {
          var gameId = await Navigator.of(context).push(SelectGamePage.route());
          if (gameId != null) {
            module.updateParams(gameId);
          }
        },
      );
    }
  }
}
