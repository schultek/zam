import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/module/module.dart';
import '../../core/widgets/widget_selector.dart';
import '../../providers/notifications/notifications_provider.dart';
import 'pages/channel_page.dart';
import 'pages/chat_page.dart';

@Module('chat')
class ChatModule with ModulePreloadMixin {
  @ModuleItem('chat')
  PageSegment getChatPage(BuildContext context) {
    return PageSegment(
      builder: (context) {
        if (WidgetSelector.existsIn(context)) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: context.getTextColor(),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.chat, size: MediaQuery.of(context).size.width / 2),
          );
        }
        return const ChatPage();
      },
    );
  }

  static StreamSubscription<RemoteMessage?>? _msgSub;

  @override
  void preload(BuildContext context) {
    var message = context.read(messageProvider);
    if (message?.data['channelId'] != null) {
      Navigator.of(context).push(ChannelPage.route(message!.data['channelId'] as String));
    }
    _msgSub?.cancel();
    _msgSub = context.read(messageProvider.state).stream.listen((m) {
      if (m?.data['channelId'] != null) {
        Navigator.of(context).push(ChannelPage.route(m!.data['channelId'] as String));
      }
    });
    print('Subscribed to messages');
  }
}
