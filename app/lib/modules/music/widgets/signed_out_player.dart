import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/themes/themes.dart';
import '../music_providers.dart';

class SignedOutPlayer extends StatelessWidget {
  const SignedOutPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await context
            .read(musicLogicProvider)
            .signInToSpotify((authUri, redirectUri) => openSignIn(context, authUri, redirectUri));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note,
              color: context.getTextColor(),
              size: 50,
            ),
            const SizedBox(height: 5),
            const Text(
              'Play Spotify\n(Tap to login)',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> openSignIn(BuildContext context, Uri authUri, String redirectUri) async {
    var response = await Navigator.of(context).push<String>(MaterialPageRoute(
        builder: (context) => SafeArea(
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: authUri.toString(),
                navigationDelegate: (navReq) {
                  if (navReq.url.startsWith(redirectUri)) {
                    Navigator.of(context).pop(navReq.url);
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )));
    return response;
  }
}
