library chat_module;

import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:shared/api/modules/chat.dart';

import '../../helpers/theme.dart';
import '../../providers/general/l10n_provider.dart';
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

  NavigatorState? _navigator;
  ChatNotification? _openedNotification;

  @override
  Iterable<Route> generateInitialRoutes(BuildContext context) sync* {
    if (_openedNotification != null) {
      yield ChannelPage.route(_openedNotification!.channelId);
      _openedNotification = null;
    }
  }

  @override
  void preload(BuildContext context) {
    if (_openedNotification != null) {
      Navigator.of(context).push(ChannelPage.route(_openedNotification!.channelId));
      _openedNotification = null;
    } else {
      _navigator = Navigator.of(context);
    }
  }

  @override
  void dispose() {
    _navigator = null;
    super.dispose();
  }

  @override
  Future<void> handleMessage(ModuleMessage message) async {
    if (message is NotificationMessage) {
      var ref = message.container;

      if (message.key == '') {
        var notification = decodePayload<ChatNotification>(message.payload['payload'] as String);

        if (_navigator != null && _navigator!.mounted) {
          if (_navigator!.context.read(selectedGroupIdProvider) != notification.groupId) {
            _navigator!.context.read(selectedGroupIdProvider.notifier).state = notification.groupId;
            _openedNotification = notification;
          } else {
            _navigator!.push(ChannelPage.route(notification.channelId));
          }
        } else {
          _openedNotification = notification;
        }
      }

      if (message.key == 'reply') {
        var notification = decodePayload<ChatNotification>(message.payload['payload'] as String);

        var user = await ref.read(userProvider.future);
        if (user == null) return;

        var group = await ref.read(groupByIdProvider(notification.groupId).future);
        if (group == null) return;

        var groupUser = group.users[user.uid];
        if (groupUser == null) return;

        var msgDoc = await ref
            .read(firestoreCollectionProvider(
                'groups/${group.id}/modules/chat/channels/${notification.channelId}/messages'))
            .add(ChatTextMessage(sender: user.uid, text: message.input, sentAt: DateTime.now()).toMap());

        notification = notification.copyWith(
          id: msgDoc.id,
          userId: user.uid,
          userName: groupUser.nickname ?? ref.read(l10nProvider).anonymous,
          pictureUrl: groupUser.profileUrl,
          text: message.input,
        );

        await ref.read(notificationLogicProvider).sendNotification(notification, showNotification: true);
      }
    } else if (message is BackgroundMessage) {
      var notification = decodePayload<ChatNotification>(message.payload);
      await message.container.read(notificationLogicProvider).createNotification(notification);
    }
  }
}
