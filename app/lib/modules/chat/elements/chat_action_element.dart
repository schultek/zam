part of chat_module;

class ChatActionElement with ElementBuilder<ActionElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.chat;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.channels_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.channels_text);
  }

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
