import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/core.dart';
import '../../../widgets/nested_will_pop_scope.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({required this.url, this.canNavigate = true, Key? key}) : super(key: key);

  final String url;
  final bool canNavigate;

  @override
  State<WebViewPage> createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  WebViewController? controller;

  @override
  void didUpdateWidget(covariant WebViewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      controller?.loadUrl(widget.url);
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
