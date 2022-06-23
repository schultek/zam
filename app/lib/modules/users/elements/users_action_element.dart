part of users_module;

class UsersActionElement with ElementBuilder<ActionElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.users;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.users_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.users_text);
  }

  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.supervised_user_circle,
      text: module.context.tr.users,
      onNavigate: (context) => const UsersPage(),
    );
  }
}
