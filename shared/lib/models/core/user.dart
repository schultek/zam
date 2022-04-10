import 'package:dart_mappable/dart_mappable.dart';

import '../utils.dart';

@MappableClass()
class UserData {
  final String id;

  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? phoneNumber;
  final bool? emailVerified;
  final bool? disabled;
  final UserMetadata? metadata;
  final List<UserInfo>? providerData;

  final UserClaims claims;

  UserData(this.id, this.displayName, this.email, this.photoUrl, this.phoneNumber, this.emailVerified, this.disabled,
      this.metadata, this.providerData, this.claims);

  UserData.get({
    required this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.phoneNumber,
    this.emailVerified,
    this.disabled,
    this.metadata,
    this.providerData,
    this.claims = const UserClaims(),
  });

  String get name => displayName ?? email?.split('@')[0].replaceAll(RegExp('[.-]'), ' ').capitalize() ?? '';

  UserStatus get status => disabled ?? false
      ? UserStatus.disabled
      : metadata?.lastSignInTime == null
          ? UserStatus.invited
          : UserStatus.active;
}

@MappableEnum()
enum UserStatus { active, disabled, invited }

@MappableClass()
class UserMetadata {
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  UserMetadata(this.creationTime, this.lastSignInTime);
}

@MappableClass()
class UserInfo {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String providerId;
  final String? phoneNumber;

  UserInfo(this.uid, this.displayName, this.email, this.photoUrl, this.providerId, this.phoneNumber);

  UserInfo.get({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    required this.providerId,
    this.phoneNumber,
  });
}

@MappableClass()
class UserClaims {
  final bool isGroupCreator;
  final bool isAdmin;

  const UserClaims({
    this.isGroupCreator = false,
    this.isAdmin = false,
  });

  factory UserClaims.from(Map<String, dynamic>? claims) {
    return UserClaims(
      isGroupCreator: claims?['isGroupCreator'] as bool? ?? false,
      isAdmin: claims?['isAdmin'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'UserClaims{isGroupCreator: $isGroupCreator, isAdmin: $isAdmin}';
  }
}
