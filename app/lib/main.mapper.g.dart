import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';

import 'core/templates/templates.dart';
import 'models/models.dart';
import 'modules/chat/chat_provider.dart';
import 'modules/elimination/game_provider.dart';
import 'modules/notes/notes_provider.dart';
import 'providers/photos/photos_provider.dart';

// === ALL STATICALLY REGISTERED MAPPERS ===

var _mappers = <String, BaseMapper>{
  // primitive mappers
  _typeOf<dynamic>(): PrimitiveMapper((dynamic v) => v),
  _typeOf<String>(): PrimitiveMapper<String>((dynamic v) => v.toString()),
  _typeOf<int>(): PrimitiveMapper<int>((dynamic v) => num.parse(v.toString()).round()),
  _typeOf<double>(): PrimitiveMapper<double>((dynamic v) => double.parse(v.toString())),
  _typeOf<num>(): PrimitiveMapper<num>((dynamic v) => num.parse(v.toString())),
  _typeOf<bool>(): PrimitiveMapper<bool>((dynamic v) => v is num ? v != 0 : v.toString() == 'true'),
  _typeOf<DateTime>(): DateTimeMapper(),
  _typeOf<List>(): IterableMapper<List>(<T>(Iterable<T> i) => i.toList(), <T>(f) => f<List<T>>()),
  _typeOf<Set>(): IterableMapper<Set>(<T>(Iterable<T> i) => i.toSet(), <T>(f) => f<Set<T>>()),
  _typeOf<Map>(): MapMapper<Map>(<K, V>(Map<K, V> map) => map, <K, V>(f) => f<Map<K, V>>()),
  // class mappers
  _typeOf<Trip>(): TripMapper._(),
  _typeOf<TripUser>(): TripUserMapper._(),
  _typeOf<PhotosConfig>(): PhotosConfigMapper._(),
  _typeOf<EliminationGame>(): EliminationGameMapper._(),
  _typeOf<EliminationEntry>(): EliminationEntryMapper._(),
  _typeOf<Note>(): NoteMapper._(),
  _typeOf<TemplateModel>(): TemplateModelMapper._(),
  _typeOf<GridTemplateModel>(): GridTemplateModelMapper._(),
  _typeOf<SwipeTemplateModel>(): SwipeTemplateModelMapper._(),
  _typeOf<ChannelInfo>(): ChannelInfoMapper._(),
  _typeOf<ChatMessage>(): ChatMessageMapper._(),
  // enum mappers
  // custom mappers
};

// === GENERATED CLASS MAPPERS AND EXTENSIONS ===

class TripMapper extends BaseMapper<Trip> {
  TripMapper._();

  @override
  Function get decoder => decode;
  Trip decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  Trip fromMap(Map<String, dynamic> map) => Trip(
      id: map.get('id'),
      name: map.get('name'),
      template: map.get('template'),
      users: map.getMapOpt('users') ?? const {},
      modules: map.getMapOpt('modules') ?? const {});

  @override
  Function get encoder => (Trip v) => encode(v);
  dynamic encode(Trip v) => toMap(v);
  Map<String, dynamic> toMap(Trip t) => {
        'id': Mapper.toValue(t.id),
        'name': Mapper.toValue(t.name),
        'template': Mapper.toValue(t.template),
        'users': Mapper.toValue(t.users),
        'modules': Mapper.toValue(t.modules)
      };

  @override
  String? stringify(Trip self) =>
      'Trip(name: ${self.name}, id: ${self.id}, template: ${self.template}, users: ${self.users}, modules: ${self.modules})';
  @override
  int? hash(Trip self) =>
      self.id.hashCode ^ self.name.hashCode ^ self.template.hashCode ^ self.users.hashCode ^ self.modules.hashCode;
  @override
  bool? equals(Trip self, Trip other) =>
      self.id == other.id &&
      self.name == other.name &&
      self.template == other.template &&
      self.users == other.users &&
      self.modules == other.modules;

  @override
  Function get typeFactory => (f) => f<Trip>();
}

extension TripMapperExtension on Trip {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  Trip copyWith(
          {String? id,
          String? name,
          TemplateModel? template,
          Map<String, TripUser>? users,
          Map<String, List<String>>? modules}) =>
      Trip(
          id: id ?? this.id,
          name: name ?? this.name,
          template: template ?? this.template,
          users: users ?? this.users,
          modules: modules ?? this.modules);
}

class TripUserMapper extends BaseMapper<TripUser> {
  TripUserMapper._();

  @override
  Function get decoder => decode;
  TripUser decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  TripUser fromMap(Map<String, dynamic> map) =>
      TripUser(role: map.get('role'), nickname: map.getOpt('nickname'), profileUrl: map.getOpt('profileUrl'));

  @override
  Function get encoder => (TripUser v) => encode(v);
  dynamic encode(TripUser v) => toMap(v);
  Map<String, dynamic> toMap(TripUser t) => {
        'role': Mapper.toValue(t.role),
        'nickname': Mapper.toValue(t.nickname),
        'profileUrl': Mapper.toValue(t.profileUrl)
      };

  @override
  String? stringify(TripUser self) =>
      'TripUser(role: ${self.role}, nickname: ${self.nickname}, profileUrl: ${self.profileUrl})';
  @override
  int? hash(TripUser self) => self.role.hashCode ^ self.nickname.hashCode ^ self.profileUrl.hashCode;
  @override
  bool? equals(TripUser self, TripUser other) =>
      self.role == other.role && self.nickname == other.nickname && self.profileUrl == other.profileUrl;

  @override
  Function get typeFactory => (f) => f<TripUser>();
}

extension TripUserMapperExtension on TripUser {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  TripUser copyWith({String? role, String? nickname, String? profileUrl}) =>
      TripUser(role: role ?? this.role, nickname: nickname ?? this.nickname, profileUrl: profileUrl ?? this.profileUrl);
}

class PhotosConfigMapper extends BaseMapper<PhotosConfig> {
  PhotosConfigMapper._();

  @override
  Function get decoder => decode;
  PhotosConfig decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  PhotosConfig fromMap(Map<String, dynamic> map) => PhotosConfig(map.getOpt('albumId'), map.getOpt('shareToken'));

  @override
  Function get encoder => (PhotosConfig v) => encode(v);
  dynamic encode(PhotosConfig v) => toMap(v);
  Map<String, dynamic> toMap(PhotosConfig p) =>
      {'albumId': Mapper.toValue(p.albumId), 'shareToken': Mapper.toValue(p.shareToken)};

  @override
  String? stringify(PhotosConfig self) => 'PhotosConfig(albumId: ${self.albumId}, shareToken: ${self.shareToken})';
  @override
  int? hash(PhotosConfig self) => self.albumId.hashCode ^ self.shareToken.hashCode;
  @override
  bool? equals(PhotosConfig self, PhotosConfig other) =>
      self.albumId == other.albumId && self.shareToken == other.shareToken;

  @override
  Function get typeFactory => (f) => f<PhotosConfig>();
}

extension PhotosConfigMapperExtension on PhotosConfig {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  PhotosConfig copyWith({String? albumId, String? shareToken}) =>
      PhotosConfig(albumId ?? this.albumId, shareToken ?? this.shareToken);
}

class EliminationGameMapper extends BaseMapper<EliminationGame> {
  EliminationGameMapper._();

  @override
  Function get decoder => decode;
  EliminationGame decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  EliminationGame fromMap(Map<String, dynamic> map) =>
      EliminationGame(map.get('id'), map.getMap('initialTargets'), map.getList('eliminations'));

  @override
  Function get encoder => (EliminationGame v) => encode(v);
  dynamic encode(EliminationGame v) => toMap(v);
  Map<String, dynamic> toMap(EliminationGame e) => {
        'id': Mapper.toValue(e.id),
        'initialTargets': Mapper.toValue(e.initialTargets),
        'eliminations': Mapper.toValue(e.eliminations)
      };

  @override
  String? stringify(EliminationGame self) =>
      'EliminationGame(id: ${self.id}, initialTargets: ${self.initialTargets}, eliminations: ${self.eliminations})';
  @override
  int? hash(EliminationGame self) => self.id.hashCode ^ self.initialTargets.hashCode ^ self.eliminations.hashCode;
  @override
  bool? equals(EliminationGame self, EliminationGame other) =>
      self.id == other.id && self.initialTargets == other.initialTargets && self.eliminations == other.eliminations;

  @override
  Function get typeFactory => (f) => f<EliminationGame>();
}

extension EliminationGameMapperExtension on EliminationGame {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  EliminationGame copyWith({String? id, Map<String, String>? initialTargets, List<EliminationEntry>? eliminations}) =>
      EliminationGame(id ?? this.id, initialTargets ?? this.initialTargets, eliminations ?? this.eliminations);
}

class EliminationEntryMapper extends BaseMapper<EliminationEntry> {
  EliminationEntryMapper._();

  @override
  Function get decoder => decode;
  EliminationEntry decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  EliminationEntry fromMap(Map<String, dynamic> map) =>
      EliminationEntry(map.get('target'), map.get('eliminatedBy'), map.get('description'));

  @override
  Function get encoder => (EliminationEntry v) => encode(v);
  dynamic encode(EliminationEntry v) => toMap(v);
  Map<String, dynamic> toMap(EliminationEntry e) => {
        'target': Mapper.toValue(e.target),
        'eliminatedBy': Mapper.toValue(e.eliminatedBy),
        'description': Mapper.toValue(e.description)
      };

  @override
  String? stringify(EliminationEntry self) =>
      'EliminationEntry(target: ${self.target}, eliminatedBy: ${self.eliminatedBy}, description: ${self.description})';
  @override
  int? hash(EliminationEntry self) => self.target.hashCode ^ self.eliminatedBy.hashCode ^ self.description.hashCode;
  @override
  bool? equals(EliminationEntry self, EliminationEntry other) =>
      self.target == other.target && self.eliminatedBy == other.eliminatedBy && self.description == other.description;

  @override
  Function get typeFactory => (f) => f<EliminationEntry>();
}

extension EliminationEntryMapperExtension on EliminationEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  EliminationEntry copyWith({String? target, String? eliminatedBy, String? description}) =>
      EliminationEntry(target ?? this.target, eliminatedBy ?? this.eliminatedBy, description ?? this.description);
}

class NoteMapper extends BaseMapper<Note> {
  NoteMapper._();

  @override
  Function get decoder => decode;
  Note decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  Note fromMap(Map<String, dynamic> map) => Note(map.get('id'), map.getOpt('title'), map.getList('content'),
      folder: map.getOpt('folder'),
      isArchived: map.getOpt('isArchived') ?? false,
      author: map.get('author'),
      editors: map.getListOpt('editors') ?? const []);

  @override
  Function get encoder => (Note v) => encode(v);
  dynamic encode(Note v) => toMap(v);
  Map<String, dynamic> toMap(Note n) => {
        'id': Mapper.toValue(n.id),
        'title': Mapper.toValue(n.title),
        'content': Mapper.toValue(n.content),
        'folder': Mapper.toValue(n.folder),
        'isArchived': Mapper.toValue(n.isArchived),
        'author': Mapper.toValue(n.author),
        'editors': Mapper.toValue(n.editors)
      };

  @override
  String? stringify(Note self) =>
      'Note(id: ${self.id}, title: ${self.title}, content: ${self.content}, folder: ${self.folder}, isArchived: ${self.isArchived}, author: ${self.author}, editors: ${self.editors})';
  @override
  int? hash(Note self) =>
      self.id.hashCode ^
      self.title.hashCode ^
      self.content.hashCode ^
      self.folder.hashCode ^
      self.isArchived.hashCode ^
      self.author.hashCode ^
      self.editors.hashCode;
  @override
  bool? equals(Note self, Note other) =>
      self.id == other.id &&
      self.title == other.title &&
      self.content == other.content &&
      self.folder == other.folder &&
      self.isArchived == other.isArchived &&
      self.author == other.author &&
      self.editors == other.editors;

  @override
  Function get typeFactory => (f) => f<Note>();
}

extension NoteMapperExtension on Note {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  Note copyWith(
          {String? id,
          String? title,
          List<dynamic>? content,
          String? folder,
          bool? isArchived,
          String? author,
          List<String>? editors}) =>
      Note(id ?? this.id, title ?? this.title, content ?? this.content,
          folder: folder ?? this.folder,
          isArchived: isArchived ?? this.isArchived,
          author: author ?? this.author,
          editors: editors ?? this.editors);
}

class TemplateModelMapper extends BaseMapper<TemplateModel> {
  TemplateModelMapper._();

  @override
  Function get decoder => decode;
  TemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) {
        switch (map['type']) {
          case 'grid':
            return GridTemplateModelMapper._().decode(map);
          case 'swipe':
            return SwipeTemplateModelMapper._().decode(map);
          default:
            return fromMap(map);
        }
      });
  TemplateModel fromMap(Map<String, dynamic> map) => throw MapperException(
      "Cannot instantiate class TemplateModel, did you forgot to specify a subclass for [ type: '${map['type']}' ] or a default subclass?");

  @override
  Function get encoder => (TemplateModel v) => encode(v);
  dynamic encode(TemplateModel v) {
    if (v is GridTemplateModel) {
      return GridTemplateModelMapper._().encode(v);
    } else if (v is SwipeTemplateModel) {
      return SwipeTemplateModelMapper._().encode(v);
    } else {
      return toMap(v);
    }
  }

  Map<String, dynamic> toMap(TemplateModel t) => {'type': Mapper.toValue(t.type)};

  @override
  String? stringify(TemplateModel self) => 'TemplateModel(type: ${self.type})';
  @override
  int? hash(TemplateModel self) => self.type.hashCode;
  @override
  bool? equals(TemplateModel self, TemplateModel other) => self.type == other.type;

  @override
  Function get typeFactory => (f) => f<TemplateModel>();
}

extension TemplateModelMapperExtension on TemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
}

class GridTemplateModelMapper extends BaseMapper<GridTemplateModel> {
  GridTemplateModelMapper._();

  @override
  Function get decoder => decode;
  GridTemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  GridTemplateModel fromMap(Map<String, dynamic> map) => GridTemplateModel(type: map.getOpt('type'));

  @override
  Function get encoder => (GridTemplateModel v) => encode(v);
  dynamic encode(GridTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(GridTemplateModel g) => {'type': Mapper.toValue(g.type)};

  @override
  String? stringify(GridTemplateModel self) => 'GridTemplateModel(type: ${self.type})';
  @override
  int? hash(GridTemplateModel self) => self.type.hashCode;
  @override
  bool? equals(GridTemplateModel self, GridTemplateModel other) => self.type == other.type;

  @override
  Function get typeFactory => (f) => f<GridTemplateModel>();
}

extension GridTemplateModelMapperExtension on GridTemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  GridTemplateModel copyWith({String? type}) => GridTemplateModel(type: type ?? this.type);
}

class SwipeTemplateModelMapper extends BaseMapper<SwipeTemplateModel> {
  SwipeTemplateModelMapper._();

  @override
  Function get decoder => decode;
  SwipeTemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SwipeTemplateModel fromMap(Map<String, dynamic> map) => SwipeTemplateModel(type: map.getOpt('type'));

  @override
  Function get encoder => (SwipeTemplateModel v) => encode(v);
  dynamic encode(SwipeTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(SwipeTemplateModel s) => {'type': Mapper.toValue(s.type)};

  @override
  String? stringify(SwipeTemplateModel self) => 'SwipeTemplateModel(type: ${self.type})';
  @override
  int? hash(SwipeTemplateModel self) => self.type.hashCode;
  @override
  bool? equals(SwipeTemplateModel self, SwipeTemplateModel other) => self.type == other.type;

  @override
  Function get typeFactory => (f) => f<SwipeTemplateModel>();
}

extension SwipeTemplateModelMapperExtension on SwipeTemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SwipeTemplateModel copyWith({String? type}) => SwipeTemplateModel(type: type ?? this.type);
}

class ChannelInfoMapper extends BaseMapper<ChannelInfo> {
  ChannelInfoMapper._();

  @override
  Function get decoder => decode;
  ChannelInfo decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChannelInfo fromMap(Map<String, dynamic> map) => ChannelInfo(
      id: map.get('id'),
      name: map.get('name'),
      isOpen: map.getOpt('isOpen') ?? true,
      members: map.getListOpt('members') ?? const []);

  @override
  Function get encoder => (ChannelInfo v) => encode(v);
  dynamic encode(ChannelInfo v) => toMap(v);
  Map<String, dynamic> toMap(ChannelInfo c) => {
        'id': Mapper.toValue(c.id),
        'name': Mapper.toValue(c.name),
        'isOpen': Mapper.toValue(c.isOpen),
        'members': Mapper.toValue(c.members)
      };

  @override
  String? stringify(ChannelInfo self) =>
      'ChannelInfo(name: ${self.name}, id: ${self.id}, isOpen: ${self.isOpen}, members: ${self.members})';
  @override
  int? hash(ChannelInfo self) => self.id.hashCode ^ self.name.hashCode ^ self.isOpen.hashCode ^ self.members.hashCode;
  @override
  bool? equals(ChannelInfo self, ChannelInfo other) =>
      self.id == other.id && self.name == other.name && self.isOpen == other.isOpen && self.members == other.members;

  @override
  Function get typeFactory => (f) => f<ChannelInfo>();
}

extension ChannelInfoMapperExtension on ChannelInfo {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChannelInfo copyWith({String? id, String? name, bool? isOpen, List<String>? members}) => ChannelInfo(
      id: id ?? this.id, name: name ?? this.name, isOpen: isOpen ?? this.isOpen, members: members ?? this.members);
}

class ChatMessageMapper extends BaseMapper<ChatMessage> {
  ChatMessageMapper._();

  @override
  Function get decoder => decode;
  ChatMessage decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChatMessage fromMap(Map<String, dynamic> map) =>
      ChatMessage(sender: map.get('sender'), text: map.get('text'), sentAt: map.get('sentAt'));

  @override
  Function get encoder => (ChatMessage v) => encode(v);
  dynamic encode(ChatMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatMessage c) =>
      {'sender': Mapper.toValue(c.sender), 'text': Mapper.toValue(c.text), 'sentAt': Mapper.toValue(c.sentAt)};

  @override
  String? stringify(ChatMessage self) =>
      'ChatMessage(sender: ${self.sender}, text: ${self.text}, sentAt: ${self.sentAt})';
  @override
  int? hash(ChatMessage self) => self.sender.hashCode ^ self.text.hashCode ^ self.sentAt.hashCode;
  @override
  bool? equals(ChatMessage self, ChatMessage other) =>
      self.sender == other.sender && self.text == other.text && self.sentAt == other.sentAt;

  @override
  Function get typeFactory => (f) => f<ChatMessage>();
}

extension ChatMessageMapperExtension on ChatMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatMessage copyWith({String? sender, String? text, DateTime? sentAt}) =>
      ChatMessage(sender: sender ?? this.sender, text: text ?? this.text, sentAt: sentAt ?? this.sentAt);
}

// === GENERATED ENUM MAPPERS AND EXTENSIONS ===

// === GENERATED UTILITY CODE ===

class Mapper<T> {
  Mapper._();

  static T fromValue<T>(dynamic value) {
    if (value.runtimeType == T || value == null) {
      return value as T;
    } else {
      TypeInfo typeInfo;
      if (value is Map<String, dynamic> && value['__type'] != null) {
        typeInfo = TypeInfo.fromType(value['__type'] as String);
      } else {
        typeInfo = TypeInfo.fromType<T>();
      }
      var mapper = _mappers[typeInfo.type];
      if (mapper?.decoder != null) {
        try {
          return genericCall(typeInfo, mapper!.decoder!, value) as T;
        } catch (e) {
          throw MapperException('Error on decoding type $T: ${e is MapperException ? e.message : e}');
        }
      } else {
        throw MapperException(
            'Cannot decode value $value of type ${value.runtimeType} to type $T. Unknown type. Did you forgot to include the class or register a custom mapper?');
      }
    }
  }

  static dynamic toValue(dynamic value) {
    if (value == null) return null;
    var typeInfo = TypeInfo.fromValue(value);
    var mapper = _mappers[typeInfo.type] ??
        _mappers.values.cast<BaseMapper?>().firstWhere((m) => m!.isFor(value), orElse: () => null);
    if (mapper != null && mapper.encoder != null) {
      var encoded = mapper.encoder!.call(value);
      if (encoded is Map<String, dynamic>) {
        _clearType(encoded);
        if (typeInfo.params.isNotEmpty) {
          typeInfo.type = _typeOf(mapper.type);
          encoded['__type'] = typeInfo.toString();
        }
      }
      return encoded;
    } else {
      throw MapperException(
          'Cannot encode value $value of type ${value.runtimeType}. Unknown type. Did you forgot to include the class or register a custom mapper?');
    }
  }

  static T fromMap<T>(Map<String, dynamic> map) => fromValue<T>(map);

  static Map<String, dynamic> toMap(dynamic object) {
    var value = toValue(object);
    if (value is Map<String, dynamic>) {
      return value;
    } else {
      throw MapperException(
          'Cannot encode value of type ${object.runtimeType} to Map. Instead encoded to type ${value.runtimeType}.');
    }
  }

  static T fromIterable<T>(Iterable<dynamic> iterable) => fromValue<T>(iterable);

  static Iterable<dynamic> toIterable(dynamic object) {
    var value = toValue(object);
    if (value is Iterable<dynamic>) {
      return value;
    } else {
      throw MapperException(
          'Cannot encode value of type ${object.runtimeType} to Iterable. Instead encoded to type ${value.runtimeType}.');
    }
  }

  static T fromJson<T>(String json) {
    return fromValue<T>(jsonDecode(json));
  }

  static String toJson(dynamic object) {
    return jsonEncode(toValue(object));
  }

  static bool isEqual(dynamic value, Object? other) {
    var type = _typeOf(value.runtimeType);
    return _mappers[type]?.equals(value, other) ?? value == other;
  }

  static String asString(dynamic value) {
    var type = _typeOf(value.runtimeType);
    return _mappers[type]?.stringify(value) ?? value.toString();
  }

  static void use<T>(BaseMapper<T> mapper) => _mappers[_typeOf<T>()] = mapper;
  static BaseMapper<T>? unuse<T>() => _mappers.remove(_typeOf<T>()) as BaseMapper<T>?;
}

String _typeOf<T>([Type? t]) {
  var input = (t ?? T).toString();
  return input.split('<')[0];
}

void _clearType(Map<String, dynamic> map) {
  map.removeWhere((key, _) => key == '__type');
  map.values.whereType<Map<String, dynamic>>().forEach(_clearType);
  map.values.whereType<List>().forEach((l) => l.whereType<Map<String, dynamic>>().forEach(_clearType));
}

mixin Mappable {
  BaseMapper? get _mapper => _mappers[_typeOf(runtimeType)];

  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);

  @override
  String toString() => _mapper?.stringify(this) ?? super.toString();
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (runtimeType == other.runtimeType && (_mapper?.equals(this, other) ?? super == other));
  @override
  int get hashCode => _mapper?.hash(this) ?? super.hashCode;
}

T _checked<T, U>(dynamic v, T Function(U) fn) {
  if (v is U) {
    return fn(v);
  } else {
    throw MapperException(
        'Cannot decode value of type ${v.runtimeType} to type $T, because a value of type $U is expected.');
  }
}

class DateTimeMapper extends SimpleMapper<DateTime> {
  @override
  DateTime decode(dynamic d) {
    if (d is String) {
      return DateTime.parse(d);
    } else if (d is num) {
      return DateTime.fromMillisecondsSinceEpoch(d.round());
    } else {
      throw MapperException(
          'Cannot decode value of type ${d.runtimeType} to type DateTime, because a value of type String or num is expected.');
    }
  }

  @override
  String encode(DateTime self) {
    return self.toUtc().toIso8601String();
  }
}

class IterableMapper<I extends Iterable> extends BaseMapper<I> {
  Iterable<U> Function<U>(Iterable<U> iterable) fromIterable;
  IterableMapper(this.fromIterable, this.typeFactory);

  @override
  Function get decoder =>
      <T>(dynamic l) => _checked(l, (Iterable l) => fromIterable(l.map((v) => Mapper.fromValue<T>(v))));
  @override
  Function get encoder => (I self) => self.map((v) => Mapper.toValue(v)).toList();
  @override
  Function typeFactory;
}

class MapMapper<M extends Map> extends BaseMapper<M> {
  Map<K, V> Function<K, V>(Map<K, V> map) fromMap;
  MapMapper(this.fromMap, this.typeFactory);

  @override
  Function get decoder => <K, V>(dynamic m) => _checked(
      m, (Map m) => fromMap(m.map((key, value) => MapEntry(Mapper.fromValue<K>(key), Mapper.fromValue<V>(value)))));
  @override
  Function get encoder => (M self) => self.map((key, value) => MapEntry(Mapper.toValue(key), Mapper.toValue(value)));
  @override
  Function typeFactory;
}

class PrimitiveMapper<T> extends BaseMapper<T> {
  const PrimitiveMapper(this.decoder);

  @override
  final T Function(dynamic value) decoder;
  @override
  Function get encoder => (T value) => value;
  @override
  Function get typeFactory => (f) => f<T>();

  @override
  bool isFor(dynamic v) => v.runtimeType == T;
}

class EnumMapper<T> extends SimpleMapper<T> {
  EnumMapper(this._decoder, this._encoder);

  final T Function(String value) _decoder;
  final String Function(T value) _encoder;

  @override
  T decode(dynamic v) => _checked(v, _decoder);
  @override
  dynamic encode(T value) => _encoder(value);
}

dynamic genericCall(TypeInfo info, Function fn, dynamic value) {
  var params = [...info.params];

  dynamic call(dynamic Function<T>() next) {
    var t = params.removeAt(0);
    if (_mappers[t.type] != null) {
      return genericCall(t, _mappers[t.type]!.typeFactory ?? (f) => f(), next);
    } else {
      throw MapperException('Cannot find generic wrapper for type $t.');
    }
  }

  if (params.isEmpty) {
    return fn(value);
  } else if (params.length == 1) {
    return call(<A>() => fn<A>(value));
  } else if (params.length == 2) {
    return call(<A>() => call(<B>() => fn<A, B>(value)));
  } else if (params.length == 3) {
    return call(<A>() => call(<B>() => call(<C>() => fn<A, B, C>(value))));
  } else {
    throw MapperException(
        'Cannot construct generic wrapper for type $info. Mapper only supports generic classes with up to 3 type arguments.');
  }
}

T _hookedDecode<T>(MappingHooks hooks, dynamic value, T Function(dynamic value) fn) {
  var v = hooks.beforeDecode(value);
  if (v is! T) v = fn(v);
  return hooks.afterDecode(v) as T;
}

dynamic _hookedEncode<T>(MappingHooks hooks, T value, dynamic Function(T value) fn) {
  var v = hooks.beforeEncode(value);
  if (v is T) v = fn(v);
  return hooks.afterEncode(v);
}

dynamic _toValue(dynamic value, {MappingHooks? hooks}) {
  if (hooks == null) {
    return Mapper.toValue(value);
  } else {
    return hooks.afterEncode(Mapper.toValue(hooks.beforeEncode(value)));
  }
}

extension MapGet on Map<String, dynamic> {
  T get<T>(String key, {MappingHooks? hooks}) => hooked(hooks, key, (v) {
        if (v == null) {
          throw MapperException('Parameter $key is required.');
        }
        return Mapper.fromValue<T>(v);
      });

  T? getOpt<T>(String key, {MappingHooks? hooks}) => hooked(hooks, key, (v) {
        if (v == null) {
          return null;
        }
        return Mapper.fromValue<T>(v);
      });

  List<T> getList<T>(String key, {MappingHooks? hooks}) => hooked(hooks, key, (v) {
        if (v == null) {
          throw MapperException('Parameter $key is required.');
        } else if (v is! List) {
          throw MapperException('Parameter $v with key $key is not a List');
        }
        return v.map((dynamic item) => Mapper.fromValue<T>(item)).toList();
      });

  List<T>? getListOpt<T>(String key, {MappingHooks? hooks}) => hooked(hooks, key, (v) {
        if (v == null) {
          return null;
        } else if (v is! List) {
          throw MapperException('Parameter $v with key $key is not a List');
        }
        return v.map((dynamic item) => Mapper.fromValue<T>(item)).toList();
      });

  Map<K, V> getMap<K, V>(String key, {MappingHooks? hooks}) => hooked(hooks, key, (v) {
        if (v == null) {
          throw MapperException('Parameter $key is required.');
        } else if (v is! Map) {
          throw MapperException('Parameter $v with key $key is not a Map');
        }
        return v.map((dynamic key, dynamic value) => MapEntry(Mapper.fromValue<K>(key), Mapper.fromValue<V>(value)));
      });

  Map<K, V>? getMapOpt<K, V>(String key, {MappingHooks? hooks}) => hooked(hooks, key, (v) {
        if (v == null) {
          return null;
        } else if (v is! Map) {
          throw MapperException('Parameter $v with key $key is not a Map');
        }
        return v.map((dynamic key, dynamic value) => MapEntry(Mapper.fromValue<K>(key), Mapper.fromValue<V>(value)));
      });

  T hooked<T>(MappingHooks? hooks, String key, T Function(dynamic v) fn) {
    if (hooks == null) {
      return fn(this[key]);
    } else {
      return hooks.afterDecode(fn(hooks.beforeDecode(this[key]))) as T;
    }
  }
}
