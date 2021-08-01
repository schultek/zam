part of models;

@MappableClass()
class Trip {
  final String name;
  final String id;
  final TemplateModel template;
  final Map<String, TripUser> users;
  final Map<String, List<String>> modules;

  Trip({required this.id, required this.name, required this.template, this.users = const {}, this.modules = const {}});

  TripUser? get currentUser => users[FirebaseAuth.instance.currentUser?.uid];
}

@MappableClass()
class TripUser {
  String role;
  String? nickname;

  TripUser({required this.role, this.nickname});
}

class UserRoles {
  static const Organizer = "organizer";
  static const Leader = "leader";
  static const Participant = "participant";
}
