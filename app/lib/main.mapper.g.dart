// ignore_for_file: unnecessary_cast, prefer_relative_imports, unused_element
import 'dart:convert';
import 'package:jufa/models/models.dart';
import 'package:jufa/core/templates/templates.dart';
import 'package:jufa/modules/supply/supply_models.dart';

// === GENERATED MAPPER CLASSES AND EXTENSIONS ===

class TripMapper implements Mapper<Trip> {
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
  dynamic encode(Trip v) => toMap(v);
  Map<String, dynamic> toMap(Trip t) => {
        'id': Mapper.toValue(t.id),
        'name': Mapper.toValue(t.name),
        'template': Mapper.toValue(t.template),
        'users': Mapper.toValue(t.users),
        'modules': Mapper.toValue(t.modules)
      };

  @override
  String stringify(Trip self) =>
      'Trip(name: ${self.name}, id: ${self.id}, template: ${self.template}, users: ${self.users}, modules: ${self.modules})';
  @override
  int hash(Trip self) =>
      self.id.hashCode ^ self.name.hashCode ^ self.template.hashCode ^ self.users.hashCode ^ self.modules.hashCode;
  @override
  bool equals(Trip self, Trip other) =>
      self.id == other.id &&
      self.name == other.name &&
      self.template == other.template &&
      self.users == other.users &&
      self.modules == other.modules;

  @override
  Function get typeFactory => (f) => f<Trip>();
}

extension TripExtension on Trip {
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

class TripUserMapper implements Mapper<TripUser> {
  TripUserMapper._();

  @override
  Function get decoder => decode;
  TripUser decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  TripUser fromMap(Map<String, dynamic> map) => TripUser(role: map.get('role'), nickname: map.getOpt('nickname'));

  @override
  dynamic encode(TripUser v) => toMap(v);
  Map<String, dynamic> toMap(TripUser t) => {'role': Mapper.toValue(t.role), 'nickname': Mapper.toValue(t.nickname)};

  @override
  String stringify(TripUser self) => 'TripUser(role: ${self.role}, nickname: ${self.nickname})';
  @override
  int hash(TripUser self) => self.role.hashCode ^ self.nickname.hashCode;
  @override
  bool equals(TripUser self, TripUser other) => self.role == other.role && self.nickname == other.nickname;

  @override
  Function get typeFactory => (f) => f<TripUser>();
}

extension TripUserExtension on TripUser {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  TripUser copyWith({String? role, String? nickname}) =>
      TripUser(role: role ?? this.role, nickname: nickname ?? this.nickname);
}

class TemplateModelMapper implements Mapper<TemplateModel> {
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
      "Cannot instantiate abstract class TemplateModel, did you forgot to specify a subclass for [ type: '${map['type']}' ] or a default subclass?");

  @override
  dynamic encode(TemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(TemplateModel t) => {'type': Mapper.toValue(t.type)};

  @override
  String stringify(TemplateModel self) => 'TemplateModel(type: ${self.type})';
  @override
  int hash(TemplateModel self) => self.type.hashCode;
  @override
  bool equals(TemplateModel self, TemplateModel other) => self.type == other.type;

  @override
  Function get typeFactory => (f) => f<TemplateModel>();
}

extension TemplateModelExtension on TemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
}

class GridTemplateModelMapper implements Mapper<GridTemplateModel> {
  GridTemplateModelMapper._();

  @override
  Function get decoder => decode;
  GridTemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  GridTemplateModel fromMap(Map<String, dynamic> map) => GridTemplateModel(type: map.getOpt('type'));

  @override
  dynamic encode(GridTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(GridTemplateModel g) => {'type': Mapper.toValue(g.type)};

  @override
  String stringify(GridTemplateModel self) => 'GridTemplateModel(type: ${self.type})';
  @override
  int hash(GridTemplateModel self) => self.type.hashCode;
  @override
  bool equals(GridTemplateModel self, GridTemplateModel other) => self.type == other.type;

  @override
  Function get typeFactory => (f) => f<GridTemplateModel>();
}

extension GridTemplateModelExtension on GridTemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  GridTemplateModel copyWith({String? type}) => GridTemplateModel(type: type ?? this.type);
}

class SwipeTemplateModelMapper implements Mapper<SwipeTemplateModel> {
  SwipeTemplateModelMapper._();

  @override
  Function get decoder => decode;
  SwipeTemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SwipeTemplateModel fromMap(Map<String, dynamic> map) => SwipeTemplateModel(type: map.getOpt('type'));

  @override
  dynamic encode(SwipeTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(SwipeTemplateModel s) => {'type': Mapper.toValue(s.type)};

  @override
  String stringify(SwipeTemplateModel self) => 'SwipeTemplateModel(type: ${self.type})';
  @override
  int hash(SwipeTemplateModel self) => self.type.hashCode;
  @override
  bool equals(SwipeTemplateModel self, SwipeTemplateModel other) => self.type == other.type;

  @override
  Function get typeFactory => (f) => f<SwipeTemplateModel>();
}

extension SwipeTemplateModelExtension on SwipeTemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SwipeTemplateModel copyWith({String? type}) => SwipeTemplateModel(type: type ?? this.type);
}

class ArticleMapper implements Mapper<Article> {
  ArticleMapper._();

  @override
  Function get decoder => decode;
  Article decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  Article fromMap(Map<String, dynamic> map) =>
      Article(map.get('id'), map.get('name'), map.get('category'), map.get('hint'));

  @override
  dynamic encode(Article v) => toMap(v);
  Map<String, dynamic> toMap(Article a) => {
        'id': Mapper.toValue(a.id),
        'name': Mapper.toValue(a.name),
        'category': Mapper.toValue(a.category),
        'hint': Mapper.toValue(a.hint)
      };

  @override
  String stringify(Article self) =>
      'Article(id: ${self.id}, name: ${self.name}, category: ${self.category}, hint: ${self.hint})';
  @override
  int hash(Article self) => self.id.hashCode ^ self.name.hashCode ^ self.category.hashCode ^ self.hint.hashCode;
  @override
  bool equals(Article self, Article other) =>
      self.id == other.id && self.name == other.name && self.category == other.category && self.hint == other.hint;

  @override
  Function get typeFactory => (f) => f<Article>();
}

extension ArticleExtension on Article {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  Article copyWith({String? id, String? name, String? category, String? hint}) =>
      Article(id ?? this.id, name ?? this.name, category ?? this.category, hint ?? this.hint);
}

class ArticleListMapper implements Mapper<ArticleList> {
  ArticleListMapper._();

  @override
  Function get decoder => decode;
  ArticleList decode(dynamic v) => _checked(v, (Map<String, dynamic> map) {
        switch (map['type']) {
          case "recipe":
            return RecipeMapper._().decode(map);
          case "shoppingList":
            return ShoppingListMapper._().decode(map);
          default:
            return fromMap(map);
        }
      });
  ArticleList fromMap(Map<String, dynamic> map) =>
      ArticleList(map.get('id'), map.get('name'), map.getList('entries'), map.get('note'));

  @override
  dynamic encode(ArticleList v) => toMap(v);
  Map<String, dynamic> toMap(ArticleList a) => {
        'id': Mapper.toValue(a.id),
        'name': Mapper.toValue(a.name),
        'entries': Mapper.toValue(a.entries),
        'note': Mapper.toValue(a.note)
      };

  @override
  String stringify(ArticleList self) =>
      'ArticleList(id: ${self.id}, name: ${self.name}, entries: ${self.entries}, note: ${self.note})';
  @override
  int hash(ArticleList self) => self.id.hashCode ^ self.name.hashCode ^ self.entries.hashCode ^ self.note.hashCode;
  @override
  bool equals(ArticleList self, ArticleList other) =>
      self.id == other.id && self.name == other.name && self.entries == other.entries && self.note == other.note;

  @override
  Function get typeFactory => (f) => f<ArticleList>();
}

extension ArticleListExtension on ArticleList {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ArticleList copyWith({String? id, String? name, List<ArticleEntry>? entries, String? note}) =>
      ArticleList(id ?? this.id, name ?? this.name, entries ?? this.entries, note ?? this.note);
}

class ArticleEntryMapper implements Mapper<ArticleEntry> {
  ArticleEntryMapper._();

  @override
  Function get decoder => decode;
  ArticleEntry decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  ArticleEntry fromMap(Map<String, dynamic> map) =>
      ArticleEntry(map.get('articleId'), map.get('amount'), map.get('unit'), map.get('checked'), map.get('hint'));

  @override
  dynamic encode(ArticleEntry v) => toMap(v);
  Map<String, dynamic> toMap(ArticleEntry a) => {
        'articleId': Mapper.toValue(a.articleId),
        'amount': Mapper.toValue(a.amount),
        'unit': Mapper.toValue(a.unit),
        'checked': Mapper.toValue(a.checked),
        'hint': Mapper.toValue(a.hint)
      };

  @override
  String stringify(ArticleEntry self) =>
      'ArticleEntry(articleId: ${self.articleId}, amount: ${self.amount}, unit: ${self.unit}, checked: ${self.checked}, hint: ${self.hint})';
  @override
  int hash(ArticleEntry self) =>
      self.articleId.hashCode ^ self.amount.hashCode ^ self.unit.hashCode ^ self.checked.hashCode ^ self.hint.hashCode;
  @override
  bool equals(ArticleEntry self, ArticleEntry other) =>
      self.articleId == other.articleId &&
      self.amount == other.amount &&
      self.unit == other.unit &&
      self.checked == other.checked &&
      self.hint == other.hint;

  @override
  Function get typeFactory => (f) => f<ArticleEntry>();
}

extension ArticleEntryExtension on ArticleEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ArticleEntry copyWith({String? articleId, double? amount, String? unit, bool? checked, String? hint}) => ArticleEntry(
      articleId ?? this.articleId,
      amount ?? this.amount,
      unit ?? this.unit,
      checked ?? this.checked,
      hint ?? this.hint);
}

class RecipeMapper implements Mapper<Recipe> {
  RecipeMapper._();

  @override
  Function get decoder => decode;
  Recipe decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  Recipe fromMap(Map<String, dynamic> map) =>
      Recipe(map.get('id'), map.get('name'), map.getList('entries'), map.get('preparation'), map.get('note'));

  @override
  dynamic encode(Recipe v) => toMap(v);
  Map<String, dynamic> toMap(Recipe r) => {
        'id': Mapper.toValue(r.id),
        'name': Mapper.toValue(r.name),
        'entries': Mapper.toValue(r.entries),
        'preparation': Mapper.toValue(r.preparation),
        'note': Mapper.toValue(r.note),
        'type': "recipe"
      };

  @override
  String stringify(Recipe self) =>
      'Recipe(id: ${self.id}, name: ${self.name}, entries: ${self.entries}, note: ${self.note}, preparation: ${self.preparation})';
  @override
  int hash(Recipe self) =>
      self.id.hashCode ^ self.name.hashCode ^ self.entries.hashCode ^ self.preparation.hashCode ^ self.note.hashCode;
  @override
  bool equals(Recipe self, Recipe other) =>
      self.id == other.id &&
      self.name == other.name &&
      self.entries == other.entries &&
      self.preparation == other.preparation &&
      self.note == other.note;

  @override
  Function get typeFactory => (f) => f<Recipe>();
}

extension RecipeExtension on Recipe {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  Recipe copyWith({String? id, String? name, List<ArticleEntry>? entries, String? preparation, String? note}) => Recipe(
      id ?? this.id, name ?? this.name, entries ?? this.entries, preparation ?? this.preparation, note ?? this.note);
}

class ShoppingListMapper implements Mapper<ShoppingList> {
  ShoppingListMapper._();

  @override
  Function get decoder => decode;
  ShoppingList decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  ShoppingList fromMap(Map<String, dynamic> map) =>
      ShoppingList(map.get('id'), map.get('name'), map.getList('entries'), map.get('note'));

  @override
  dynamic encode(ShoppingList v) => toMap(v);
  Map<String, dynamic> toMap(ShoppingList s) => {
        'id': Mapper.toValue(s.id),
        'name': Mapper.toValue(s.name),
        'entries': Mapper.toValue(s.entries),
        'note': Mapper.toValue(s.note),
        'type': "shoppingList"
      };

  @override
  String stringify(ShoppingList self) =>
      'ShoppingList(id: ${self.id}, name: ${self.name}, entries: ${self.entries}, note: ${self.note})';
  @override
  int hash(ShoppingList self) => self.id.hashCode ^ self.name.hashCode ^ self.entries.hashCode ^ self.note.hashCode;
  @override
  bool equals(ShoppingList self, ShoppingList other) =>
      self.id == other.id && self.name == other.name && self.entries == other.entries && self.note == other.note;

  @override
  Function get typeFactory => (f) => f<ShoppingList>();
}

extension ShoppingListExtension on ShoppingList {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ShoppingList copyWith({String? id, String? name, List<ArticleEntry>? entries, String? note}) =>
      ShoppingList(id ?? this.id, name ?? this.name, entries ?? this.entries, note ?? this.note);
}

// === ALL STATICALLY REGISTERED MAPPERS ===

var _mappers = <String, Mapper>{
  // primitive mappers
  _typeOf<dynamic>(): _PrimitiveMapper((dynamic v) => v),
  _typeOf<String>(): _PrimitiveMapper<String>((dynamic v) => v.toString()),
  _typeOf<int>(): _PrimitiveMapper<int>((dynamic v) => num.parse(v.toString()).round()),
  _typeOf<double>(): _PrimitiveMapper<double>((dynamic v) => double.parse(v.toString())),
  _typeOf<num>(): _PrimitiveMapper<num>((dynamic v) => num.parse(v.toString())),
  _typeOf<bool>(): _PrimitiveMapper<bool>((dynamic v) => v is num ? v != 0 : v.toString() == 'true'),
  _typeOf<DateTime>(): _DateTimeMapper(),
  _typeOf<List>(): IterableMapper<List>(<T>(Iterable<T> i) => i.toList(), <T>(f) => f<List<T>>()),
  _typeOf<Set>(): IterableMapper<Set>(<T>(Iterable<T> i) => i.toSet(), <T>(f) => f<Set<T>>()),
  _typeOf<Map>(): MapMapper<Map>(<K, V>(Map<K, V> map) => map, <K, V>(f) => f<Map<K, V>>()),
  // generated mappers
  _typeOf<Trip>(): TripMapper._(),
  _typeOf<TripUser>(): TripUserMapper._(),
  _typeOf<TemplateModel>(): TemplateModelMapper._(),
  _typeOf<GridTemplateModel>(): GridTemplateModelMapper._(),
  _typeOf<SwipeTemplateModel>(): SwipeTemplateModelMapper._(),
  _typeOf<Article>(): ArticleMapper._(),
  _typeOf<ArticleList>(): ArticleListMapper._(),
  _typeOf<ArticleEntry>(): ArticleEntryMapper._(),
  _typeOf<Recipe>(): RecipeMapper._(),
  _typeOf<ShoppingList>(): ShoppingListMapper._(),
};

// === GENERATED UTILITY CLASSES ===

abstract class Mapper<T> {
  dynamic encode(T self);
  Function get decoder;
  Function get typeFactory;

  String stringify(T self);
  int hash(T self);
  bool equals(T self, T other);

  Mapper._();

  static T fromValue<T>(dynamic value) {
    if (value.runtimeType == T || value == null) {
      return value as T;
    } else {
      TypeInfo typeInfo;
      if (value is Map<String, dynamic> && value['__type'] != null) {
        typeInfo = getTypeInfo(value['__type'] as String);
      } else {
        typeInfo = getTypeInfo<T>();
      }
      var mapper = _mappers[typeInfo.type];
      if (mapper != null) {
        try {
          return genericCall(typeInfo, mapper.decoder, value) as T;
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
    var typeInfo = getTypeInfoFor(value);
    if (_mappers[typeInfo.type] != null) {
      var encoded = _mappers[typeInfo.type]!.encode(value);
      if (encoded is Map<String, dynamic>) {
        _clearType(encoded);
        if (typeInfo.params.isNotEmpty) {
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
    if (_mappers[type] != null) {
      return _mappers[type]!.equals(value, other);
    } else {
      throw MapperException(
          'Cannot compare value of type $type for equality. Unknown type. Did you forgot to include the class or register a custom mapper?');
    }
  }

  static String asString(dynamic value) {
    var type = _typeOf(value.runtimeType);
    if (_mappers[type] != null) {
      return _mappers[type]!.stringify(value);
    } else {
      throw MapperException(
          'Cannot stringify value of type $type. Unknown type. Did you forgot to include the class or register a custom mapper?');
    }
  }

  static void use<T>(Mapper<T> mapper) => _mappers[_typeOf<T>()] = mapper;
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
  Mapper? get _mapper => _mappers[_typeOf(runtimeType)];

  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);

  @override
  String toString() => _mapper?.stringify(this) ?? super.toString();
  @override
  bool operator ==(Object other) => _mapper != null
      ? identical(this, other) || runtimeType == other.runtimeType && _mapper!.equals(this, other)
      : super == other;
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

abstract class BaseMapper<T> implements Mapper<T> {
  @override
  bool equals(T self, Object? other) => self == other;
  @override
  int hash(T self) => self.hashCode;
  @override
  String stringify(T self) => self.toString();
  @override
  Function get typeFactory => (f) => f<T>();
}

class _DateTimeMapper extends BaseMapper<DateTime> {
  @override
  Function get decoder => decode;

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
  String encode(DateTime self) => self.toUtc().toIso8601String();
}

class IterableMapper<I extends Iterable> extends BaseMapper<I> {
  Iterable<U> Function<U>(Iterable<U> iterable) fromIterable;
  IterableMapper(this.fromIterable, this.typeFactory);

  @override
  Function get decoder => decode;
  Iterable<T> decode<T>(dynamic l) => _checked(l, (Iterable l) => fromIterable(l.map((v) => Mapper.fromValue<T>(v))));
  @override
  List encode(I self) => self.map((v) => Mapper.toValue(v)).toList();
  @override
  Function typeFactory;
}

class MapMapper<M extends Map> extends BaseMapper<M> {
  Map<K, V> Function<K, V>(Map<K, V> map) fromMap;
  MapMapper(this.fromMap, this.typeFactory);

  @override
  Function get decoder => decode;
  Map<K, V> decode<K, V>(dynamic m) => _checked(
      m, (Map m) => fromMap(m.map((key, value) => MapEntry(Mapper.fromValue<K>(key), Mapper.fromValue<V>(value)))));
  @override
  Map encode(M self) => self.map((key, value) => MapEntry(Mapper.toValue(key), Mapper.toValue(value)));
  @override
  Function typeFactory;
}

class _PrimitiveMapper<T> with BaseMapper<T> implements Mapper<T> {
  const _PrimitiveMapper(this.decoder);

  @override
  final T Function(dynamic value) decoder;
  @override
  dynamic encode(T value) => value;
}

class _EnumMapper<T> with BaseMapper<T> implements Mapper<T> {
  _EnumMapper(this.strDecoder, this.encoder);

  @override
  Function get decoder => (dynamic v) => _checked(v, strDecoder);

  final T Function(String value) strDecoder;
  final String Function(T value) encoder;

  @override
  String encode(T self) => encoder(self);
}

class MapperException implements Exception {
  final String message;
  const MapperException(this.message);

  @override
  String toString() => 'MapperException: $message';
}

class TypeInfo {
  String type = '';
  List<TypeInfo> params = [];
  TypeInfo? parent;

  @override
  String toString() => '$type${params.isNotEmpty ? '<${params.join(', ')}>' : ''}';
}

TypeInfo getTypeInfoFor(dynamic value) {
  var info = getTypeInfo(value.runtimeType.toString());
  if (value is List) {
    return info..type = 'List';
  } else if (value is Map) {
    return info..type = 'Map';
  } else {
    return info;
  }
}

TypeInfo getTypeInfo<T>([String? type]) {
  var typeString = type ?? T.toString();
  var curr = TypeInfo();

  for (var i = 0; i < typeString.length; i++) {
    var c = typeString[i];
    if (c == '<') {
      var t = TypeInfo();
      curr.params.add(t..parent = curr);
      curr = t;
    } else if (c == '>') {
      curr = curr.parent!;
    } else if (c == ' ') {
      continue;
    } else if (c == ',') {
      var t = TypeInfo();
      curr = curr.parent!;
      curr.params.add(t..parent = curr);
      curr = t;
    } else {
      curr.type += c;
    }
  }

  return curr;
}

dynamic genericCall(TypeInfo info, Function fn, dynamic value) {
  var params = [...info.params];

  dynamic call(dynamic Function<T>() next) {
    var t = params.removeAt(0);
    if (_mappers[t.type] != null) {
      return genericCall(t, _mappers[t.type]!.typeFactory, next);
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

extension on Map<String, dynamic> {
  T get<T>(String key) {
    if (this[key] == null) {
      throw MapperException('Parameter $key is required.');
    }
    return Mapper.fromValue<T>(this[key]!);
  }

  T? getOpt<T>(String key) {
    if (this[key] == null) {
      return null;
    }
    return get<T>(key);
  }

  List<T> getList<T>(String key) {
    if (this[key] == null) {
      throw MapperException('Parameter $key is required.');
    } else if (this[key] is! List) {
      throw MapperException('Parameter ${this[key]} with key $key is not a List');
    }
    List value = this[key] as List<dynamic>;
    return value.map((dynamic item) => Mapper.fromValue<T>(item)).toList();
  }

  List<T>? getListOpt<T>(String key) {
    if (this[key] == null) {
      return null;
    }
    return getList<T>(key);
  }

  Map<K, V> getMap<K, V>(String key) {
    if (this[key] == null) {
      throw MapperException('Parameter $key is required.');
    } else if (this[key] is! Map) {
      throw MapperException('Parameter ${this[key]} with key $key is not a Map');
    }
    Map value = this[key] as Map<dynamic, dynamic>;
    return value.map((dynamic key, dynamic value) => MapEntry(Mapper.fromValue<K>(key), Mapper.fromValue<V>(value)));
  }

  Map<K, V>? getMapOpt<K, V>(String key) {
    if (this[key] == null) {
      return null;
    }
    return getMap<K, V>(key);
  }
}
