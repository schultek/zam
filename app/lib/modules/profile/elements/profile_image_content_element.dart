part of profile_module;

@MappableClass()
class ProfileImageElementParams {
  final bool showName;
  final bool showGreeting;

  ProfileImageElementParams({this.showName = true, this.showGreeting = true});
}

class ProfileImageElement with ElementBuilder<ContentElement> {
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
  FutureOr<ContentElement?> build(ModuleContext module) {
    var params = module.getParams<ProfileImageElementParams?>() ?? ProfileImageElementParams();
    return ContentElement(
      module: module,
      builder: (context) => ProfileImageWidget(params),
      onNavigate: (context) => const ProfilePage(),
      settings: (context) => [
        SwitchListTile(
          value: params.showName,
          title: const Text('Show Name'),
          onChanged: (value) async {
            module.updateParams(params.copyWith(showName: value));
          },
        ),
        SwitchListTile(
          value: params.showGreeting,
          title: const Text('Show Greeting'),
          onChanged: params.showName
              ? (value) async {
                  module.updateParams(params.copyWith(showGreeting: value));
                }
              : null,
        ),
      ],
    );
  }
}
