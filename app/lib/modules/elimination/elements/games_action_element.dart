part of elimination_module;

class GamesActionElement with ElementBuilderMixin<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.list,
      text: module.context.tr.elimination,
      onNavigate: (context) => const GamesPage(),
    );
  }
}
