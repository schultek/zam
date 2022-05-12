import 'dart:async';
import 'dart:convert';

import 'package:api_agent/server.dart';
import 'package:crypto/crypto.dart';
import 'package:shared/api/app.server.dart';

import '../../middleware/auth_middleware.dart';
import '../../middleware/firebase_middleware.dart';

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

    if (!group.exists) {
      throw ApiException(400, 'The group with id $groupId does not exist.');
    }

    var isAdmin = request.user.isAdmin;

    if (!isAdmin && group.get('users.${request.user.uid}.role') != 'organizer') {
      throw ApiException(400, 'You are not authorized to create this invitation link.');
    }

    return hashLink('$linkBaseUrl/invitation/group', 'groupId=$groupId&role=$role');
  }
}

class OnLinkReceived extends OnLinkReceivedEndpoint {
  @override
  FutureOr<bool> onLinkReceived(String link, ApiRequest request) async {
    var uri = Uri.parse(link);

    var sentHmac = uri.queryParameters['hmac'];
    var sourceLink = uri.replace(queryParameters: {...uri.queryParameters}..remove('hmac')).toString();
    if (sourceLink.endsWith('?')) {
      sourceLink = sourceLink.substring(0, sourceLink.length - 1);
    }

    var calculatedHmac = hmac.convert(utf8.encode(sourceLink)).toString();

    if (sentHmac != calculatedHmac) {
      throw ApiException(400, 'Invalid link hash');
    }

    if (uri.path == '/invitation/organizer' || uri.path == '/invitation/admin') {
      var user = await request.app.auth().getUser(request.user.uid);

      var sentPhoneNumber = Uri.decodeQueryComponent(uri.queryParameters['phoneNumber'] ?? '');

      if (sentPhoneNumber.isNotEmpty && sentPhoneNumber != request.user.phoneNumber) {
        throw ApiException(
            400,
            'Users phone number (${user.phoneNumber}) does not match required number '
            'from invitation ($sentPhoneNumber)');
      }

      if (uri.path.endsWith('organizer')) {
        await request.app.auth().setCustomUserClaims(
          request.user.uid,
          {...user.customClaims ?? {}, 'isGroupCreator': true},
        );
      } else if (uri.path.endsWith('admin')) {
        await request.app.auth().setCustomUserClaims(
          request.user.uid,
          {...user.customClaims ?? {}, 'isAdmin': true},
        );
      }

      return true;
    } else if (uri.path == '/invitation/group') {
      var groupId = uri.queryParameters['groupId'];
      var role = uri.queryParameters['role'];

      var groupRef = request.app.firestore().doc('groups/$groupId');
      var group = await groupRef.get();

      if (!group.exists) {
        throw ApiException(400, 'The group with id $groupId does not exist.');
      }

      print('Adding user ${request.user.uid} to group $groupId with role $role.');
      await groupRef.update({'users.${request.user.uid}.role': role ?? 'participant'});
    }

    return false;
  }
}
