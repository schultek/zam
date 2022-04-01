import 'dart:async';

import 'package:api_agent/server.dart';

import 'app.api.dart';
import 'mapper_codec.dart';

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
  }) =>
      _AppApiEndpoint(links);

  LinksApiEndpoint get links;
  @override
  List<ApiEndpoint> get endpoints => [
        links,
      ];
}

class _AppApiEndpoint with _AppApiEndpointMixin {
  _AppApiEndpoint(this.linksEndpoint);
  final ApiEndpoint<LinksApiEndpoint> linksEndpoint;
  @override
  List<ApiEndpoint> get endpoints => [linksEndpoint];
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
