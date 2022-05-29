import 'dart:async';
import 'dart:convert';

import 'package:api_agent/api_agent.dart';
// ignore: implementation_imports
import 'package:firebase_admin/src/messaging.dart';
import 'package:shared/api/app.server.dart';
import 'package:shared/api/modules/chat.dart';
import 'package:shared/models/models.mapper.g.dart';

import '../../middleware/auth_middleware.dart';
import '../../middleware/firebase_middleware.dart';

final chatApi = ChatApi();

class ChatApi extends ChatApiEndpoint {
  @override
  FutureOr<void> sendNotification(ChatNotification notification, ApiRequest request) async {
    if (notification.userId != request.user.uid) {
      throw 'Notification userId must match the requesting user.';
    }

    var group = await request.app.firestore().doc('groups/${notification.groupId}').get();
    var users = group.get('users') as Map;

    var channel = await request.app
        .firestore()
        .doc('groups/${notification.groupId}/modules/chat/channels/${notification.channelId}')
        .get();
    var tokens = (channel.get('members') as List)
        .where((id) => id != notification.userId)
        .map((id) => users[id]?['token'])
        .whereType<String>();

    await request.app.messaging().sendAll(
        tokens,
        Message()
          ..data = {
            'moduleId': 'chat',
            'payload': base64Encode(utf8.encode(Mapper.toJson(notification))),
          });
  }
}
