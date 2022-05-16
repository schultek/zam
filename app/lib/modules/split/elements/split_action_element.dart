part of split_module;

class SplitActionElement with ElementBuilderMixin<ActionElement> {
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
