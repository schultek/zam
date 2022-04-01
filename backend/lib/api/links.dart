import 'dart:async';
import 'dart:convert';

import 'package:api_agent/server.dart';
import 'package:crypto/crypto.dart';
import 'package:shared/api/app.server.dart';

import '../middleware/auth_middleware.dart';
import '../middleware/firebase_middleware.dart';

const secretKey = 'ilovejufa';
final hmac = Hmac(sha256, utf8.encode(secretKey));

const linkBaseUrl = 'https://jufa20.web.app';

final linksApi = LinksApiEndpoint.from(
  createAdminLink: ApplyMiddleware(
    middleware: AuthMiddleware((user) => user.isAdmin),
    child: CreateAdminLink(),
  ),
  createOrganizerLink: ApplyMiddleware(
    middleware: AuthMiddleware((user) => user.isAdmin),
    child: CreateOrganizerLink(),
  ),
  createGroupInvitationLink: CreateGroupInvitationLink(),
  onLinkReceived: OnLinkReceived(),
);

String hashLink(String link, String? query) {
  var hash = hmac.convert(utf8.encode(link)).toString();
  return '$link${query != null ? '?$query&hmac=$hash' : '?hmac=$hash'}';
}

class CreateAdminLink extends CreateAdminLinkEndpoint {
  @override
  FutureOr<String> createAdminLink(String? phoneNumber, ApiRequest request) {
    return hashLink(
      '$linkBaseUrl/invitation/admin',
      phoneNumber != null ? 'phoneNumber=${Uri.encodeQueryComponent(phoneNumber)}' : null,
    );
  }
}

class CreateOrganizerLink extends CreateOrganizerLinkEndpoint {
  @override
  FutureOr<String> createOrganizerLink(String? phoneNumber, ApiRequest request) {
    return hashLink(
      '$linkBaseUrl/invitation/organizer',
      phoneNumber != null ? 'phoneNumber=${Uri.encodeQueryComponent(phoneNumber)}' : null,
    );
  }
}

class CreateGroupInvitationLink extends CreateGroupInvitationLinkEndpoint {
  @override
  FutureOr<String> createGroupInvitationLink(String groupId, String role, ApiRequest request) async {
    var group = await request.app.firestore().doc('groups/$groupId').get();

    // if (!group.exists) {
    //   throw ApiException(400, 'The group with id $groupId does not exist.');
    // }

    var isAdmin = request.user.isAdmin;

    if (!isAdmin && group.get('users.${request.user.uid}.role') != 'organizer') {
      throw ApiException(400, 'You are not authorized to create this invitation link.');
    }

    return hashLink('$linkBaseUrl/invitation/group', 'groupId=$groupId&role=$role');
  }
}

class OnLinkReceived extends OnLinkReceivedEndpoint {
  @override
  FutureOr<bool> onLinkReceived(String link, ApiRequest request) {
    // TODO: implement onLinkReceived
    throw UnimplementedError();
  }
}
