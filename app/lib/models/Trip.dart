import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jufa/service/AuthService.dart';

class Trip {
  String name;
  String id;
  Map<String, TripUser> users;

  Trip(this.id, this.name, this.users);

  factory Trip.fromDocument(DocumentSnapshot document) {
    Map<String, Map<String, dynamic>> firebaseUsers = document.get("users");
    Map<String, TripUser> users = {};
    for(MapEntry<String, Map<String, dynamic>> user in firebaseUsers.entries) {
      users[user.key] = TripUser.fromMap(user.value);
    }
    return Trip(document.id, document.get("name"), users);
  }

  String getUserRole() {
    return this.users[AuthService.getUser().uid].role;
  }
}

class TripUser {
  String role;

  TripUser(this.role);

  factory TripUser.fromMap(Map<String, dynamic> user) {
    return TripUser(user["role"]);
  }
}