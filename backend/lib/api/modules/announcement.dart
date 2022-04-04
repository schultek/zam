import 'dart:async';

import 'package:api_agent/api_agent.dart';
// ignore: implementation_imports
import 'package:firebase_admin/src/messaging.dart';
import 'package:shared/api/app.server.dart';
import 'package:shared/api/modules/announcement.dart';

import '../../middleware/firebase_middleware.dart';

final announcementApi = AnnouncementApi();

class AnnouncementApi extends AnnouncementApiEndpoint {
  @override
  FutureOr<void> sendNotification(AnnouncementNotification announcement, ApiRequest request) async {
    var group = await request.app.firestore().doc('groups/${announcement.groupId}').get();
    var tokens = (group.get('users') as Map).values.map((v) => v['token']).whereType<String>();

    await request.app.messaging().sendAll(
        tokens,
        Message()
          ..notification = (Notification()
            ..title = announcement.title ?? 'New Announcement'
            ..body = announcement.message));
  }
}
