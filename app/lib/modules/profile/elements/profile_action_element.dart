part of profile_module;

class ProfileActionElement with ElementBuilder<ActionElement> {
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
