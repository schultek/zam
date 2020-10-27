import 'package:cloud_functions/cloud_functions.dart';

class BackendService {
  static Future<void> updateUserPermissions(bool canCreateTrips) async {
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "updateUserPermissions");
    await callable.call(<String, dynamic>{
      "canCreateTrips": canCreateTrips,
    });
  }

  static Future<void> addUserToTrip(String tripId, String userRole) async{
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "addUserToTrip");
    await callable.call(<String, dynamic>{
      "tripId": tripId,
      "userRole": userRole,
    });
  }
}
