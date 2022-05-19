import 'package:dart_mappable/dart_mappable.dart';
import 'package:dart_mappable/internals.dart';

import '../api/modules/announcement.dart';
import '../api/modules/chat.dart';
import 'core/user.dart';


// === ALL STATICALLY REGISTERED MAPPERS ===

var _mappers = <BaseMapper>{
  // class mappers
  UserDataMapper._(),
  UserMetadataMapper._(),
  UserInfoMapper._(),
  UserClaimsMapper._(),
  AnnouncementNotificationMapper._(),
  ChatNotificationMapper._(),
  // enum mappers
  UserStatusMapper._(),
  // custom mappers
};


// === GENERATED CLASS MAPPERS AND EXTENSIONS ===

class UserDataMapper extends BaseMapper<UserData> {
  UserDataMapper._();

  @override Function get decoder => decode;
  UserData decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  UserData fromMap(Map<String, dynamic> map) => UserData(Mapper.i.$get(map, 'id'), Mapper.i.$getOpt(map, 'displayName'), Mapper.i.$getOpt(map, 'email'), Mapper.i.$getOpt(map, 'photoUrl'), Mapper.i.$getOpt(map, 'phoneNumber'), Mapper.i.$getOpt(map, 'emailVerified'), Mapper.i.$getOpt(map, 'disabled'), Mapper.i.$getOpt(map, 'metadata'), Mapper.i.$getOpt(map, 'providerData'), Mapper.i.$get(map, 'claims'));

  @override Function get encoder => (UserData v) => encode(v);
  dynamic encode(UserData v) => toMap(v);
  Map<String, dynamic> toMap(UserData u) => {'id': Mapper.i.$enc(u.id, 'id'), 'displayName': Mapper.i.$enc(u.displayName, 'displayName'), 'email': Mapper.i.$enc(u.email, 'email'), 'photoUrl': Mapper.i.$enc(u.photoUrl, 'photoUrl'), 'phoneNumber': Mapper.i.$enc(u.phoneNumber, 'phoneNumber'), 'emailVerified': Mapper.i.$enc(u.emailVerified, 'emailVerified'), 'disabled': Mapper.i.$enc(u.disabled, 'disabled'), 'metadata': Mapper.i.$enc(u.metadata, 'metadata'), 'providerData': Mapper.i.$enc(u.providerData, 'providerData'), 'claims': Mapper.i.$enc(u.claims, 'claims')};

  @override String stringify(UserData self) => 'UserData(id: ${Mapper.asString(self.id)}, displayName: ${Mapper.asString(self.displayName)}, email: ${Mapper.asString(self.email)}, photoUrl: ${Mapper.asString(self.photoUrl)}, phoneNumber: ${Mapper.asString(self.phoneNumber)}, emailVerified: ${Mapper.asString(self.emailVerified)}, disabled: ${Mapper.asString(self.disabled)}, metadata: ${Mapper.asString(self.metadata)}, providerData: ${Mapper.asString(self.providerData)}, claims: ${Mapper.asString(self.claims)})';
  @override int hash(UserData self) => Mapper.hash(self.id) ^ Mapper.hash(self.displayName) ^ Mapper.hash(self.email) ^ Mapper.hash(self.photoUrl) ^ Mapper.hash(self.phoneNumber) ^ Mapper.hash(self.emailVerified) ^ Mapper.hash(self.disabled) ^ Mapper.hash(self.metadata) ^ Mapper.hash(self.providerData) ^ Mapper.hash(self.claims);
  @override bool equals(UserData self, UserData other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.displayName, other.displayName) && Mapper.isEqual(self.email, other.email) && Mapper.isEqual(self.photoUrl, other.photoUrl) && Mapper.isEqual(self.phoneNumber, other.phoneNumber) && Mapper.isEqual(self.emailVerified, other.emailVerified) && Mapper.isEqual(self.disabled, other.disabled) && Mapper.isEqual(self.metadata, other.metadata) && Mapper.isEqual(self.providerData, other.providerData) && Mapper.isEqual(self.claims, other.claims);

  @override Function get typeFactory => (f) => f<UserData>();
}

extension UserDataMapperExtension  on UserData {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  UserDataCopyWith<UserData> get copyWith => UserDataCopyWith(this, $identity);
}

abstract class UserDataCopyWith<$R> {
  factory UserDataCopyWith(UserData value, Then<UserData, $R> then) = _UserDataCopyWithImpl<$R>;
  UserMetadataCopyWith<$R>? get metadata;
  ListCopyWith<$R, UserInfo, UserInfoCopyWith<$R>>? get providerData;
  UserClaimsCopyWith<$R> get claims;
  $R call({String? id, String? displayName, String? email, String? photoUrl, String? phoneNumber, bool? emailVerified, bool? disabled, UserMetadata? metadata, List<UserInfo>? providerData, UserClaims? claims});
  $R apply(UserData Function(UserData) transform);
}

class _UserDataCopyWithImpl<$R> extends BaseCopyWith<UserData, $R> implements UserDataCopyWith<$R> {
  _UserDataCopyWithImpl(UserData value, Then<UserData, $R> then) : super(value, then);

  @override UserMetadataCopyWith<$R>? get metadata => $value.metadata != null ? UserMetadataCopyWith($value.metadata!, (v) => call(metadata: v)) : null;
  @override ListCopyWith<$R, UserInfo, UserInfoCopyWith<$R>>? get providerData => $value.providerData != null ? ListCopyWith($value.providerData!, (v, t) => UserInfoCopyWith(v, t), (v) => call(providerData: v)) : null;
  @override UserClaimsCopyWith<$R> get claims => UserClaimsCopyWith($value.claims, (v) => call(claims: v));
  @override $R call({String? id, Object? displayName = $none, Object? email = $none, Object? photoUrl = $none, Object? phoneNumber = $none, Object? emailVerified = $none, Object? disabled = $none, Object? metadata = $none, Object? providerData = $none, UserClaims? claims}) => $then(UserData(id ?? $value.id, or(displayName, $value.displayName), or(email, $value.email), or(photoUrl, $value.photoUrl), or(phoneNumber, $value.phoneNumber), or(emailVerified, $value.emailVerified), or(disabled, $value.disabled), or(metadata, $value.metadata), or(providerData, $value.providerData), claims ?? $value.claims));
}

class UserMetadataMapper extends BaseMapper<UserMetadata> {
  UserMetadataMapper._();

  @override Function get decoder => decode;
  UserMetadata decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  UserMetadata fromMap(Map<String, dynamic> map) => UserMetadata(Mapper.i.$getOpt(map, 'creationTime'), Mapper.i.$getOpt(map, 'lastSignInTime'));

  @override Function get encoder => (UserMetadata v) => encode(v);
  dynamic encode(UserMetadata v) => toMap(v);
  Map<String, dynamic> toMap(UserMetadata u) => {'creationTime': Mapper.i.$enc(u.creationTime, 'creationTime'), 'lastSignInTime': Mapper.i.$enc(u.lastSignInTime, 'lastSignInTime')};

  @override String stringify(UserMetadata self) => 'UserMetadata(creationTime: ${Mapper.asString(self.creationTime)}, lastSignInTime: ${Mapper.asString(self.lastSignInTime)})';
  @override int hash(UserMetadata self) => Mapper.hash(self.creationTime) ^ Mapper.hash(self.lastSignInTime);
  @override bool equals(UserMetadata self, UserMetadata other) => Mapper.isEqual(self.creationTime, other.creationTime) && Mapper.isEqual(self.lastSignInTime, other.lastSignInTime);

  @override Function get typeFactory => (f) => f<UserMetadata>();
}

extension UserMetadataMapperExtension  on UserMetadata {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  UserMetadataCopyWith<UserMetadata> get copyWith => UserMetadataCopyWith(this, $identity);
}

abstract class UserMetadataCopyWith<$R> {
  factory UserMetadataCopyWith(UserMetadata value, Then<UserMetadata, $R> then) = _UserMetadataCopyWithImpl<$R>;
  $R call({DateTime? creationTime, DateTime? lastSignInTime});
  $R apply(UserMetadata Function(UserMetadata) transform);
}

class _UserMetadataCopyWithImpl<$R> extends BaseCopyWith<UserMetadata, $R> implements UserMetadataCopyWith<$R> {
  _UserMetadataCopyWithImpl(UserMetadata value, Then<UserMetadata, $R> then) : super(value, then);

  @override $R call({Object? creationTime = $none, Object? lastSignInTime = $none}) => $then(UserMetadata(or(creationTime, $value.creationTime), or(lastSignInTime, $value.lastSignInTime)));
}

class UserInfoMapper extends BaseMapper<UserInfo> {
  UserInfoMapper._();

  @override Function get decoder => decode;
  UserInfo decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  UserInfo fromMap(Map<String, dynamic> map) => UserInfo(Mapper.i.$get(map, 'uid'), Mapper.i.$getOpt(map, 'displayName'), Mapper.i.$getOpt(map, 'email'), Mapper.i.$getOpt(map, 'photoUrl'), Mapper.i.$get(map, 'providerId'), Mapper.i.$getOpt(map, 'phoneNumber'));

  @override Function get encoder => (UserInfo v) => encode(v);
  dynamic encode(UserInfo v) => toMap(v);
  Map<String, dynamic> toMap(UserInfo u) => {'uid': Mapper.i.$enc(u.uid, 'uid'), 'displayName': Mapper.i.$enc(u.displayName, 'displayName'), 'email': Mapper.i.$enc(u.email, 'email'), 'photoUrl': Mapper.i.$enc(u.photoUrl, 'photoUrl'), 'providerId': Mapper.i.$enc(u.providerId, 'providerId'), 'phoneNumber': Mapper.i.$enc(u.phoneNumber, 'phoneNumber')};

  @override String stringify(UserInfo self) => 'UserInfo(uid: ${Mapper.asString(self.uid)}, displayName: ${Mapper.asString(self.displayName)}, email: ${Mapper.asString(self.email)}, photoUrl: ${Mapper.asString(self.photoUrl)}, providerId: ${Mapper.asString(self.providerId)}, phoneNumber: ${Mapper.asString(self.phoneNumber)})';
  @override int hash(UserInfo self) => Mapper.hash(self.uid) ^ Mapper.hash(self.displayName) ^ Mapper.hash(self.email) ^ Mapper.hash(self.photoUrl) ^ Mapper.hash(self.providerId) ^ Mapper.hash(self.phoneNumber);
  @override bool equals(UserInfo self, UserInfo other) => Mapper.isEqual(self.uid, other.uid) && Mapper.isEqual(self.displayName, other.displayName) && Mapper.isEqual(self.email, other.email) && Mapper.isEqual(self.photoUrl, other.photoUrl) && Mapper.isEqual(self.providerId, other.providerId) && Mapper.isEqual(self.phoneNumber, other.phoneNumber);

  @override Function get typeFactory => (f) => f<UserInfo>();
}

extension UserInfoMapperExtension  on UserInfo {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  UserInfoCopyWith<UserInfo> get copyWith => UserInfoCopyWith(this, $identity);
}

abstract class UserInfoCopyWith<$R> {
  factory UserInfoCopyWith(UserInfo value, Then<UserInfo, $R> then) = _UserInfoCopyWithImpl<$R>;
  $R call({String? uid, String? displayName, String? email, String? photoUrl, String? providerId, String? phoneNumber});
  $R apply(UserInfo Function(UserInfo) transform);
}

class _UserInfoCopyWithImpl<$R> extends BaseCopyWith<UserInfo, $R> implements UserInfoCopyWith<$R> {
  _UserInfoCopyWithImpl(UserInfo value, Then<UserInfo, $R> then) : super(value, then);

  @override $R call({String? uid, Object? displayName = $none, Object? email = $none, Object? photoUrl = $none, String? providerId, Object? phoneNumber = $none}) => $then(UserInfo(uid ?? $value.uid, or(displayName, $value.displayName), or(email, $value.email), or(photoUrl, $value.photoUrl), providerId ?? $value.providerId, or(phoneNumber, $value.phoneNumber)));
}

class UserClaimsMapper extends BaseMapper<UserClaims> {
  UserClaimsMapper._();

  @override Function get decoder => decode;
  UserClaims decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  UserClaims fromMap(Map<String, dynamic> map) => UserClaims(isGroupCreator: Mapper.i.$getOpt(map, 'isGroupCreator') ?? false, isAdmin: Mapper.i.$getOpt(map, 'isAdmin') ?? false);

  @override Function get encoder => (UserClaims v) => encode(v);
  dynamic encode(UserClaims v) => toMap(v);
  Map<String, dynamic> toMap(UserClaims u) => {'isGroupCreator': Mapper.i.$enc(u.isGroupCreator, 'isGroupCreator'), 'isAdmin': Mapper.i.$enc(u.isAdmin, 'isAdmin')};

  @override String stringify(UserClaims self) => 'UserClaims(isGroupCreator: ${Mapper.asString(self.isGroupCreator)}, isAdmin: ${Mapper.asString(self.isAdmin)})';
  @override int hash(UserClaims self) => Mapper.hash(self.isGroupCreator) ^ Mapper.hash(self.isAdmin);
  @override bool equals(UserClaims self, UserClaims other) => Mapper.isEqual(self.isGroupCreator, other.isGroupCreator) && Mapper.isEqual(self.isAdmin, other.isAdmin);

  @override Function get typeFactory => (f) => f<UserClaims>();
}

extension UserClaimsMapperExtension  on UserClaims {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  UserClaimsCopyWith<UserClaims> get copyWith => UserClaimsCopyWith(this, $identity);
}

abstract class UserClaimsCopyWith<$R> {
  factory UserClaimsCopyWith(UserClaims value, Then<UserClaims, $R> then) = _UserClaimsCopyWithImpl<$R>;
  $R call({bool? isGroupCreator, bool? isAdmin});
  $R apply(UserClaims Function(UserClaims) transform);
}

class _UserClaimsCopyWithImpl<$R> extends BaseCopyWith<UserClaims, $R> implements UserClaimsCopyWith<$R> {
  _UserClaimsCopyWithImpl(UserClaims value, Then<UserClaims, $R> then) : super(value, then);

  @override $R call({bool? isGroupCreator, bool? isAdmin}) => $then(UserClaims(isGroupCreator: isGroupCreator ?? $value.isGroupCreator, isAdmin: isAdmin ?? $value.isAdmin));
}

class AnnouncementNotificationMapper extends BaseMapper<AnnouncementNotification> {
  AnnouncementNotificationMapper._();

  @override Function get decoder => decode;
  AnnouncementNotification decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  AnnouncementNotification fromMap(Map<String, dynamic> map) => AnnouncementNotification(Mapper.i.$get(map, 'groupId'), Mapper.i.$get(map, 'id'), Mapper.i.$getOpt(map, 'title'), Mapper.i.$get(map, 'message'));

  @override Function get encoder => (AnnouncementNotification v) => encode(v);
  dynamic encode(AnnouncementNotification v) => toMap(v);
  Map<String, dynamic> toMap(AnnouncementNotification a) => {'groupId': Mapper.i.$enc(a.groupId, 'groupId'), 'id': Mapper.i.$enc(a.id, 'id'), 'title': Mapper.i.$enc(a.title, 'title'), 'message': Mapper.i.$enc(a.message, 'message')};

  @override String stringify(AnnouncementNotification self) => 'AnnouncementNotification(groupId: ${Mapper.asString(self.groupId)}, id: ${Mapper.asString(self.id)}, title: ${Mapper.asString(self.title)}, message: ${Mapper.asString(self.message)})';
  @override int hash(AnnouncementNotification self) => Mapper.hash(self.groupId) ^ Mapper.hash(self.id) ^ Mapper.hash(self.title) ^ Mapper.hash(self.message);
  @override bool equals(AnnouncementNotification self, AnnouncementNotification other) => Mapper.isEqual(self.groupId, other.groupId) && Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.title, other.title) && Mapper.isEqual(self.message, other.message);

  @override Function get typeFactory => (f) => f<AnnouncementNotification>();
}

extension AnnouncementNotificationMapperExtension  on AnnouncementNotification {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  AnnouncementNotificationCopyWith<AnnouncementNotification> get copyWith => AnnouncementNotificationCopyWith(this, $identity);
}

abstract class AnnouncementNotificationCopyWith<$R> {
  factory AnnouncementNotificationCopyWith(AnnouncementNotification value, Then<AnnouncementNotification, $R> then) = _AnnouncementNotificationCopyWithImpl<$R>;
  $R call({String? groupId, String? id, String? title, String? message});
  $R apply(AnnouncementNotification Function(AnnouncementNotification) transform);
}

class _AnnouncementNotificationCopyWithImpl<$R> extends BaseCopyWith<AnnouncementNotification, $R> implements AnnouncementNotificationCopyWith<$R> {
  _AnnouncementNotificationCopyWithImpl(AnnouncementNotification value, Then<AnnouncementNotification, $R> then) : super(value, then);

  @override $R call({String? groupId, String? id, Object? title = $none, String? message}) => $then(AnnouncementNotification(groupId ?? $value.groupId, id ?? $value.id, or(title, $value.title), message ?? $value.message));
}

class ChatNotificationMapper extends BaseMapper<ChatNotification> {
  ChatNotificationMapper._();

  @override Function get decoder => decode;
  ChatNotification decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChatNotification fromMap(Map<String, dynamic> map) => ChatNotification(Mapper.i.$get(map, 'groupId'), Mapper.i.$get(map, 'channelId'), Mapper.i.$get(map, 'id'), Mapper.i.$get(map, 'title'), Mapper.i.$get(map, 'message'));

  @override Function get encoder => (ChatNotification v) => encode(v);
  dynamic encode(ChatNotification v) => toMap(v);
  Map<String, dynamic> toMap(ChatNotification c) => {'groupId': Mapper.i.$enc(c.groupId, 'groupId'), 'channelId': Mapper.i.$enc(c.channelId, 'channelId'), 'id': Mapper.i.$enc(c.id, 'id'), 'title': Mapper.i.$enc(c.title, 'title'), 'message': Mapper.i.$enc(c.message, 'message')};

  @override String stringify(ChatNotification self) => 'ChatNotification(groupId: ${Mapper.asString(self.groupId)}, channelId: ${Mapper.asString(self.channelId)}, id: ${Mapper.asString(self.id)}, title: ${Mapper.asString(self.title)}, message: ${Mapper.asString(self.message)})';
  @override int hash(ChatNotification self) => Mapper.hash(self.groupId) ^ Mapper.hash(self.channelId) ^ Mapper.hash(self.id) ^ Mapper.hash(self.title) ^ Mapper.hash(self.message);
  @override bool equals(ChatNotification self, ChatNotification other) => Mapper.isEqual(self.groupId, other.groupId) && Mapper.isEqual(self.channelId, other.channelId) && Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.title, other.title) && Mapper.isEqual(self.message, other.message);

  @override Function get typeFactory => (f) => f<ChatNotification>();
}

extension ChatNotificationMapperExtension  on ChatNotification {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatNotificationCopyWith<ChatNotification> get copyWith => ChatNotificationCopyWith(this, $identity);
}

abstract class ChatNotificationCopyWith<$R> {
  factory ChatNotificationCopyWith(ChatNotification value, Then<ChatNotification, $R> then) = _ChatNotificationCopyWithImpl<$R>;
  $R call({String? groupId, String? channelId, String? id, String? title, String? message});
  $R apply(ChatNotification Function(ChatNotification) transform);
}

class _ChatNotificationCopyWithImpl<$R> extends BaseCopyWith<ChatNotification, $R> implements ChatNotificationCopyWith<$R> {
  _ChatNotificationCopyWithImpl(ChatNotification value, Then<ChatNotification, $R> then) : super(value, then);

  @override $R call({String? groupId, String? channelId, String? id, String? title, String? message}) => $then(ChatNotification(groupId ?? $value.groupId, channelId ?? $value.channelId, id ?? $value.id, title ?? $value.title, message ?? $value.message));
}


// === GENERATED ENUM MAPPERS AND EXTENSIONS ===

class UserStatusMapper extends EnumMapper<UserStatus> {
  UserStatusMapper._();

  @override  UserStatus decode(dynamic value) {
    switch (value) {
      case 'active': return UserStatus.active;
      case 'disabled': return UserStatus.disabled;
      case 'invited': return UserStatus.invited;
      default: throw MapperException.unknownEnumValue(value);
    }
  }

  @override  dynamic encode(UserStatus value) {
    switch (value) {
      case UserStatus.active: return 'active';
      case UserStatus.disabled: return 'disabled';
      case UserStatus.invited: return 'invited';
    }
  }
}

extension UserStatusMapperExtension on UserStatus {
  dynamic toValue() => Mapper.toValue(this);
  @Deprecated('Use \'toValue\' instead')
  String toStringValue() => Mapper.toValue(this) as String;
}


// === GENERATED UTILITY CODE ===

class Mapper {
  Mapper._();

  static late MapperContainer i = MapperContainer(_mappers);

  static T fromValue<T>(dynamic value) => i.fromValue<T>(value);
  static T fromMap<T>(Map<String, dynamic> map) => i.fromMap<T>(map);
  static T fromIterable<T>(Iterable<dynamic> iterable) => i.fromIterable<T>(iterable);
  static T fromJson<T>(String json) => i.fromJson<T>(json);

  static dynamic toValue(dynamic value) => i.toValue(value);
  static Map<String, dynamic> toMap(dynamic object) => i.toMap(object);
  static Iterable<dynamic> toIterable(dynamic object) => i.toIterable(object);
  static String toJson(dynamic object) => i.toJson(object);

  static bool isEqual(dynamic value, Object? other) => i.isEqual(value, other);
  static int hash(dynamic value) => i.hash(value);
  static String asString(dynamic value) => i.asString(value);

  static void use<T>(BaseMapper<T> mapper) => i.use<T>(mapper);
  static BaseMapper<T>? unuse<T>() => i.unuse<T>();
  static void useAll(List<BaseMapper> mappers) => i.useAll(mappers);

  static BaseMapper<T>? get<T>([Type? type]) => i.get<T>(type);
  static List<BaseMapper> getAll() => i.getAll();
}

mixin Mappable implements MappableMixin {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);

  @override
  String toString() {
    return _guard(() => Mapper.asString(this), super.toString);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            _guard(() => Mapper.isEqual(this, other), () => super == other));
  }

  @override
  int get hashCode {
    return _guard(() => Mapper.hash(this), () => super.hashCode);
  }

  T _guard<T>(T Function() fn, T Function() fallback) {
    try {
      return fn();
    } on MapperException catch (e) {
      if (e.isUnsupportedOrUnallowed()) {
        return fallback();
      } else {
        rethrow;
      }
    }
  }
}
