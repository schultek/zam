import 'package:dart_mappable/dart_mappable.dart';
import 'package:dart_mappable/internals.dart';

import '../api/modules/announcement.dart';
import '../api/modules/chat.dart';


// === ALL STATICALLY REGISTERED MAPPERS ===

var _mappers = <BaseMapper>{
  // class mappers
  AnnouncementNotificationMapper._(),
  ChatNotificationMapper._(),
  // enum mappers
  // custom mappers
};


// === GENERATED CLASS MAPPERS AND EXTENSIONS ===

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
