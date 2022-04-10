import 'dart:async';

import 'package:api_agent/server.dart';
import 'package:firebase_admin/firebase_admin.dart' show UserRecord;
import 'package:shared/api/app.server.dart';
import 'package:shared/models/models.dart';

import '../../middleware/auth_middleware.dart';
import '../../middleware/firebase_middleware.dart';

extension on UserRecord {
  UserData toUserData() {
    return UserData.get(
      id: uid,
      displayName: displayName,
      email: email,
      emailVerified: emailVerified,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      disabled: disabled,
      metadata: metadata != null ? UserMetadata(metadata!.creationTime, metadata!.lastSignInTime) : null,
      providerData: providerData
          ?.map((info) => UserInfo.get(
                uid: info.uid,
                providerId: info.providerId,
                displayName: info.displayName,
                email: info.email,
                photoUrl: info.photoUrl,
                phoneNumber: info.phoneNumber,
              ))
          .toList(),
      claims: UserClaims.from(customClaims),
    );
  }
}

final adminApi = ApplyMiddleware(
  middleware: AuthMiddleware((claims) => claims.isAdmin),
  child: AdminApi(),
);

class AdminApi extends AdminApiEndpoint {
  @override
  FutureOr<List<UserData>> getAllUsers(ApiRequest request) async {
    var response = await request.app.auth().listUsers();
    return response.users.map((user) => user.toUserData()).toList();
  }

  @override
  FutureOr<void> setClaims(String userId, UserClaims claims, ApiRequest request) async {
    await request.app.auth().setCustomUserClaims(userId, claims.toMap());
  }
}
