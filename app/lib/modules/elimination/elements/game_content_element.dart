part of elimination_module;

class GameContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    if (module.hasParams) {
      var gameId = module.getParams<String>();
      return ContentElement(
        module: module,
        builder: (context) => EliminationGameCard(gameId),
      );
    } else {
      if (!module.context.read(isOrganizerProvider)) {
        return null;
      }
      return ContentElement(
        module: module,
        builder: (context) => NeedsSetupCard(title: context.tr.new_game, icon: Icons.casino),
        settings: (context) => [
          ListTile(
            title: Text(context.tr.new_game),
            onTap: () async {
              var gameId = await Navigator.of(context).push(CreateGamePage.route());
              if (gameId != null) {
                module.updateParams(gameId);
              }
            },
          ),
        ],
      );
    }
  }
}
