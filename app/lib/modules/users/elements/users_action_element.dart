part of users_module;

class UsersActionElement with ElementBuilderMixin<ActionElement> {
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
