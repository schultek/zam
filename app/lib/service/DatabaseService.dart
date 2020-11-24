import 'package:cloud_firestore/cloud_firestore.dart';

import 'AuthService.dart';

class DatabaseService {

  static Future<DocumentReference> createNewTrip(String tripName, String userId) {
    return FirebaseFirestore.instance.collection("trips").add({
      "name": tripName,
      "users": {userId: {"role": UserRoles.Organizer}},
    });
  }

}
