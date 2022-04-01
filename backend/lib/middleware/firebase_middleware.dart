import 'dart:async';

import 'package:api_agent/servers/shelf_router.dart';
import 'package:firebase_admin/firebase_admin.dart';

extension FirebaseContext on ApiRequest {
  App get app => context['app']! as App;
}

class FirebaseMiddleware extends ApiMiddleware {
  FirebaseMiddleware();

  @override
  FutureOr<dynamic> apply(ShelfApiRequest request, FutureOr<dynamic> Function(ApiRequest) next) async {
    App app;
    try {
      app = FirebaseAdmin.instance.app()!;
    } catch (_) {
      app = FirebaseAdmin.instance.initializeApp();
    }
    next(request.change(context: {'firebase_app': app}));
  }
}
