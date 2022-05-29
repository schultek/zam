import 'package:api_agent/api_agent.dart';
import 'package:dart_mappable/dart_mappable.dart';

@MappableClass()
class AnnouncementNotification {
  final String groupId;
  final String groupName;
  final String? groupPicture;
  final String id;
  final String title;
  final String message;
  final String? color;

  AnnouncementNotification(
    this.groupId,
    this.groupName,
    this.groupPicture,
    this.id,
    this.title,
    this.message,
    this.color,
  );
}

@ApiDefinition()
abstract class AnnouncementApi {
  Future<void> sendNotification(AnnouncementNotification announcement);
}
