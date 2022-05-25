import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../groups/logic_provider.dart';

final messageProvider = StateProvider<RemoteMessage?>((ref) => null);

final notificationsProvider = Provider((ref) => NotificationLogic(ref));

class NotificationLogic {
  final _firebaseMessaging = FirebaseMessaging.instance;

  bool _isSetup = false;

  final Ref ref;
  NotificationLogic(this.ref);

  Future<void> setup() async {
    if (_isSetup) return;

    var settings = await _firebaseMessaging.requestPermission();

    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
          )
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group',
          )
        ],
        debug: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _isSetup = true;
    }

    var isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    AwesomeNotifications().actionStream.listen(onActionReceived);

    if (!_firebaseMessaging.isAutoInitEnabled) {
      await _firebaseMessaging.setAutoInitEnabled(true);
    }

    var token = await _firebaseMessaging.getToken();
    await ref.read(groupsLogicProvider).setPushToken(token);

    FirebaseMessaging.onMessage.listen((message) async {
      print('Got foreground notification: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message opened App: ${message.data}');
      ref.read(messageProvider.state).state = message;
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }
}

Future<void> onBackgroundMessage(message) async {
  print('Background message: ${message.data}');
}

Future<void> onActionReceived(ReceivedAction receivedAction) async {
  print('Action received $receivedAction');
}
