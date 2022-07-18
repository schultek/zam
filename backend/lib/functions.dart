import 'dart:async';

import 'package:shelf/shelf.dart';

import 'api/api.dart';
import 'src/functions_framework.dart';

@CloudFunction()
Future<Response> apiService(Request request) async {
  return router.call(request);
}

@CloudFunction()
Future<Response> groupService(Request request) async {
  var id = request.url.path;
  return Response.ok(
    '<!DOCTYLE html><html><head></head><body><p>Landing Page Group $id</p></body></html>',
    headers: {'Content-Type': 'text/html'},
  );
}
