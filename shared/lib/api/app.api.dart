import 'package:api_agent/api_agent.dart';

import 'mapper_codec.dart';
import 'modules/announcement.dart';
import 'modules/chat.dart';

@ApiDefinition(codec: MapperCodec())
abstract class AppApi {
  LinksApi get links;

  AnnouncementApi get announcement;

  ChatApi get chat;
}

@ApiDefinition()
abstract class LinksApi {
  Future<String> createOrganizerLink({String? phoneNumber});
  Future<String> createAdminLink({String? phoneNumber});
  Future<String> createGroupInvitationLink(String groupId, String role);

  Future<bool> onLinkReceived(String link);
}
