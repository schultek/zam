part of elimination_module;

class GamesContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => SimpleCard(
        title: context.tr.elimination,
        icon: Icons.list,
      ),
      onNavigate: (context) => const GamesPage(),
    );
  }
}
