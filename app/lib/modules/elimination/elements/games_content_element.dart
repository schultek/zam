part of elimination_module;

class GamesContentElement with ElementBuilder<ContentElement> {
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
