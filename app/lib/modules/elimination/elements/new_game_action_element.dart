part of elimination_module;

class NewGameActionElement with ElementBuilder<ActionElement> {
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
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.add,
      text: module.context.tr.new_game,
      onNavigate: (context) => const CreateGamePage(),
    );
  }
}
