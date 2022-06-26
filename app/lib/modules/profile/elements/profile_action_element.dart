part of profile_module;

class ProfileActionElement with ElementBuilder<ActionElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.profile;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.profile_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.profile_text);
  }

  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.account_circle,
      text: module.context.tr.profile,
      onNavigate: (context) => const ProfilePage(),
    );
  }
}
