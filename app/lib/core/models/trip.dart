import 'package:dart_mappable/dart_mappable.dart';

import '../../main.mapper.g.dart';
import '../templates/template_model.dart';
import '../themes/theme_model.dart';

@MappableClass()
class Trip with Mappable {
  final String name;
  final String id;
  final String? pictureUrl;
  final TemplateModel template;
  final ThemeModel theme;
  final Map<String, TripUser> users;
  final Map<String, List<String>> modules;

  Trip(
      {required this.id,
      required this.name,
      this.pictureUrl,
      required this.template,
      this.theme = const ThemeModel(),
      this.users = const {},
      this.modules = const {}});
}

@MappableClass()
class TripUser with Mappable {
  String role;
  String? nickname;
  String? profileUrl;

  TripUser({this.role = UserRoles.participant, this.nickname, this.profileUrl});

  bool get isOrganizer => role == UserRoles.organizer;
}

class UserRoles {
  static const organizer = 'organizer';
  static const leader = 'leader';
  static const participant = 'participant';
}
