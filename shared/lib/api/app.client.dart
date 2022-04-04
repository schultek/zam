import 'package:api_agent/client.dart';

import 'app.api.dart';
import 'mapper_codec.dart';
import 'modules/announcement.dart';
import 'modules/chat.dart';

export 'app.api.dart';

class AppApiClient extends RelayApiClient {
  AppApiClient(ApiClient client) : super('AppApi', client, MapperCodec());

  late final LinksApiClient links = LinksApiClient(this);

  late final AnnouncementApiClient announcement = AnnouncementApiClient(this);

  late final ChatApiClient chat = ChatApiClient(this);
}

class LinksApiClient extends RelayApiClient {
  LinksApiClient(ApiClient client) : super('LinksApi', client);

  Future<String> createOrganizerLink({String? phoneNumber}) =>
      request('createOrganizerLink', {'phoneNumber': phoneNumber}, null);

  Future<String> createAdminLink({String? phoneNumber}) =>
      request('createAdminLink', {'phoneNumber': phoneNumber}, null);

  Future<String> createGroupInvitationLink(String groupId, String role) =>
      request('createGroupInvitationLink', {'groupId': groupId, 'role': role},
          null);

  Future<bool> onLinkReceived(String link) =>
      request('onLinkReceived', {'link': link}, null);
}

class AnnouncementApiClient extends RelayApiClient {
  AnnouncementApiClient(ApiClient client) : super('AnnouncementApi', client);

  Future<void> sendNotification(AnnouncementNotification announcement) =>
      request('sendNotification', {'announcement': announcement}, null);
}

class ChatApiClient extends RelayApiClient {
  ChatApiClient(ApiClient client) : super('ChatApi', client);

  Future<void> sendNotification(ChatNotification notification) =>
      request('sendNotification', {'notification': notification}, null);
}
