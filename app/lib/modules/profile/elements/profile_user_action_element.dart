part of profile_module;

class ProfileUserActionElement with ElementBuilder<ActionElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.profile_image_title;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.profile_image_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.profile_image_text);
  }

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
