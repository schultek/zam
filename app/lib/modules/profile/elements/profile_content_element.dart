part of profile_module;

class ProfileElement with ElementBuilder<ContentElement> {
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
