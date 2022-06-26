part of web_module;

class LaunchUrlContentElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.launch_url;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.launch_url_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.launch_url_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    var params = module.getParams<LaunchUrlParams?>() ?? LaunchUrlParams();

    if (params.url != null) {
      return ContentElement(
        module: module,
        builder: (context) => UrlShortcutCard(params),
        onTap: (context) {
          var uri = Uri.tryParse(params.url!);
          if (uri != null) {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        settings: DialogElementSettings(builder: LaunchUrlSettingsBuilder(params, module)),
      );
    }

    if (module.context.read(isOrganizerProvider)) {
      return ContentElement(
        module: module,
        builder: (context) => UrlShortcutCard(params),
        settings: SetupDialogElementSettings(
          hint: module.context.tr.set_a_url,
          builder: LaunchUrlSettingsBuilder(params, module),
        ),
      );
    }

    return null;
  }
}

class LaunchUrlSettingsBuilder {
  final LaunchUrlParams params;
  final ModuleContext module;

  LaunchUrlSettingsBuilder(this.params, this.module);

  List<Widget> call(BuildContext context) {
    return [
      InputListTile(
        label: context.tr.label,
        value: params.label,
        onChanged: (value) {
          module.updateParams(params.copyWith(label: value));
        },
      ),
      ListTile(
        title: const Text('Icon'),
        subtitle: Text(params.icon != null ? context.tr.tap_to_change : context.tr.tap_to_add),
        trailing:
            params.icon != null ? Text(params.icon!, style: const TextStyle(fontSize: 24)) : const Icon(Icons.language),
        onTap: () async {
          var emoji = await showEmojiKeyboard(context);
          module.updateParams(params.copyWith(icon: emoji));
        },
      ),
      InputListTile(
        label: 'Url',
        value: params.url,
        onChanged: (value) {
          var uri = Uri.parse(value);
          if (!uri.hasScheme) {
            value = 'https://$value';
          }
          module.updateParams(params.copyWith(url: value));
        },
        keyboardType: TextInputType.url,
      ),
      SelectImageListTile(
        label: context.tr.custom_image,
        hasImage: params.imageUrl != null,
        crop: OverlayType.rectangle,
        onImageSelected: (bytes) async {
          var link = await context.read(groupsLogicProvider).uploadFile('web/images/${module.keyId}.png', bytes);
          module.updateParams(params.copyWith(imageUrl: link));
        },
        onDelete: () {
          module.updateParams(params.copyWith(imageUrl: null));
        },
      ),
    ];
  }
}
