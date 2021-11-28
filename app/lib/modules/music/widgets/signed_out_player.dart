import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../widgets/simple_card.dart';
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
      child: const SimpleCard(title: 'Play Spotify\n(Tap to login)', icon: Icons.music_note),
    );
  }

  Future<String?> openSignIn(BuildContext context, Uri authUri, String redirectUri) async {
    var response = await Navigator.of(context).push<String>(
      MaterialPageRoute(
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
        ),
      ),
    );
    return response;
  }
}
