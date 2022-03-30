part of chat_module;

class ChatActionElement with ElementBuilderMixin<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.chat,
      text: module.context.tr.chat,
      onNavigate: (context) => const ChatPage(),
    );
  }
}
