part of models;

@MappableClass()
class Trip with Mappable {
  final String name;
  final String id;
  final TemplateModel template;
  final Map<String, TripUser> users;
  final Map<String, List<String>> modules;

  Trip({required this.id, required this.name, required this.template, this.users = const {}, this.modules = const {}});
}

@MappableClass()
class TripUser with Mappable {
  String role;
  String? nickname;
  String? profileUrl;

  TripUser({required this.role, this.nickname, this.profileUrl});

  bool get isOrganizer => role == UserRoles.Organizer;
}

class UserRoles {
  static const Organizer = "organizer";
  static const Leader = "leader";
  static const Participant = "participant";
}
