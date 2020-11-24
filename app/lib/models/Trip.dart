import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jufa/service/AuthService.dart';

class Trip {
  String name;
  String id;
  Map<String, TripUser> users;

  Trip(this.id, this.name, this.users);

  factory Trip.fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> firebaseUsers = document.get("users");
    Map<String, TripUser> users = {};
    for(MapEntry<String, dynamic> user in firebaseUsers.entries) {
      users[user.key] = TripUser.fromMap(user.value);
    }
    return Trip(document.id, document.get("name"), users);
  }

  currentUser() {
    return this.users[AuthService.getUser().uid];
  }
}

class TripUser {
  String role;
  String nickname;

  TripUser(this.role, this.nickname);

  factory TripUser.fromMap(Map<String, dynamic> user) {
    return TripUser(user["role"], user["nickname"]);
  }
}

class UserRoles {
  static const Organizer = "organizer";
  static const Leader = "leader";
  static const Participant = "participant";
}