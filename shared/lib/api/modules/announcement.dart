import 'package:api_agent/api_agent.dart';
import 'package:dart_mappable/dart_mappable.dart';

@MappableClass()
class AnnouncementNotification {
  final String groupId;
  final String id;
  final String? title;
  final String message;

  AnnouncementNotification(this.groupId, this.id, this.title, this.message);
}

@ApiDefinition()
abstract class AnnouncementApi {
  Future<void> sendNotification(AnnouncementNotification announcement);
}
