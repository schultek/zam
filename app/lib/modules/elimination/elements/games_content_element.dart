part of elimination_module;

class GamesContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => SimpleCard(
        title: context.tr.games,
        icon: Icons.casino,
      ),
      onNavigate: (context) => const GamesPage(),
    );
  }
}
