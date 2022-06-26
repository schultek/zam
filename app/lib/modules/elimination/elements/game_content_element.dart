part of elimination_module;

class GameContentElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.new_game;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.new_game_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.new_game_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    if (module.hasParams) {
      var gameId = module.getParams<String>();
      return ContentElement(
        module: module,
        builder: (context) => EliminationGameCard(gameId),
        settings: ActionElementSettings(action: (context) async {
          var gameId = await Navigator.of(context).push(SelectGamePage.route());
          if (gameId != null) {
            module.updateParams(gameId);
          }
        }),
      );
    } else {
      if (!module.context.read(isOrganizerProvider)) {
        return null;
      }
      return ContentElement(
        module: module,
        builder: (context) => SimpleCard(title: context.tr.new_game, icon: Icons.casino),
        settings: SetupActionElementSettings(
            hint: module.context.tr.select_a_game,
            action: (context) async {
              var gameId = await Navigator.of(context).push(SelectGamePage.route());
              if (gameId != null) {
                module.updateParams(gameId);
              }
            }),
      );
    }
  }
}
