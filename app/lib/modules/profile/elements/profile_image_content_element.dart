part of profile_module;

class ProfileImageElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => const ProfileImageWidget(),
      onNavigate: (context) => const ProfilePage(),
    );
  }
}
