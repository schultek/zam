import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/AuthService.dart';

class Trip {
  String name;
  String id;
  Map<String, TripUser> users;
  List<String> modules;

  Trip(this.id, this.name, this.users, this.modules);

  factory Trip.fromDocument(DocumentSnapshot document) {

    Map<String, dynamic> firebaseUsers = document.get("users");
    Map<String, TripUser> users = {};
    for(MapEntry<String, dynamic> user in firebaseUsers.entries) {
      users[user.key] = TripUser.fromMap(user.value);
    }

    List<dynamic> firebaseModules = document.data()["modules"] ?? [];
    List<String> modules = firebaseModules.map<String>((m) => m).toList();

    return Trip(document.id, document.get("name"), users, modules);
  }

  currentUser() {
    print(this.users);
    print(this.name);
    print(AuthService.getUser());
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