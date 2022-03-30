part of users_module;

class UsersContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => SimpleCard(
        title: context.tr.users,
        icon: Icons.supervised_user_circle,
      ),
      onNavigate: (context) => const UsersPage(),
    );
  }
}
