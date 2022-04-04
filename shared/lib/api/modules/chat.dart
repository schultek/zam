import 'package:api_agent/api_agent.dart';
import 'package:dart_mappable/dart_mappable.dart';

@MappableClass()
class ChatNotification {
  final String groupId;
  final String channelId;
  final String id;
  final String title;
  final String message;

  ChatNotification(this.groupId, this.channelId, this.id, this.title, this.message);
}

@ApiDefinition()
abstract class ChatApi {
  Future<void> sendNotification(ChatNotification notification);
}
