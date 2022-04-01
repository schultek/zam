import 'dart:async';

import 'package:shelf/shelf.dart';

import 'api/api.dart';
import 'src/functions_framework.dart';

@CloudFunction()
Future<Response> apiService(Request request) async {
  return router.call(request);
}
