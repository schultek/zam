part of elimination_module;

class GamesActionElement with ElementBuilder<ActionElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.games;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.games_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.games_text);
  }

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
