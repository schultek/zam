part of profile_module;

class ProfileUserActionElement with ElementBuilder<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement.builder(
      module: module,
      iconWidget: UserAvatar(id: module.context.read(userIdProvider)!, needsSurface: false),
      text: (context) => context.watch(nicknameProvider(module.context.read(userIdProvider)!)) ?? context.tr.anonymous,
      onNavigate: (context) => const ProfilePage(),
    );
  }
}
