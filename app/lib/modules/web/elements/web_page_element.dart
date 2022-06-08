part of web_module;

@MappableClass()
class WebPageParams {
  final String? url;
  final bool canNavigate;

  const WebPageParams({this.url, this.canNavigate = true});
}

class WebPageElement with ElementBuilderMixin<PageElement> {
  @override
  FutureOr<PageElement?> build(ModuleContext module) {
    var params = module.getParams<WebPageParams?>() ?? const WebPageParams();
    var webViewKey = GlobalObjectKey<_WebViewPageState>('webview-${module.keyId}');

    return PageElement(
      module: module,
      builder: (context) => WebViewPage(
        key: webViewKey,
        url: params.url,
        canNavigate: params.canNavigate,
      ),
      settings: (context) => [
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
      ],
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({this.url, this.canNavigate = true, Key? key}) : super(key: key);

  final String? url;
  final bool canNavigate;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? controller;

  @override
  void didUpdateWidget(covariant WebViewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != null && widget.url != oldWidget.url) {
      controller?.loadUrl(widget.url!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (WidgetSelector.existsIn(context)) {
      return ThemedSurface(
        builder: (context, color) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color,
          ),
          alignment: Alignment.center,
          child: Icon(Icons.language, size: MediaQuery.of(context).size.width / 2),
        ),
      );
    }
    if (widget.url == null) {
      return NeedsSetupCard(child: SimpleCard(title: context.tr.website, icon: Icons.language));
    }
    return NestedWillPopScope(
      onWillPop: () async {
        if (controller == null) {
          return true;
        } else {
          if (await controller!.canGoBack()) {
            await controller!.goBack();
            return false;
          } else {
            return true;
          }
        }
      },
      child: WebView(
        key: const ValueKey('webview'),
        onWebViewCreated: (controller) {
          this.controller = controller;
        },
        initialUrl: widget.url,
        backgroundColor: context.surfaceColor,
        javascriptMode: JavascriptMode.unrestricted,
        gestureRecognizers: {Factory(() => VerticalDragGestureRecognizer())},
        gestureNavigationEnabled: true,
        navigationDelegate: (request) {
          return widget.canNavigate ? NavigationDecision.navigate : NavigationDecision.prevent;
        },
      ),
    );
  }
}
