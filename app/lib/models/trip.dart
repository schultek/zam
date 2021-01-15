part of models;

class Trip {
  String name;
  String id;
  Map<String, TripUser> users;
  List<String> modules;

  Trip(this.id, this.name, this.users, this.modules);

  Trip.fromMap(Map<String, dynamic> map)
      : id = map.get("id"),
        name = map.get("name"),
        users = map.getMap("users", map: (Map<String, dynamic> map) => TripUser.fromMap(map)),
        modules = map.getList("modules");

  TripUser? get currentUser => users[AuthService.getUser().uid];
}

class TripUser {
  String role;
  String nickname;

  TripUser(this.role, this.nickname);

  TripUser.fromMap(Map<String, dynamic> user)
      : role = user.get("role"),
        nickname = user.get("nickname");
}

class UserRoles {
  static const Organizer = "organizer";
  static const Leader = "leader";
  static const Participant = "participant";
}
