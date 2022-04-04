import 'package:firebase_messaging/firebase_messaging.dart';
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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _isSetup = true;
    }

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
  }
}
