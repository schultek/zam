part of models;

@jsonSerializable
class Trip {
  String name;
  String id;
  Map<String, TripUser> users;
  Map<String, List<String>> modules;

  Trip(this.id, this.name, this.users, this.modules);

  TripUser? get currentUser => users[FirebaseAuth.instance.currentUser?.uid];
}

@jsonSerializable
class TripUser {
  String role;
  String? nickname;

  TripUser(this.role, this.nickname);
}

class UserRoles {
  static const Organizer = "organizer";
  static const Leader = "leader";
  static const Participant = "participant";
}
