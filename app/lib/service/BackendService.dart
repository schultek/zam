import 'package:cloud_functions/cloud_functions.dart';

import 'AuthService.dart';

class BackendService {
  static Future<void> updateUserRole(String role) async {
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "updateUserRole");
    await callable.call(<String, dynamic>{
      "role": role,
    });
    if (AuthService.instance != null) {
      await AuthService.instance.updateUserRole();
    }
  }
}
