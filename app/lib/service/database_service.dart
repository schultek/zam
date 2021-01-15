// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

class DatabaseService {
  static Future<DocumentReference> createNewTrip(String tripName, String userId) {
    return FirebaseFirestore.instance.collection("trips").add({
      "name": tripName,
      "users": {
        userId: {"role": UserRoles.Organizer}
      },
    });
  }
}
