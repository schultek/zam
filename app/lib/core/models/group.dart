import 'package:dart_mappable/dart_mappable.dart';

import '../../main.mapper.g.dart';
import '../templates/templates.dart';
import '../themes/themes.dart';

@MappableClass()
class Group with Mappable {
  final String name;
  final String id;
  final String? pictureUrl;
  final String? logoUrl;
  final TemplateModel template;
  final ThemeModel theme;
  final Map<String, GroupUser> users;
  final Map<String, List<String>> modules;
  final List<String> moduleBlacklist;

  Group({
    required this.id,
    required this.name,
    this.pictureUrl,
    this.logoUrl,
    required this.template,
    required this.theme,
    this.users = const {},
    this.modules = const {},
    this.moduleBlacklist = const [],
  });
}

@MappableClass()
class GroupUser with Mappable {
  String role;
  String? nickname;
  String? profileUrl;

  GroupUser({this.role = UserRoles.participant, this.nickname, this.profileUrl});

  bool get isOrganizer => role == UserRoles.organizer;
}

class UserRoles {
  static const organizer = 'organizer';
  static const participant = 'participant';
}
