import 'dart:async';

import 'package:api_agent/servers/shelf_router.dart';
import 'package:firebase_admin/firebase_admin.dart';
// ignore: implementation_imports, depend_on_referenced_packages
import 'package:openid_client/src/model.dart';

// ignore: implementation_imports, depend_on_referenced_packages
export 'package:openid_client/src/model.dart';

class Headers {
  static const auth = 'authorization';
}

extension AuthContext on ApiRequest {
  OpenIdClaims get user => context['claims']! as OpenIdClaims;
}

extension UserClaims on OpenIdClaims {
  String get uid => getTyped('user_id')!;
  bool get isAdmin => getTyped('isAdmin') ?? false;
}

class AuthMiddleware extends ApiMiddleware {
  bool Function(OpenIdClaims claims)? validateClaims;
  AuthMiddleware([this.validateClaims]);

  @override
  FutureOr<dynamic> apply(ShelfApiRequest request, FutureOr<dynamic> Function(ApiRequest) next) async {
    if (request.headers[Headers.auth]?.startsWith('Bearer ') ?? false) {
      var time = DateTime.now();
      var token = request.headers[Headers.auth]!.split('Bearer ')[1];
      late IdToken idToken;
      try {
        idToken = await FirebaseAdmin.instance.app()!.auth().verifyIdToken(token);
        print('Validated ID Token in ${DateTime.now().difference(time)}');
      } catch (e) {
        throw ApiException(401, 'Forbidden: $e');
      }
      if (validateClaims == null || validateClaims!(idToken.claims)) {
        return next(request.change(context: {'claims': idToken.claims}));
      } else {
        throw ApiException(401, 'User is not allowed to call ${request.url}');
      }
    } else {
      throw ApiException(401, 'User authentication header is missing.');
    }
  }
}
