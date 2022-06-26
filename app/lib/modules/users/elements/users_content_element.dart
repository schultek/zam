part of users_module;

class UsersContentElement with ElementBuilder<ContentElement> {
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
