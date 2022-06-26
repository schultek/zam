part of split_module;

class SplitActionElement with ElementBuilder<ActionElement> {
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
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.monetization_on,
      text: module.context.tr.split,
      onNavigate: (context) => const SplitPage(),
    );
  }
}
