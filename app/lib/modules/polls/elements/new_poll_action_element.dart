part of polls_module;

class NewPollActionElement with ElementBuilder<ActionElement> {
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
