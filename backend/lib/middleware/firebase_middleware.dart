import 'dart:async';

import 'package:api_agent/servers/shelf_router.dart';
import 'package:firebase_admin/firebase_admin.dart';
// ignore: implementation_imports
import 'package:firebase_admin/src/messaging.dart';

extension FirebaseContext on ApiRequest {
  App get app => context['firebase_app']! as App;
}

extension MulticaseMessage on CloudMessaging {
  Future<void> sendAll(Iterable<String> tokens, Message message) {
    return Future.wait([
      for (var token in tokens)
        send(Message(
          token: token,
          android: message.android,
          apns: message.apns,
          data: message.data,
          notification: message.notification,
          name: message.name,
          fcmOptions: message.fcmOptions,
          webpush: message.webpush,
        )).catchError((e) {}),
    ]);
  }
}

class FirebaseMiddleware extends ApiMiddleware {
  FirebaseMiddleware();

  @override
  FutureOr<dynamic> apply(ShelfApiRequest request, FutureOr<dynamic> Function(ApiRequest) next) async {
    return next(request.change(context: {'firebase_app': getFirebaseApp()}));
  }
}

App getFirebaseApp() {
  App app;
  try {
    app = FirebaseAdmin.instance.app()!;
  } catch (_) {
    app = FirebaseAdmin.instance.initializeApp(AppOptions(
      credential: FirebaseAdmin.instance.certFromPath('./serviceAccountKey.json'),
      projectId: 'jufa20',
    ));
  }
  return app;
}
