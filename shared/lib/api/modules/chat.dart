import 'package:api_agent/api_agent.dart';
import 'package:dart_mappable/dart_mappable.dart';

@MappableClass()
class ChatNotification {
  final String id;
  final String groupId;
  final String groupName;
  final String color;

  final String channelId;
  final String channelName;

  final String userId;
  final String userName;
  final String? pictureUrl;

  final String text;

  ChatNotification(
    this.id,
    this.groupId,
    this.groupName,
    this.color,
    this.channelId,
    this.channelName,
    this.userId,
    this.userName,
    this.pictureUrl,
    this.text,
  );
}

@ApiDefinition()
abstract class ChatApi {
  Future<void> sendNotification(ChatNotification notification);
}
