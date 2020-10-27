import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String name;
  String id;
  Map<String, TripUser> users;

  Trip(this.id, this.name, this.users);

  factory Trip.fromDocument(DocumentSnapshot document) {
    Map<String, TripUser> users;
    for(var user in document.get("users").entries) {
      users["userId"]
    }
    return Trip(document.id, document.get("name"),);
  }
}

class TripUser {
  String role;

  TripUser(this.role);

  factory TripUser.fromMap(Map<String, dynamic> user) {
    return TripUser(user["role"]);
  }
}