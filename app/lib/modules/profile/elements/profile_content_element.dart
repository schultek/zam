part of profile_module;

class ProfileElement with ElementBuilder<ContentElement> {
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
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => SimpleCard(
        title: context.tr.profile,
        icon: Icons.account_circle,
      ),
      onNavigate: (context) => const ProfilePage(),
    );
  }
}
