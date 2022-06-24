part of split_module;

class SplitElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.split;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.split_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.split_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => SimpleCard(title: context.tr.split, icon: Icons.monetization_on),
      onNavigate: (context) => const SplitPage(),
    );
  }
}
