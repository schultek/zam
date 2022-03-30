part of polls_module;

class PollsContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => SimpleCard(
        title: context.tr.polls,
        icon: Icons.list,
      ),
      onNavigate: (context) => const PollsPage(),
    );
  }
}
