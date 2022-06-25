part of web_module;

@MappableClass()
class LaunchUrlParams {
  final String? url;
  final String? label;
  final String? icon;
  final String? imageUrl;

  LaunchUrlParams({this.url, this.label, this.icon, this.imageUrl});
}

class LaunchUrlActionElement with ElementBuilder<ActionElement> {
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
  FutureOr<ActionElement?> build(ModuleContext module) async {
    var params = module.getParams<LaunchUrlParams?>() ?? LaunchUrlParams();

    if (params.url == null && !module.context.read(isOrganizerProvider)) {
      return null;
    }

    return ActionElement(
      module: module,
      icon: params.icon == null ? Icons.language : null,
      iconWidget: params.icon != null
          ? Center(
              child: Text(
                params.icon!,
                style: const TextStyle(fontSize: 18),
              ),
            )
          : null,
      text: params.label ?? module.context.tr.launch_url,
      onTap: (context) {
        var uri = Uri.tryParse(params.url ?? '');
        if (uri != null) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      settings: DialogElementSettings(
          builder: (context) => [
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
                  trailing: params.icon != null
                      ? Text(params.icon!, style: const TextStyle(fontSize: 24))
                      : const Icon(Icons.language),
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
              ]),
    );
  }
}
