part of elimination_module;

class NewGameActionElement with ElementBuilder<ActionElement> {
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
