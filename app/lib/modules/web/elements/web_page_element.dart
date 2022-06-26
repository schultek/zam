part of web_module;

@MappableClass()
class WebPageParams {
  final String? url;
  final bool canNavigate;

  const WebPageParams({this.url, this.canNavigate = true});
}

class WebPageElement with ElementBuilder<PageElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.web_page;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.web_page_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.web_page_text);
  }

  @override
  FutureOr<PageElement?> build(ModuleContext module) {
    var params = module.getParams<WebPageParams?>() ?? const WebPageParams();
    var webViewKey = GlobalObjectKey<WebViewPageState>('webview-${module.keyId}');

    if (params.url != null) {
      return PageElement(
        module: module,
        builder: (context) => WebViewPage(
          key: webViewKey,
          url: params.url!,
          canNavigate: params.canNavigate,
        ),
        settings: DialogElementSettings(builder: WebPageSettingsBuilder(params, module, webViewKey)),
      );
    }

    if (module.context.read(isOrganizerProvider)) {
      return PageElement(
        module: module,
        builder: (context) => SimpleCard(title: context.tr.website, icon: Icons.language),
        settings: SetupDialogElementSettings(
          hint: module.context.tr.set_a_url,
          builder: WebPageSettingsBuilder(params, module, webViewKey),
        ),
      );
    }

    return null;
  }
}

class WebPageSettingsBuilder {
  final WebPageParams params;
  final ModuleContext module;
  final GlobalKey<WebViewPageState> webViewKey;

  WebPageSettingsBuilder(this.params, this.module, this.webViewKey);

  List<Widget> call(BuildContext context) {
    return [
      InputListTile(
        label: 'Url',
        value: params.url,
        trailing: webViewKey.currentState?.controller != null
            ? IconButton(
                icon: const Icon(Icons.explore),
                onPressed: () async {
                  var url = await webViewKey.currentState?.controller?.currentUrl();
                  if (url != null) {
                    module.updateParams(params.copyWith(url: url));
                  }
                },
              )
            : null,
        onChanged: (value) {
          if (!value.startsWith(RegExp('https?://'))) {
            value = 'https://$value';
          }
          module.updateParams(params.copyWith(url: value));
        },
        keyboardType: TextInputType.url,
      ),
      SwitchListTile(
        title: Text(context.tr.allow_navigation),
        value: params.canNavigate,
        onChanged: (value) {
          module.updateParams(params.copyWith(canNavigate: value));
        },
      ),
    ];
  }
}
