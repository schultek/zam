import 'dart:async';

import 'package:api_agent/server.dart';

import 'app.api.dart';
import 'mapper_codec.dart';
import 'modules/announcement.dart';
import 'modules/chat.dart';

export 'app.api.dart';

mixin _AppApiEndpointMixin implements ApiEndpoint<AppApiEndpoint> {
  List<ApiEndpoint> get endpoints;

  @override
  void build(ApiBuilder builder) {
    builder.mount('AppApi', endpoints.withCodec(MapperCodec()));
  }
}

abstract class AppApiEndpoint with _AppApiEndpointMixin {
  static ApiEndpoint<AppApiEndpoint> from({
    required ApiEndpoint<LinksApiEndpoint> links,
    required ApiEndpoint<AnnouncementApiEndpoint> announcement,
    required ApiEndpoint<ChatApiEndpoint> chat,
  }) =>
      _AppApiEndpoint(links, announcement, chat);

  LinksApiEndpoint get links;

  AnnouncementApiEndpoint get announcement;

  ChatApiEndpoint get chat;
  @override
  List<ApiEndpoint> get endpoints => [
        links,
        announcement,
        chat,
      ];
}

class _AppApiEndpoint with _AppApiEndpointMixin {
  _AppApiEndpoint(
      this.linksEndpoint, this.announcementEndpoint, this.chatEndpoint);
  final ApiEndpoint<LinksApiEndpoint> linksEndpoint;
  final ApiEndpoint<AnnouncementApiEndpoint> announcementEndpoint;
  final ApiEndpoint<ChatApiEndpoint> chatEndpoint;
  @override
  List<ApiEndpoint> get endpoints =>
      [linksEndpoint, announcementEndpoint, chatEndpoint];
}

mixin _LinksApiEndpointMixin implements ApiEndpoint<LinksApiEndpoint> {
  List<ApiEndpoint> get endpoints;

  @override
  void build(ApiBuilder builder) {
    builder.mount('LinksApi', endpoints);
  }
}

abstract class LinksApiEndpoint with _LinksApiEndpointMixin {
  static ApiEndpoint<LinksApiEndpoint> from({
    required ApiEndpoint<CreateOrganizerLinkEndpoint> createOrganizerLink,
    required ApiEndpoint<CreateAdminLinkEndpoint> createAdminLink,
    required ApiEndpoint<CreateGroupInvitationLinkEndpoint>
        createGroupInvitationLink,
    required ApiEndpoint<OnLinkReceivedEndpoint> onLinkReceived,
  }) =>
      _LinksApiEndpoint(createOrganizerLink, createAdminLink,
          createGroupInvitationLink, onLinkReceived);

  FutureOr<String> createOrganizerLink(
      String? phoneNumber, covariant ApiRequest request);

  FutureOr<String> createAdminLink(
      String? phoneNumber, covariant ApiRequest request);

  FutureOr<String> createGroupInvitationLink(
      String groupId, String role, covariant ApiRequest request);

  FutureOr<bool> onLinkReceived(String link, covariant ApiRequest request);
  @override
  List<ApiEndpoint> get endpoints => [
        CreateOrganizerLinkEndpoint.from(createOrganizerLink),
        CreateAdminLinkEndpoint.from(createAdminLink),
        CreateGroupInvitationLinkEndpoint.from(createGroupInvitationLink),
        OnLinkReceivedEndpoint.from(onLinkReceived),
      ];
}

class _LinksApiEndpoint with _LinksApiEndpointMixin {
  _LinksApiEndpoint(
      this.createOrganizerLinkEndpoint,
      this.createAdminLinkEndpoint,
      this.createGroupInvitationLinkEndpoint,
      this.onLinkReceivedEndpoint);
  final ApiEndpoint<CreateOrganizerLinkEndpoint> createOrganizerLinkEndpoint;
  final ApiEndpoint<CreateAdminLinkEndpoint> createAdminLinkEndpoint;
  final ApiEndpoint<CreateGroupInvitationLinkEndpoint>
      createGroupInvitationLinkEndpoint;
  final ApiEndpoint<OnLinkReceivedEndpoint> onLinkReceivedEndpoint;
  @override
  List<ApiEndpoint> get endpoints => [
        createOrganizerLinkEndpoint,
        createAdminLinkEndpoint,
        createGroupInvitationLinkEndpoint,
        onLinkReceivedEndpoint
      ];
}

abstract class CreateOrganizerLinkEndpoint
    implements ApiEndpoint<CreateOrganizerLinkEndpoint> {
  CreateOrganizerLinkEndpoint();
  factory CreateOrganizerLinkEndpoint.from(
      FutureOr<String> Function(String? phoneNumber, ApiRequest request)
          handler) = _CreateOrganizerLinkEndpoint;
  FutureOr<String> createOrganizerLink(
      String? phoneNumber, covariant ApiRequest request);
  @override
  void build(ApiBuilder builder) {
    builder.handle('createOrganizerLink',
        (r) => createOrganizerLink(r.getOpt('phoneNumber'), r));
  }
}

class _CreateOrganizerLinkEndpoint extends CreateOrganizerLinkEndpoint {
  _CreateOrganizerLinkEndpoint(this.handler);

  final FutureOr<String> Function(String? phoneNumber, ApiRequest request)
      handler;

  @override
  FutureOr<String> createOrganizerLink(
      String? phoneNumber, covariant ApiRequest request) {
    return handler(phoneNumber, request);
  }
}

abstract class CreateAdminLinkEndpoint
    implements ApiEndpoint<CreateAdminLinkEndpoint> {
  CreateAdminLinkEndpoint();
  factory CreateAdminLinkEndpoint.from(
      FutureOr<String> Function(String? phoneNumber, ApiRequest request)
          handler) = _CreateAdminLinkEndpoint;
  FutureOr<String> createAdminLink(
      String? phoneNumber, covariant ApiRequest request);
  @override
  void build(ApiBuilder builder) {
    builder.handle(
        'createAdminLink', (r) => createAdminLink(r.getOpt('phoneNumber'), r));
  }
}

class _CreateAdminLinkEndpoint extends CreateAdminLinkEndpoint {
  _CreateAdminLinkEndpoint(this.handler);

  final FutureOr<String> Function(String? phoneNumber, ApiRequest request)
      handler;

  @override
  FutureOr<String> createAdminLink(
      String? phoneNumber, covariant ApiRequest request) {
    return handler(phoneNumber, request);
  }
}

abstract class CreateGroupInvitationLinkEndpoint
    implements ApiEndpoint<CreateGroupInvitationLinkEndpoint> {
  CreateGroupInvitationLinkEndpoint();
  factory CreateGroupInvitationLinkEndpoint.from(
      FutureOr<String> Function(String groupId, String role, ApiRequest request)
          handler) = _CreateGroupInvitationLinkEndpoint;
  FutureOr<String> createGroupInvitationLink(
      String groupId, String role, covariant ApiRequest request);
  @override
  void build(ApiBuilder builder) {
    builder.handle('createGroupInvitationLink',
        (r) => createGroupInvitationLink(r.get('groupId'), r.get('role'), r));
  }
}

class _CreateGroupInvitationLinkEndpoint
    extends CreateGroupInvitationLinkEndpoint {
  _CreateGroupInvitationLinkEndpoint(this.handler);

  final FutureOr<String> Function(
      String groupId, String role, ApiRequest request) handler;

  @override
  FutureOr<String> createGroupInvitationLink(
      String groupId, String role, covariant ApiRequest request) {
    return handler(groupId, role, request);
  }
}

abstract class OnLinkReceivedEndpoint
    implements ApiEndpoint<OnLinkReceivedEndpoint> {
  OnLinkReceivedEndpoint();
  factory OnLinkReceivedEndpoint.from(
          FutureOr<bool> Function(String link, ApiRequest request) handler) =
      _OnLinkReceivedEndpoint;
  FutureOr<bool> onLinkReceived(String link, covariant ApiRequest request);
  @override
  void build(ApiBuilder builder) {
    builder.handle('onLinkReceived', (r) => onLinkReceived(r.get('link'), r));
  }
}

class _OnLinkReceivedEndpoint extends OnLinkReceivedEndpoint {
  _OnLinkReceivedEndpoint(this.handler);

  final FutureOr<bool> Function(String link, ApiRequest request) handler;

  @override
  FutureOr<bool> onLinkReceived(String link, covariant ApiRequest request) {
    return handler(link, request);
  }
}

mixin _AnnouncementApiEndpointMixin
    implements ApiEndpoint<AnnouncementApiEndpoint> {
  List<ApiEndpoint> get endpoints;

  @override
  void build(ApiBuilder builder) {
    builder.mount('AnnouncementApi', endpoints);
  }
}

abstract class AnnouncementApiEndpoint with _AnnouncementApiEndpointMixin {
  static ApiEndpoint<AnnouncementApiEndpoint> from({
    required ApiEndpoint<SendNotificationEndpoint> sendNotification,
  }) =>
      _AnnouncementApiEndpoint(sendNotification);

  FutureOr<void> sendNotification(
      AnnouncementNotification announcement, covariant ApiRequest request);
  @override
  List<ApiEndpoint> get endpoints => [
        SendNotificationEndpoint.from(sendNotification),
      ];
}

class _AnnouncementApiEndpoint with _AnnouncementApiEndpointMixin {
  _AnnouncementApiEndpoint(this.sendNotificationEndpoint);
  final ApiEndpoint<SendNotificationEndpoint> sendNotificationEndpoint;
  @override
  List<ApiEndpoint> get endpoints => [sendNotificationEndpoint];
}

abstract class SendNotificationEndpoint
    implements ApiEndpoint<SendNotificationEndpoint> {
  SendNotificationEndpoint();
  factory SendNotificationEndpoint.from(
      FutureOr<void> Function(
              AnnouncementNotification announcement, ApiRequest request)
          handler) = _SendNotificationEndpoint;
  FutureOr<void> sendNotification(
      AnnouncementNotification announcement, covariant ApiRequest request);
  @override
  void build(ApiBuilder builder) {
    builder.handle(
        'sendNotification', (r) => sendNotification(r.get('announcement'), r));
  }
}

class _SendNotificationEndpoint extends SendNotificationEndpoint {
  _SendNotificationEndpoint(this.handler);

  final FutureOr<void> Function(
      AnnouncementNotification announcement, ApiRequest request) handler;

  @override
  FutureOr<void> sendNotification(
      AnnouncementNotification announcement, covariant ApiRequest request) {
    return handler(announcement, request);
  }
}

mixin _ChatApiEndpointMixin implements ApiEndpoint<ChatApiEndpoint> {
  List<ApiEndpoint> get endpoints;

  @override
  void build(ApiBuilder builder) {
    builder.mount('ChatApi', endpoints);
  }
}

abstract class ChatApiEndpoint with _ChatApiEndpointMixin {
  static ApiEndpoint<ChatApiEndpoint> from({
    required ApiEndpoint<ChatApiSendNotificationEndpoint> sendNotification,
  }) =>
      _ChatApiEndpoint(sendNotification);

  FutureOr<void> sendNotification(
      ChatNotification notification, covariant ApiRequest request);
  @override
  List<ApiEndpoint> get endpoints => [
        ChatApiSendNotificationEndpoint.from(sendNotification),
      ];
}

class _ChatApiEndpoint with _ChatApiEndpointMixin {
  _ChatApiEndpoint(this.sendNotificationEndpoint);
  final ApiEndpoint<ChatApiSendNotificationEndpoint> sendNotificationEndpoint;
  @override
  List<ApiEndpoint> get endpoints => [sendNotificationEndpoint];
}

abstract class ChatApiSendNotificationEndpoint
    implements ApiEndpoint<ChatApiSendNotificationEndpoint> {
  ChatApiSendNotificationEndpoint();
  factory ChatApiSendNotificationEndpoint.from(
      FutureOr<void> Function(ChatNotification notification, ApiRequest request)
          handler) = _ChatApiSendNotificationEndpoint;
  FutureOr<void> sendNotification(
      ChatNotification notification, covariant ApiRequest request);
  @override
  void build(ApiBuilder builder) {
    builder.handle(
        'sendNotification', (r) => sendNotification(r.get('notification'), r));
  }
}

class _ChatApiSendNotificationEndpoint extends ChatApiSendNotificationEndpoint {
  _ChatApiSendNotificationEndpoint(this.handler);

  final FutureOr<void> Function(
      ChatNotification notification, ApiRequest request) handler;

  @override
  FutureOr<void> sendNotification(
      ChatNotification notification, covariant ApiRequest request) {
    return handler(notification, request);
  }
}
