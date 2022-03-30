library chat_module;

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../module.dart';
import 'pages/channel_page.dart';
import 'pages/chat_page.dart';
import 'widgets/channel_list.dart';

export '../module.dart';

part 'chat.models.dart';
part 'chat.provider.dart';
part 'elements/channels_page_element.dart';
part 'elements/chat_action_element.dart';

class ChatModule extends ModuleBuilder {
  ChatModule() : super('chat');

  @override
  String getName(BuildContext context) => context.tr.chat;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'channels': ChannelsPageElement(),
        'action': ChatActionElement(),
      };

  static StreamSubscription<RemoteMessage?>? _msgSub;

  @override
  Iterable<Route> generateInitialRoutes(BuildContext context) sync* {
    var message = context.read(messageProvider);
    if (message?.data['channelId'] != null) {
      yield ChannelPage.route(message!.data['channelId'] as String);
    }
  }

  @override
  void preload(BuildContext context) {
    _msgSub?.cancel();
    _msgSub = context.read(messageProvider.state).stream.listen((m) {
      if (m?.data['channelId'] != null) {
        Navigator.of(context).push(ChannelPage.route(m!.data['channelId'] as String));
      }
    });
  }

  @override
  void dispose() {
    _msgSub?.cancel();
    super.dispose();
  }
}
