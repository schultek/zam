part of polls_module;

class NewPollActionElement with ElementBuilderMixin<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.add,
      text: module.context.tr.new_poll,
      onNavigate: (context) => const CreatePollPage(),
    );
  }
}
