import 'dart:async';

import 'package:jaspr/jaspr_server.dart';

import 'api/api.dart';
import 'components/app.dart';
import 'middleware/firebase_middleware.dart';
import 'src/functions_framework.dart';

@CloudFunction()
Future<Response> apiService(Request request) async {
  return router.call(request);
}

final pageHandler = serveApp((request, render) async {
  var id = request.url.path;

  var app = getFirebaseApp();

  var doc = await app.firestore().doc('pages/$id').get();

  if (!doc.exists) {
    return Response.seeOther(request.requestedUri.replace(path: '/'));
  }

  var groupId = doc.get('group');
  var group = await app.firestore().doc('groups/$groupId').get();

  var landingPage = group.get('landingPage') as Map<String, dynamic>;

  if (landingPage['enabled'] != true) {
    return Response.seeOther(request.url.replace(path: '/'));
  }

  return render(App(group.data()));
});

@CloudFunction()
Future<Response> groupService(Request request) async => pageHandler(request);
