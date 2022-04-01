import 'package:api_agent/client.dart';

import 'app.api.dart';
import 'mapper_codec.dart';

export 'app.api.dart';

class AppApiClient extends RelayApiClient {
  AppApiClient(ApiClient client) : super('AppApi', client, MapperCodec());

  late final LinksApiClient links = LinksApiClient(this);
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
