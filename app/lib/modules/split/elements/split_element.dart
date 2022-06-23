part of split_module;

class SplitElement with ElementBuilder<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => SimpleCard(title: context.tr.split, icon: Icons.monetization_on),
      onNavigate: (context) => const SplitPage(),
    );
  }
}
