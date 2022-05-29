library announcement_module;

import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:shared/api/modules/announcement.dart';

import '../../helpers/theme.dart';
import '../../providers/general/l10n_provider.dart';
import '../../widgets/needs_setup_card.dart';
import '../module.dart';
import 'pages/announcement_create_page.dart';
import 'widgets/announcement_card.dart';

export '../module.dart';

part 'announcement.models.dart';
part 'announcement.provider.dart';
part 'elements/announcement_content_element.dart';

class AnnouncementModule extends ModuleBuilder {
  AnnouncementModule() : super('announcements');

  @override
  String getName(BuildContext context) => context.tr.announcements;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'announcement': AnnouncementContentElement(),
      };

  @override
  Future<void> handleMessage(ModuleMessage message) async {
    if (message is BackgroundMessage) {
      var notification = decodePayload<AnnouncementNotification>(message.payload);

      if (Platform.isAndroid) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notification.id.hashCode,
            channelKey: 'announcements',
            summary: notification.groupName,
            title: notification.title,
            body: notification.message,
            roundedLargeIcon: true,
            largeIcon: notification.groupPicture,
            color: decodeColor(notification.color),
            notificationLayout: NotificationLayout.BigText,
            category: NotificationCategory.Reminder,
          ),
        );
      } else {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notification.id.hashCode,
            channelKey: 'announcements',
            title: '${notification.groupName} - ${notification.title}',
            body: notification.message,
            roundedLargeIcon: true,
            largeIcon: notification.groupPicture,
            color: decodeColor(notification.color),
            notificationLayout: NotificationLayout.BigText,
            category: NotificationCategory.Reminder,
          ),
        );
      }
    }
  }
}
