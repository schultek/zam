part of elimination_module;

class GamesActionElement with ElementBuilderMixin<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.casino,
      text: module.context.tr.games,
      onNavigate: (context) => const GamesPage(),
    );
  }
}
