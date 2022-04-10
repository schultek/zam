import 'package:api_agent/api_agent.dart';

@ApiDefinition()
abstract class LinksApi {
  Future<String> createOrganizerLink({String? phoneNumber});
  Future<String> createAdminLink({String? phoneNumber});
  Future<String> createGroupInvitationLink(String groupId, String role);

  Future<bool> onLinkReceived(String link);
}
