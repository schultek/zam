import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_provider.dart';

final notificationsProvider = Provider((ref) => NotificationLogic(ref));

class NotificationLogic {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final ProviderReference ref;
  NotificationLogic(this.ref) {
    setup();
  }

  Future<void> setup() async {
    await ref.read(firebaseProvider.future);

    await _firebaseMessaging.requestPermission();

    if (!_firebaseMessaging.isAutoInitEnabled) {
      await _firebaseMessaging.setAutoInitEnabled(true);
    }

    FirebaseMessaging.onMessage.listen((message) async {
      print("Got foreground notification: ${message.data}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message opened App: ${message.data}");
    });
  }

  void subscribe(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }
}
