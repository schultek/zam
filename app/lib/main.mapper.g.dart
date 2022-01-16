import 'dart:convert';
import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';

import 'core/models/trip.dart';
import 'core/templates/drops_template.dart';
import 'core/templates/focus_template.dart';
import 'core/templates/grid_template.dart';
import 'core/templates/swipe_template.dart';
import 'core/templates/template_model.dart';
import 'core/themes/theme_model.dart';
import 'modules/announcement/announcement_provider.dart';
import 'modules/chat/chat_provider.dart';
import 'modules/elimination/game_provider.dart';
import 'modules/music/music_models.dart';
import 'modules/notes/notes_provider.dart';
import 'modules/photos/providers/photos_provider.dart';
import 'modules/polls/polls_provider.dart';
import 'modules/thebutton/thebutton_provider.dart';


// === ALL STATICALLY REGISTERED MAPPERS ===

var _mappers = <String, BaseMapper>{
  // primitive mappers
  _typeOf<dynamic>():  PrimitiveMapper((dynamic v) => v),
  _typeOf<String>():   PrimitiveMapper<String>((dynamic v) => v.toString()),
  _typeOf<int>():      PrimitiveMapper<int>((dynamic v) => num.parse(v.toString()).round()),
  _typeOf<double>():   PrimitiveMapper<double>((dynamic v) => double.parse(v.toString())),
  _typeOf<num>():      PrimitiveMapper<num>((dynamic v) => num.parse(v.toString())),
  _typeOf<bool>():     PrimitiveMapper<bool>((dynamic v) => v is num ? v != 0 : v.toString() == 'true'),
  _typeOf<DateTime>(): DateTimeMapper(),
  _typeOf<List>():     IterableMapper<List>(<T>(Iterable<T> i) => i.toList(), <T>(f) => f<List<T>>()),
  _typeOf<Set>():      IterableMapper<Set>(<T>(Iterable<T> i) => i.toSet(), <T>(f) => f<Set<T>>()),
  _typeOf<Map>():      MapMapper<Map>(<K, V>(Map<K, V> map) => map, <K, V>(f) => f<Map<K, V>>()),
  // class mappers
  _typeOf<Trip>(): TripMapper._(),
  _typeOf<TripUser>(): TripUserMapper._(),
  _typeOf<ThemeModel>(): ThemeModelMapper._(),
  _typeOf<FocusTemplateModel>(): FocusTemplateModelMapper._(),
  _typeOf<TemplateModel>(): TemplateModelMapper._(),
  _typeOf<DropModel>(): DropModelMapper._(),
  _typeOf<IdProvider>(): IdProviderMapper._(),
  _typeOf<DropsTemplateModel>(): DropsTemplateModelMapper._(),
  _typeOf<GridTemplateModel>(): GridTemplateModelMapper._(),
  _typeOf<SwipeTemplateModel>(): SwipeTemplateModelMapper._(),
  _typeOf<EliminationGame>(): EliminationGameMapper._(),
  _typeOf<EliminationEntry>(): EliminationEntryMapper._(),
  _typeOf<Poll>(): PollMapper._(),
  _typeOf<PollStep>(): PollStepMapper._(),
  _typeOf<MultipleChoiceQuestion>(): MultipleChoiceQuestionMapper._(),
  _typeOf<Note>(): NoteMapper._(),
  _typeOf<TheButtonState>(): TheButtonStateMapper._(),
  _typeOf<Announcement>(): AnnouncementMapper._(),
  _typeOf<AlbumShortcut>(): AlbumShortcutMapper._(),
  _typeOf<ChannelInfo>(): ChannelInfoMapper._(),
  _typeOf<ChatMessage>(): ChatMessageMapper._(),
  _typeOf<ChatTextMessage>(): ChatTextMessageMapper._(),
  _typeOf<ChatImageMessage>(): ChatImageMessageMapper._(),
  _typeOf<ChatFileMessage>(): ChatFileMessageMapper._(),
  _typeOf<MusicConfig>(): MusicConfigMapper._(),
  _typeOf<SpotifyPlayer>(): SpotifyPlayerMapper._(),
  _typeOf<SpotifyCredentials>(): SpotifyCredentialsMapper._(),
  _typeOf<SpotifyPlaylist>(): SpotifyPlaylistMapper._(),
  _typeOf<SpotifyTrack>(): SpotifyTrackMapper._(),
  _typeOf<SpotifyAlbum>(): SpotifyAlbumMapper._(),
  _typeOf<SpotifyImage>(): SpotifyImageMapper._(),
  _typeOf<SpotifyArtist>(): SpotifyArtistMapper._(),
  // enum mappers
  // custom mappers
  _typeOf<Color>(): ColorMapper(),
};


// === GENERATED CLASS MAPPERS AND EXTENSIONS ===

class TripMapper extends BaseMapper<Trip> {
  TripMapper._();

  @override Function get decoder => decode;
  Trip decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  Trip fromMap(Map<String, dynamic> map) => Trip(id: map.get('id'), name: map.get('name'), pictureUrl: map.getOpt('pictureUrl'), template: map.get('template'), theme: map.get('theme'), users: map.getMapOpt('users') ?? const {}, modules: map.getMapOpt('modules') ?? const {}, moduleBlacklist: map.getListOpt('moduleBlacklist') ?? const []);

  @override Function get encoder => (Trip v) => encode(v);
  dynamic encode(Trip v) => toMap(v);
  Map<String, dynamic> toMap(Trip t) => {'id': Mapper.toValue(t.id), 'name': Mapper.toValue(t.name), 'pictureUrl': Mapper.toValue(t.pictureUrl), 'template': Mapper.toValue(t.template), 'theme': Mapper.toValue(t.theme), 'users': Mapper.toValue(t.users), 'modules': Mapper.toValue(t.modules), 'moduleBlacklist': Mapper.toValue(t.moduleBlacklist)};

  @override String? stringify(Trip self) => 'Trip(name: ${Mapper.asString(self.name)}, id: ${Mapper.asString(self.id)}, pictureUrl: ${Mapper.asString(self.pictureUrl)}, template: ${Mapper.asString(self.template)}, theme: ${Mapper.asString(self.theme)}, users: ${Mapper.asString(self.users)}, modules: ${Mapper.asString(self.modules)}, moduleBlacklist: ${Mapper.asString(self.moduleBlacklist)})';
  @override int? hash(Trip self) => Mapper.hash(self.id) ^ Mapper.hash(self.name) ^ Mapper.hash(self.pictureUrl) ^ Mapper.hash(self.template) ^ Mapper.hash(self.theme) ^ Mapper.hash(self.users) ^ Mapper.hash(self.modules) ^ Mapper.hash(self.moduleBlacklist);
  @override bool? equals(Trip self, Trip other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.pictureUrl, other.pictureUrl) && Mapper.isEqual(self.template, other.template) && Mapper.isEqual(self.theme, other.theme) && Mapper.isEqual(self.users, other.users) && Mapper.isEqual(self.modules, other.modules) && Mapper.isEqual(self.moduleBlacklist, other.moduleBlacklist);

  @override Function get typeFactory => (f) => f<Trip>();
}

extension TripMapperExtension on Trip {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  TripCopyWith<Trip> get copyWith => TripCopyWith(this, _$identity);
}

abstract class TripCopyWith<$R> {
  factory TripCopyWith(Trip value, Then<Trip, $R> then) = _TripCopyWithImpl<$R>;
  ThemeModelCopyWith<$R> get theme;
  $R call({String? id, String? name, String? pictureUrl, TemplateModel? template, ThemeModel? theme, Map<String, TripUser>? users, Map<String, List<String>>? modules, List<String>? moduleBlacklist});
}

class _TripCopyWithImpl<$R> extends BaseCopyWith<Trip, $R> implements TripCopyWith<$R> {
  _TripCopyWithImpl(Trip value, Then<Trip, $R> then) : super(value, then);

  @override ThemeModelCopyWith<$R> get theme => ThemeModelCopyWith(_value.theme, (v) => call(theme: v));
  @override $R call({String? id, String? name, Object? pictureUrl = _none, TemplateModel? template, ThemeModel? theme, Map<String, TripUser>? users, Map<String, List<String>>? modules, List<String>? moduleBlacklist}) => _then(Trip(id: id ?? _value.id, name: name ?? _value.name, pictureUrl: or(pictureUrl, _value.pictureUrl), template: template ?? _value.template, theme: theme ?? _value.theme, users: users ?? _value.users, modules: modules ?? _value.modules, moduleBlacklist: moduleBlacklist ?? _value.moduleBlacklist));
}

class TripUserMapper extends BaseMapper<TripUser> {
  TripUserMapper._();

  @override Function get decoder => decode;
  TripUser decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  TripUser fromMap(Map<String, dynamic> map) => TripUser(role: map.getOpt('role') ?? UserRoles.participant, nickname: map.getOpt('nickname'), profileUrl: map.getOpt('profileUrl'));

  @override Function get encoder => (TripUser v) => encode(v);
  dynamic encode(TripUser v) => toMap(v);
  Map<String, dynamic> toMap(TripUser t) => {'role': Mapper.toValue(t.role), 'nickname': Mapper.toValue(t.nickname), 'profileUrl': Mapper.toValue(t.profileUrl)};

  @override String? stringify(TripUser self) => 'TripUser(role: ${Mapper.asString(self.role)}, nickname: ${Mapper.asString(self.nickname)}, profileUrl: ${Mapper.asString(self.profileUrl)})';
  @override int? hash(TripUser self) => Mapper.hash(self.role) ^ Mapper.hash(self.nickname) ^ Mapper.hash(self.profileUrl);
  @override bool? equals(TripUser self, TripUser other) => Mapper.isEqual(self.role, other.role) && Mapper.isEqual(self.nickname, other.nickname) && Mapper.isEqual(self.profileUrl, other.profileUrl);

  @override Function get typeFactory => (f) => f<TripUser>();
}

extension TripUserMapperExtension on TripUser {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  TripUserCopyWith<TripUser> get copyWith => TripUserCopyWith(this, _$identity);
}

abstract class TripUserCopyWith<$R> {
  factory TripUserCopyWith(TripUser value, Then<TripUser, $R> then) = _TripUserCopyWithImpl<$R>;
  $R call({String? role, String? nickname, String? profileUrl});
}

class _TripUserCopyWithImpl<$R> extends BaseCopyWith<TripUser, $R> implements TripUserCopyWith<$R> {
  _TripUserCopyWithImpl(TripUser value, Then<TripUser, $R> then) : super(value, then);

  @override $R call({String? role, Object? nickname = _none, Object? profileUrl = _none}) => _then(TripUser(role: role ?? _value.role, nickname: or(nickname, _value.nickname), profileUrl: or(profileUrl, _value.profileUrl)));
}

class ThemeModelMapper extends BaseMapper<ThemeModel> {
  ThemeModelMapper._();

  @override Function get decoder => decode;
  ThemeModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  ThemeModel fromMap(Map<String, dynamic> map) => ThemeModel(schemeIndex: map.get('schemeIndex'), dark: map.getOpt('dark') ?? false);

  @override Function get encoder => (ThemeModel v) => encode(v);
  dynamic encode(ThemeModel v) => toMap(v);
  Map<String, dynamic> toMap(ThemeModel t) => {'schemeIndex': Mapper.toValue(t.schemeIndex), 'dark': Mapper.toValue(t.dark)};

  @override String? stringify(ThemeModel self) => 'ThemeModel(schemeIndex: ${Mapper.asString(self.schemeIndex)}, dark: ${Mapper.asString(self.dark)})';
  @override int? hash(ThemeModel self) => Mapper.hash(self.schemeIndex) ^ Mapper.hash(self.dark);
  @override bool? equals(ThemeModel self, ThemeModel other) => Mapper.isEqual(self.schemeIndex, other.schemeIndex) && Mapper.isEqual(self.dark, other.dark);

  @override Function get typeFactory => (f) => f<ThemeModel>();
}

extension ThemeModelMapperExtension on ThemeModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ThemeModelCopyWith<ThemeModel> get copyWith => ThemeModelCopyWith(this, _$identity);
}

abstract class ThemeModelCopyWith<$R> {
  factory ThemeModelCopyWith(ThemeModel value, Then<ThemeModel, $R> then) = _ThemeModelCopyWithImpl<$R>;
  $R call({int? schemeIndex, bool? dark});
}

class _ThemeModelCopyWithImpl<$R> extends BaseCopyWith<ThemeModel, $R> implements ThemeModelCopyWith<$R> {
  _ThemeModelCopyWithImpl(ThemeModel value, Then<ThemeModel, $R> then) : super(value, then);

  @override $R call({int? schemeIndex, bool? dark}) => _then(ThemeModel(schemeIndex: schemeIndex ?? _value.schemeIndex, dark: dark ?? _value.dark));
}

class FocusTemplateModelMapper extends BaseMapper<FocusTemplateModel> {
  FocusTemplateModelMapper._();

  @override Function get decoder => decode;
  FocusTemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  FocusTemplateModel fromMap(Map<String, dynamic> map) => FocusTemplateModel(type: map.getOpt('type'));

  @override Function get encoder => (FocusTemplateModel v) => encode(v);
  dynamic encode(FocusTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(FocusTemplateModel f) => {'type': Mapper.toValue(f.type)};

  @override String? stringify(FocusTemplateModel self) => 'FocusTemplateModel(type: ${Mapper.asString(self.type)})';
  @override int? hash(FocusTemplateModel self) => Mapper.hash(self.type);
  @override bool? equals(FocusTemplateModel self, FocusTemplateModel other) => Mapper.isEqual(self.type, other.type);

  @override Function get typeFactory => (f) => f<FocusTemplateModel>();
}

extension FocusTemplateModelMapperExtension on FocusTemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  FocusTemplateModelCopyWith<FocusTemplateModel> get copyWith => FocusTemplateModelCopyWith(this, _$identity);
}

abstract class FocusTemplateModelCopyWith<$R> {
  factory FocusTemplateModelCopyWith(FocusTemplateModel value, Then<FocusTemplateModel, $R> then) = _FocusTemplateModelCopyWithImpl<$R>;
  $R call({String? type});
}

class _FocusTemplateModelCopyWithImpl<$R> extends BaseCopyWith<FocusTemplateModel, $R> implements FocusTemplateModelCopyWith<$R> {
  _FocusTemplateModelCopyWithImpl(FocusTemplateModel value, Then<FocusTemplateModel, $R> then) : super(value, then);

  @override $R call({Object? type = _none}) => _then(FocusTemplateModel(type: or(type, _value.type)));
}

class TemplateModelMapper extends BaseMapper<TemplateModel> {
  TemplateModelMapper._();

  @override Function get decoder => decode;
  TemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) {
    switch(map['type']) {
      case 'drops': return DropsTemplateModelMapper._().decode(map);
      case 'focus': return FocusTemplateModelMapper._().decode(map);
      case 'grid': return GridTemplateModelMapper._().decode(map);
      case 'swipe': return SwipeTemplateModelMapper._().decode(map);
      default: return fromMap(map);
    }
  });
  TemplateModel fromMap(Map<String, dynamic> map) => throw MapperException("Cannot instantiate class TemplateModel, did you forgot to specify a subclass for [ type: '${map['type']}' ] or a default subclass?");

  @override Function get encoder => (TemplateModel v) => encode(v);
  dynamic encode(TemplateModel v) {
    if (v is FocusTemplateModel) { return FocusTemplateModelMapper._().encode(v); }
    else if (v is DropsTemplateModel) { return DropsTemplateModelMapper._().encode(v); }
    else if (v is GridTemplateModel) { return GridTemplateModelMapper._().encode(v); }
    else if (v is SwipeTemplateModel) { return SwipeTemplateModelMapper._().encode(v); }
    else { return toMap(v); }
  }
  Map<String, dynamic> toMap(TemplateModel t) => {'type': Mapper.toValue(t.type)};

  @override String? stringify(TemplateModel self) => 'TemplateModel(type: ${Mapper.asString(self.type)})';
  @override int? hash(TemplateModel self) => Mapper.hash(self.type);
  @override bool? equals(TemplateModel self, TemplateModel other) => Mapper.isEqual(self.type, other.type);

  @override Function get typeFactory => (f) => f<TemplateModel>();
}

extension TemplateModelMapperExtension on TemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
}

class DropModelMapper extends BaseMapper<DropModel> {
  DropModelMapper._();

  @override Function get decoder => decode;
  DropModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  DropModel fromMap(Map<String, dynamic> map) => DropModel(id: map.get('id'), label: map.getOpt('label'), isHidden: map.getOpt('isHidden') ?? false);

  @override Function get encoder => (DropModel v) => encode(v);
  dynamic encode(DropModel v) => toMap(v);
  Map<String, dynamic> toMap(DropModel d) => {'id': Mapper.toValue(d.id), 'label': Mapper.toValue(d.label), 'isHidden': Mapper.toValue(d.isHidden)};

  @override String? stringify(DropModel self) => 'DropModel(id: ${Mapper.asString(self.id)}, label: ${Mapper.asString(self.label)}, isHidden: ${Mapper.asString(self.isHidden)})';
  @override int? hash(DropModel self) => Mapper.hash(self.id) ^ Mapper.hash(self.label) ^ Mapper.hash(self.isHidden);
  @override bool? equals(DropModel self, DropModel other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.label, other.label) && Mapper.isEqual(self.isHidden, other.isHidden);

  @override Function get typeFactory => (f) => f<DropModel>();
}

extension DropModelMapperExtension on DropModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  DropModelCopyWith<DropModel> get copyWith => DropModelCopyWith(this, _$identity);
}

abstract class DropModelCopyWith<$R> {
  factory DropModelCopyWith(DropModel value, Then<DropModel, $R> then) = _DropModelCopyWithImpl<$R>;
  $R call({String? id, String? label, bool? isHidden});
}

class _DropModelCopyWithImpl<$R> extends BaseCopyWith<DropModel, $R> implements DropModelCopyWith<$R> {
  _DropModelCopyWithImpl(DropModel value, Then<DropModel, $R> then) : super(value, then);

  @override $R call({String? id, Object? label = _none, bool? isHidden}) => _then(DropModel(id: id ?? _value.id, label: or(label, _value.label), isHidden: isHidden ?? _value.isHidden));
}

class IdProviderMapper extends BaseMapper<IdProvider> {
  IdProviderMapper._();

  @override Function get decoder => decode;
  IdProvider decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  IdProvider fromMap(Map<String, dynamic> map) => IdProvider();

  @override Function get encoder => (IdProvider v) => encode(v);
  dynamic encode(IdProvider v) {
    if (v is DropModel) { return DropModelMapper._().encode(v); }
    else { return toMap(v); }
  }
  Map<String, dynamic> toMap(IdProvider i) => {};

  @override String? stringify(IdProvider self) => 'IdProvider()';
  @override int? hash(IdProvider self) => self.hashCode;
  @override bool? equals(IdProvider self, IdProvider other) => true;

  @override Function get typeFactory => (f) => f<IdProvider>();
}

extension IdProviderMapperExtension on IdProvider {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  IdProviderCopyWith<IdProvider> get copyWith => IdProviderCopyWith(this, _$identity);
}

abstract class IdProviderCopyWith<$R> {
  factory IdProviderCopyWith(IdProvider value, Then<IdProvider, $R> then) = _IdProviderCopyWithImpl<$R>;
  $R call();
}

class _IdProviderCopyWithImpl<$R> extends BaseCopyWith<IdProvider, $R> implements IdProviderCopyWith<$R> {
  _IdProviderCopyWithImpl(IdProvider value, Then<IdProvider, $R> then) : super(value, then);

  @override $R call() => _then(IdProvider());
}

class DropsTemplateModelMapper extends BaseMapper<DropsTemplateModel> {
  DropsTemplateModelMapper._();

  @override Function get decoder => decode;
  DropsTemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  DropsTemplateModel fromMap(Map<String, dynamic> map) => DropsTemplateModel(type: map.getOpt('type'), drops: map.getListOpt('drops') ?? const []);

  @override Function get encoder => (DropsTemplateModel v) => encode(v);
  dynamic encode(DropsTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(DropsTemplateModel d) => {'type': Mapper.toValue(d.type), 'drops': Mapper.toValue(d.drops)};

  @override String? stringify(DropsTemplateModel self) => 'DropsTemplateModel(type: ${Mapper.asString(self.type)}, drops: ${Mapper.asString(self.drops)})';
  @override int? hash(DropsTemplateModel self) => Mapper.hash(self.type) ^ Mapper.hash(self.drops);
  @override bool? equals(DropsTemplateModel self, DropsTemplateModel other) => Mapper.isEqual(self.type, other.type) && Mapper.isEqual(self.drops, other.drops);

  @override Function get typeFactory => (f) => f<DropsTemplateModel>();
}

extension DropsTemplateModelMapperExtension on DropsTemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  DropsTemplateModelCopyWith<DropsTemplateModel> get copyWith => DropsTemplateModelCopyWith(this, _$identity);
}

abstract class DropsTemplateModelCopyWith<$R> {
  factory DropsTemplateModelCopyWith(DropsTemplateModel value, Then<DropsTemplateModel, $R> then) = _DropsTemplateModelCopyWithImpl<$R>;
  ListCopyWith<$R, DropModel, DropModelCopyWith<$R>> get drops;
  $R call({String? type, List<DropModel>? drops});
}

class _DropsTemplateModelCopyWithImpl<$R> extends BaseCopyWith<DropsTemplateModel, $R> implements DropsTemplateModelCopyWith<$R> {
  _DropsTemplateModelCopyWithImpl(DropsTemplateModel value, Then<DropsTemplateModel, $R> then) : super(value, then);

  @override ListCopyWith<$R, DropModel, DropModelCopyWith<$R>> get drops => ListCopyWith(_value.drops, (v, t) => DropModelCopyWith(v, t), (v) => call(drops: v));
  @override $R call({Object? type = _none, List<DropModel>? drops}) => _then(DropsTemplateModel(type: or(type, _value.type), drops: drops ?? _value.drops));
}

class GridTemplateModelMapper extends BaseMapper<GridTemplateModel> {
  GridTemplateModelMapper._();

  @override Function get decoder => decode;
  GridTemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  GridTemplateModel fromMap(Map<String, dynamic> map) => GridTemplateModel(type: map.getOpt('type'));

  @override Function get encoder => (GridTemplateModel v) => encode(v);
  dynamic encode(GridTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(GridTemplateModel g) => {'type': Mapper.toValue(g.type)};

  @override String? stringify(GridTemplateModel self) => 'GridTemplateModel(type: ${Mapper.asString(self.type)})';
  @override int? hash(GridTemplateModel self) => Mapper.hash(self.type);
  @override bool? equals(GridTemplateModel self, GridTemplateModel other) => Mapper.isEqual(self.type, other.type);

  @override Function get typeFactory => (f) => f<GridTemplateModel>();
}

extension GridTemplateModelMapperExtension on GridTemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  GridTemplateModelCopyWith<GridTemplateModel> get copyWith => GridTemplateModelCopyWith(this, _$identity);
}

abstract class GridTemplateModelCopyWith<$R> {
  factory GridTemplateModelCopyWith(GridTemplateModel value, Then<GridTemplateModel, $R> then) = _GridTemplateModelCopyWithImpl<$R>;
  $R call({String? type});
}

class _GridTemplateModelCopyWithImpl<$R> extends BaseCopyWith<GridTemplateModel, $R> implements GridTemplateModelCopyWith<$R> {
  _GridTemplateModelCopyWithImpl(GridTemplateModel value, Then<GridTemplateModel, $R> then) : super(value, then);

  @override $R call({Object? type = _none}) => _then(GridTemplateModel(type: or(type, _value.type)));
}

class SwipeTemplateModelMapper extends BaseMapper<SwipeTemplateModel> {
  SwipeTemplateModelMapper._();

  @override Function get decoder => decode;
  SwipeTemplateModel decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SwipeTemplateModel fromMap(Map<String, dynamic> map) => SwipeTemplateModel(type: map.getOpt('type'), showLeftPage: map.getOpt('showLeftPage') ?? true, showRightPage: map.getOpt('showRightPage') ?? true);

  @override Function get encoder => (SwipeTemplateModel v) => encode(v);
  dynamic encode(SwipeTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(SwipeTemplateModel s) => {'type': Mapper.toValue(s.type), 'showLeftPage': Mapper.toValue(s.showLeftPage), 'showRightPage': Mapper.toValue(s.showRightPage)};

  @override String? stringify(SwipeTemplateModel self) => 'SwipeTemplateModel(type: ${Mapper.asString(self.type)}, showLeftPage: ${Mapper.asString(self.showLeftPage)}, showRightPage: ${Mapper.asString(self.showRightPage)})';
  @override int? hash(SwipeTemplateModel self) => Mapper.hash(self.type) ^ Mapper.hash(self.showLeftPage) ^ Mapper.hash(self.showRightPage);
  @override bool? equals(SwipeTemplateModel self, SwipeTemplateModel other) => Mapper.isEqual(self.type, other.type) && Mapper.isEqual(self.showLeftPage, other.showLeftPage) && Mapper.isEqual(self.showRightPage, other.showRightPage);

  @override Function get typeFactory => (f) => f<SwipeTemplateModel>();
}

extension SwipeTemplateModelMapperExtension on SwipeTemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SwipeTemplateModelCopyWith<SwipeTemplateModel> get copyWith => SwipeTemplateModelCopyWith(this, _$identity);
}

abstract class SwipeTemplateModelCopyWith<$R> {
  factory SwipeTemplateModelCopyWith(SwipeTemplateModel value, Then<SwipeTemplateModel, $R> then) = _SwipeTemplateModelCopyWithImpl<$R>;
  $R call({String? type, bool? showLeftPage, bool? showRightPage});
}

class _SwipeTemplateModelCopyWithImpl<$R> extends BaseCopyWith<SwipeTemplateModel, $R> implements SwipeTemplateModelCopyWith<$R> {
  _SwipeTemplateModelCopyWithImpl(SwipeTemplateModel value, Then<SwipeTemplateModel, $R> then) : super(value, then);

  @override $R call({Object? type = _none, bool? showLeftPage, bool? showRightPage}) => _then(SwipeTemplateModel(type: or(type, _value.type), showLeftPage: showLeftPage ?? _value.showLeftPage, showRightPage: showRightPage ?? _value.showRightPage));
}

class EliminationGameMapper extends BaseMapper<EliminationGame> {
  EliminationGameMapper._();

  @override Function get decoder => decode;
  EliminationGame decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  EliminationGame fromMap(Map<String, dynamic> map) => EliminationGame(map.get('id'), map.get('name'), map.get('startedAt'), map.getMap('initialTargets'), map.getList('eliminations'));

  @override Function get encoder => (EliminationGame v) => encode(v);
  dynamic encode(EliminationGame v) => toMap(v);
  Map<String, dynamic> toMap(EliminationGame e) => {'id': Mapper.toValue(e.id), 'name': Mapper.toValue(e.name), 'startedAt': Mapper.toValue(e.startedAt), 'initialTargets': Mapper.toValue(e.initialTargets), 'eliminations': Mapper.toValue(e.eliminations)};

  @override String? stringify(EliminationGame self) => 'EliminationGame(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)}, startedAt: ${Mapper.asString(self.startedAt)}, initialTargets: ${Mapper.asString(self.initialTargets)}, eliminations: ${Mapper.asString(self.eliminations)})';
  @override int? hash(EliminationGame self) => Mapper.hash(self.id) ^ Mapper.hash(self.name) ^ Mapper.hash(self.startedAt) ^ Mapper.hash(self.initialTargets) ^ Mapper.hash(self.eliminations);
  @override bool? equals(EliminationGame self, EliminationGame other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.startedAt, other.startedAt) && Mapper.isEqual(self.initialTargets, other.initialTargets) && Mapper.isEqual(self.eliminations, other.eliminations);

  @override Function get typeFactory => (f) => f<EliminationGame>();
}

extension EliminationGameMapperExtension on EliminationGame {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  EliminationGameCopyWith<EliminationGame> get copyWith => EliminationGameCopyWith(this, _$identity);
}

abstract class EliminationGameCopyWith<$R> {
  factory EliminationGameCopyWith(EliminationGame value, Then<EliminationGame, $R> then) = _EliminationGameCopyWithImpl<$R>;
  ListCopyWith<$R, EliminationEntry, EliminationEntryCopyWith<$R>> get eliminations;
  $R call({String? id, String? name, DateTime? startedAt, Map<String, String>? initialTargets, List<EliminationEntry>? eliminations});
}

class _EliminationGameCopyWithImpl<$R> extends BaseCopyWith<EliminationGame, $R> implements EliminationGameCopyWith<$R> {
  _EliminationGameCopyWithImpl(EliminationGame value, Then<EliminationGame, $R> then) : super(value, then);

  @override ListCopyWith<$R, EliminationEntry, EliminationEntryCopyWith<$R>> get eliminations => ListCopyWith(_value.eliminations, (v, t) => EliminationEntryCopyWith(v, t), (v) => call(eliminations: v));
  @override $R call({String? id, String? name, DateTime? startedAt, Map<String, String>? initialTargets, List<EliminationEntry>? eliminations}) => _then(EliminationGame(id ?? _value.id, name ?? _value.name, startedAt ?? _value.startedAt, initialTargets ?? _value.initialTargets, eliminations ?? _value.eliminations));
}

class EliminationEntryMapper extends BaseMapper<EliminationEntry> {
  EliminationEntryMapper._();

  @override Function get decoder => decode;
  EliminationEntry decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  EliminationEntry fromMap(Map<String, dynamic> map) => EliminationEntry(map.get('target'), map.get('eliminatedBy'), map.get('description'), map.get('time'));

  @override Function get encoder => (EliminationEntry v) => encode(v);
  dynamic encode(EliminationEntry v) => toMap(v);
  Map<String, dynamic> toMap(EliminationEntry e) => {'target': Mapper.toValue(e.target), 'eliminatedBy': Mapper.toValue(e.eliminatedBy), 'description': Mapper.toValue(e.description), 'time': Mapper.toValue(e.time)};

  @override String? stringify(EliminationEntry self) => 'EliminationEntry(target: ${Mapper.asString(self.target)}, eliminatedBy: ${Mapper.asString(self.eliminatedBy)}, description: ${Mapper.asString(self.description)}, time: ${Mapper.asString(self.time)})';
  @override int? hash(EliminationEntry self) => Mapper.hash(self.target) ^ Mapper.hash(self.eliminatedBy) ^ Mapper.hash(self.description) ^ Mapper.hash(self.time);
  @override bool? equals(EliminationEntry self, EliminationEntry other) => Mapper.isEqual(self.target, other.target) && Mapper.isEqual(self.eliminatedBy, other.eliminatedBy) && Mapper.isEqual(self.description, other.description) && Mapper.isEqual(self.time, other.time);

  @override Function get typeFactory => (f) => f<EliminationEntry>();
}

extension EliminationEntryMapperExtension on EliminationEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  EliminationEntryCopyWith<EliminationEntry> get copyWith => EliminationEntryCopyWith(this, _$identity);
}

abstract class EliminationEntryCopyWith<$R> {
  factory EliminationEntryCopyWith(EliminationEntry value, Then<EliminationEntry, $R> then) = _EliminationEntryCopyWithImpl<$R>;
  $R call({String? target, String? eliminatedBy, String? description, DateTime? time});
}

class _EliminationEntryCopyWithImpl<$R> extends BaseCopyWith<EliminationEntry, $R> implements EliminationEntryCopyWith<$R> {
  _EliminationEntryCopyWithImpl(EliminationEntry value, Then<EliminationEntry, $R> then) : super(value, then);

  @override $R call({String? target, String? eliminatedBy, String? description, DateTime? time}) => _then(EliminationEntry(target ?? _value.target, eliminatedBy ?? _value.eliminatedBy, description ?? _value.description, time ?? _value.time));
}

class PollMapper extends BaseMapper<Poll> {
  PollMapper._();

  @override Function get decoder => decode;
  Poll decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  Poll fromMap(Map<String, dynamic> map) => Poll(map.get('id'), map.get('name'), map.get('startedAt'), map.getList('steps'));

  @override Function get encoder => (Poll v) => encode(v);
  dynamic encode(Poll v) => toMap(v);
  Map<String, dynamic> toMap(Poll p) => {'id': Mapper.toValue(p.id), 'name': Mapper.toValue(p.name), 'startedAt': Mapper.toValue(p.startedAt), 'steps': Mapper.toValue(p.steps)};

  @override String? stringify(Poll self) => 'Poll(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)}, startedAt: ${Mapper.asString(self.startedAt)}, steps: ${Mapper.asString(self.steps)})';
  @override int? hash(Poll self) => Mapper.hash(self.id) ^ Mapper.hash(self.name) ^ Mapper.hash(self.startedAt) ^ Mapper.hash(self.steps);
  @override bool? equals(Poll self, Poll other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.startedAt, other.startedAt) && Mapper.isEqual(self.steps, other.steps);

  @override Function get typeFactory => (f) => f<Poll>();
}

extension PollMapperExtension on Poll {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  PollCopyWith<Poll> get copyWith => PollCopyWith(this, _$identity);
}

abstract class PollCopyWith<$R> {
  factory PollCopyWith(Poll value, Then<Poll, $R> then) = _PollCopyWithImpl<$R>;
  ListCopyWith<$R, PollStep, PollStepCopyWith<$R>> get steps;
  $R call({String? id, String? name, DateTime? startedAt, List<PollStep>? steps});
}

class _PollCopyWithImpl<$R> extends BaseCopyWith<Poll, $R> implements PollCopyWith<$R> {
  _PollCopyWithImpl(Poll value, Then<Poll, $R> then) : super(value, then);

  @override ListCopyWith<$R, PollStep, PollStepCopyWith<$R>> get steps => ListCopyWith(_value.steps, (v, t) => PollStepCopyWith(v, t), (v) => call(steps: v));
  @override $R call({String? id, String? name, DateTime? startedAt, List<PollStep>? steps}) => _then(Poll(id ?? _value.id, name ?? _value.name, startedAt ?? _value.startedAt, steps ?? _value.steps));
}

class PollStepMapper extends BaseMapper<PollStep> {
  PollStepMapper._();

  @override Function get decoder => decode;
  PollStep decode(dynamic v) => _checked(v, (Map<String, dynamic> map) {
    switch(map['type']) {
      case 'multiple-choice': return MultipleChoiceQuestionMapper._().decode(map);
      default: return fromMap(map);
    }
  });
  PollStep fromMap(Map<String, dynamic> map) => PollStep(map.get('type'));

  @override Function get encoder => (PollStep v) => encode(v);
  dynamic encode(PollStep v) {
    if (v is MultipleChoiceQuestion) { return MultipleChoiceQuestionMapper._().encode(v); }
    else { return toMap(v); }
  }
  Map<String, dynamic> toMap(PollStep p) => {'type': Mapper.toValue(p.type)};

  @override String? stringify(PollStep self) => 'PollStep(type: ${Mapper.asString(self.type)})';
  @override int? hash(PollStep self) => Mapper.hash(self.type);
  @override bool? equals(PollStep self, PollStep other) => Mapper.isEqual(self.type, other.type);

  @override Function get typeFactory => (f) => f<PollStep>();
}

extension PollStepMapperExtension on PollStep {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  PollStepCopyWith<PollStep> get copyWith => PollStepCopyWith(this, _$identity);
}

abstract class PollStepCopyWith<$R> {
  factory PollStepCopyWith(PollStep value, Then<PollStep, $R> then) = _PollStepCopyWithImpl<$R>;
  $R call({String? type});
}

class _PollStepCopyWithImpl<$R> extends BaseCopyWith<PollStep, $R> implements PollStepCopyWith<$R> {
  _PollStepCopyWithImpl(PollStep value, Then<PollStep, $R> then) : super(value, then);

  @override $R call({String? type}) => _then(PollStep(type ?? _value.type));
}

class MultipleChoiceQuestionMapper extends BaseMapper<MultipleChoiceQuestion> {
  MultipleChoiceQuestionMapper._();

  @override Function get decoder => decode;
  MultipleChoiceQuestion decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  MultipleChoiceQuestion fromMap(Map<String, dynamic> map) => MultipleChoiceQuestion(map.getList('choices'), map.get('multiselect'), map.get('type'));

  @override Function get encoder => (MultipleChoiceQuestion v) => encode(v);
  dynamic encode(MultipleChoiceQuestion v) => toMap(v);
  Map<String, dynamic> toMap(MultipleChoiceQuestion m) => {'choices': Mapper.toValue(m.choices), 'multiselect': Mapper.toValue(m.multiselect), 'type': Mapper.toValue(m.type)};

  @override String? stringify(MultipleChoiceQuestion self) => 'MultipleChoiceQuestion(type: ${Mapper.asString(self.type)}, choices: ${Mapper.asString(self.choices)}, multiselect: ${Mapper.asString(self.multiselect)})';
  @override int? hash(MultipleChoiceQuestion self) => Mapper.hash(self.choices) ^ Mapper.hash(self.multiselect) ^ Mapper.hash(self.type);
  @override bool? equals(MultipleChoiceQuestion self, MultipleChoiceQuestion other) => Mapper.isEqual(self.choices, other.choices) && Mapper.isEqual(self.multiselect, other.multiselect) && Mapper.isEqual(self.type, other.type);

  @override Function get typeFactory => (f) => f<MultipleChoiceQuestion>();
}

extension MultipleChoiceQuestionMapperExtension on MultipleChoiceQuestion {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  MultipleChoiceQuestionCopyWith<MultipleChoiceQuestion> get copyWith => MultipleChoiceQuestionCopyWith(this, _$identity);
}

abstract class MultipleChoiceQuestionCopyWith<$R> {
  factory MultipleChoiceQuestionCopyWith(MultipleChoiceQuestion value, Then<MultipleChoiceQuestion, $R> then) = _MultipleChoiceQuestionCopyWithImpl<$R>;
  $R call({List<String>? choices, bool? multiselect, String? type});
}

class _MultipleChoiceQuestionCopyWithImpl<$R> extends BaseCopyWith<MultipleChoiceQuestion, $R> implements MultipleChoiceQuestionCopyWith<$R> {
  _MultipleChoiceQuestionCopyWithImpl(MultipleChoiceQuestion value, Then<MultipleChoiceQuestion, $R> then) : super(value, then);

  @override $R call({List<String>? choices, bool? multiselect, String? type}) => _then(MultipleChoiceQuestion(choices ?? _value.choices, multiselect ?? _value.multiselect, type ?? _value.type));
}

class NoteMapper extends BaseMapper<Note> {
  NoteMapper._();

  @override Function get decoder => decode;
  Note decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  Note fromMap(Map<String, dynamic> map) => Note(map.get('id'), map.getOpt('title'), map.getList('content'), folder: map.getOpt('folder'), isArchived: map.getOpt('isArchived') ?? false, author: map.get('author'), editors: map.getListOpt('editors') ?? const []);

  @override Function get encoder => (Note v) => encode(v);
  dynamic encode(Note v) => toMap(v);
  Map<String, dynamic> toMap(Note n) => {'id': Mapper.toValue(n.id), 'title': Mapper.toValue(n.title), 'content': Mapper.toValue(n.content), 'folder': Mapper.toValue(n.folder), 'isArchived': Mapper.toValue(n.isArchived), 'author': Mapper.toValue(n.author), 'editors': Mapper.toValue(n.editors)};

  @override String? stringify(Note self) => 'Note(id: ${Mapper.asString(self.id)}, title: ${Mapper.asString(self.title)}, content: ${Mapper.asString(self.content)}, folder: ${Mapper.asString(self.folder)}, isArchived: ${Mapper.asString(self.isArchived)}, author: ${Mapper.asString(self.author)}, editors: ${Mapper.asString(self.editors)})';
  @override int? hash(Note self) => Mapper.hash(self.id) ^ Mapper.hash(self.title) ^ Mapper.hash(self.content) ^ Mapper.hash(self.folder) ^ Mapper.hash(self.isArchived) ^ Mapper.hash(self.author) ^ Mapper.hash(self.editors);
  @override bool? equals(Note self, Note other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.title, other.title) && Mapper.isEqual(self.content, other.content) && Mapper.isEqual(self.folder, other.folder) && Mapper.isEqual(self.isArchived, other.isArchived) && Mapper.isEqual(self.author, other.author) && Mapper.isEqual(self.editors, other.editors);

  @override Function get typeFactory => (f) => f<Note>();
}

extension NoteMapperExtension on Note {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  NoteCopyWith<Note> get copyWith => NoteCopyWith(this, _$identity);
}

abstract class NoteCopyWith<$R> {
  factory NoteCopyWith(Note value, Then<Note, $R> then) = _NoteCopyWithImpl<$R>;
  $R call({String? id, String? title, List<dynamic>? content, String? folder, bool? isArchived, String? author, List<String>? editors});
}

class _NoteCopyWithImpl<$R> extends BaseCopyWith<Note, $R> implements NoteCopyWith<$R> {
  _NoteCopyWithImpl(Note value, Then<Note, $R> then) : super(value, then);

  @override $R call({String? id, Object? title = _none, List<dynamic>? content, Object? folder = _none, bool? isArchived, String? author, List<String>? editors}) => _then(Note(id ?? _value.id, or(title, _value.title), content ?? _value.content, folder: or(folder, _value.folder), isArchived: isArchived ?? _value.isArchived, author: author ?? _value.author, editors: editors ?? _value.editors));
}

class TheButtonStateMapper extends BaseMapper<TheButtonState> {
  TheButtonStateMapper._();

  @override Function get decoder => decode;
  TheButtonState decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  TheButtonState fromMap(Map<String, dynamic> map) => TheButtonState(map.get('lastReset'), map.get('aliveHours'), map.getMap('leaderboard'), showInAvatars: map.getOpt('showInAvatars') ?? false);

  @override Function get encoder => (TheButtonState v) => encode(v);
  dynamic encode(TheButtonState v) => toMap(v);
  Map<String, dynamic> toMap(TheButtonState t) => {'lastReset': Mapper.toValue(t.lastReset), 'aliveHours': Mapper.toValue(t.aliveHours), 'leaderboard': Mapper.toValue(t.leaderboard), 'showInAvatars': Mapper.toValue(t.showInAvatars)};

  @override String? stringify(TheButtonState self) => 'TheButtonState(lastReset: ${Mapper.asString(self.lastReset)}, aliveHours: ${Mapper.asString(self.aliveHours)}, leaderboard: ${Mapper.asString(self.leaderboard)}, showInAvatars: ${Mapper.asString(self.showInAvatars)})';
  @override int? hash(TheButtonState self) => Mapper.hash(self.lastReset) ^ Mapper.hash(self.aliveHours) ^ Mapper.hash(self.leaderboard) ^ Mapper.hash(self.showInAvatars);
  @override bool? equals(TheButtonState self, TheButtonState other) => Mapper.isEqual(self.lastReset, other.lastReset) && Mapper.isEqual(self.aliveHours, other.aliveHours) && Mapper.isEqual(self.leaderboard, other.leaderboard) && Mapper.isEqual(self.showInAvatars, other.showInAvatars);

  @override Function get typeFactory => (f) => f<TheButtonState>();
}

extension TheButtonStateMapperExtension on TheButtonState {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  TheButtonStateCopyWith<TheButtonState> get copyWith => TheButtonStateCopyWith(this, _$identity);
}

abstract class TheButtonStateCopyWith<$R> {
  factory TheButtonStateCopyWith(TheButtonState value, Then<TheButtonState, $R> then) = _TheButtonStateCopyWithImpl<$R>;
  $R call({Timestamp? lastReset, double? aliveHours, Map<String, int>? leaderboard, bool? showInAvatars});
}

class _TheButtonStateCopyWithImpl<$R> extends BaseCopyWith<TheButtonState, $R> implements TheButtonStateCopyWith<$R> {
  _TheButtonStateCopyWithImpl(TheButtonState value, Then<TheButtonState, $R> then) : super(value, then);

  @override $R call({Timestamp? lastReset, double? aliveHours, Map<String, int>? leaderboard, bool? showInAvatars}) => _then(TheButtonState(lastReset ?? _value.lastReset, aliveHours ?? _value.aliveHours, leaderboard ?? _value.leaderboard, showInAvatars: showInAvatars ?? _value.showInAvatars));
}

class AnnouncementMapper extends BaseMapper<Announcement> {
  AnnouncementMapper._();

  @override Function get decoder => decode;
  Announcement decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  Announcement fromMap(Map<String, dynamic> map) => Announcement(title: map.getOpt('title'), message: map.get('message'), textColor: map.getOpt('textColor'), backgroundColor: map.getOpt('backgroundColor'), isDismissible: map.getOpt('isDismissible') ?? false);

  @override Function get encoder => (Announcement v) => encode(v);
  dynamic encode(Announcement v) => toMap(v);
  Map<String, dynamic> toMap(Announcement a) => {'title': Mapper.toValue(a.title), 'message': Mapper.toValue(a.message), 'textColor': Mapper.toValue(a.textColor), 'backgroundColor': Mapper.toValue(a.backgroundColor), 'isDismissible': Mapper.toValue(a.isDismissible)};

  @override String? stringify(Announcement self) => 'Announcement(title: ${Mapper.asString(self.title)}, message: ${Mapper.asString(self.message)}, textColor: ${Mapper.asString(self.textColor)}, backgroundColor: ${Mapper.asString(self.backgroundColor)}, isDismissible: ${Mapper.asString(self.isDismissible)})';
  @override int? hash(Announcement self) => Mapper.hash(self.title) ^ Mapper.hash(self.message) ^ Mapper.hash(self.textColor) ^ Mapper.hash(self.backgroundColor) ^ Mapper.hash(self.isDismissible);
  @override bool? equals(Announcement self, Announcement other) => Mapper.isEqual(self.title, other.title) && Mapper.isEqual(self.message, other.message) && Mapper.isEqual(self.textColor, other.textColor) && Mapper.isEqual(self.backgroundColor, other.backgroundColor) && Mapper.isEqual(self.isDismissible, other.isDismissible);

  @override Function get typeFactory => (f) => f<Announcement>();
}

extension AnnouncementMapperExtension on Announcement {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  AnnouncementCopyWith<Announcement> get copyWith => AnnouncementCopyWith(this, _$identity);
}

abstract class AnnouncementCopyWith<$R> {
  factory AnnouncementCopyWith(Announcement value, Then<Announcement, $R> then) = _AnnouncementCopyWithImpl<$R>;
  $R call({String? title, String? message, Color? textColor, Color? backgroundColor, bool? isDismissible});
}

class _AnnouncementCopyWithImpl<$R> extends BaseCopyWith<Announcement, $R> implements AnnouncementCopyWith<$R> {
  _AnnouncementCopyWithImpl(Announcement value, Then<Announcement, $R> then) : super(value, then);

  @override $R call({Object? title = _none, String? message, Object? textColor = _none, Object? backgroundColor = _none, bool? isDismissible}) => _then(Announcement(title: or(title, _value.title), message: message ?? _value.message, textColor: or(textColor, _value.textColor), backgroundColor: or(backgroundColor, _value.backgroundColor), isDismissible: isDismissible ?? _value.isDismissible));
}

class AlbumShortcutMapper extends BaseMapper<AlbumShortcut> {
  AlbumShortcutMapper._();

  @override Function get decoder => decode;
  AlbumShortcut decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  AlbumShortcut fromMap(Map<String, dynamic> map) => AlbumShortcut(map.get('id'), map.getOpt('title'), map.get('albumUrl'), map.get('coverUrl'), map.getOpt('itemsCount'));

  @override Function get encoder => (AlbumShortcut v) => encode(v);
  dynamic encode(AlbumShortcut v) => toMap(v);
  Map<String, dynamic> toMap(AlbumShortcut a) => {'id': Mapper.toValue(a.id), 'title': Mapper.toValue(a.title), 'albumUrl': Mapper.toValue(a.albumUrl), 'coverUrl': Mapper.toValue(a.coverUrl), 'itemsCount': Mapper.toValue(a.itemsCount)};

  @override String? stringify(AlbumShortcut self) => 'AlbumShortcut(id: ${Mapper.asString(self.id)}, title: ${Mapper.asString(self.title)}, albumUrl: ${Mapper.asString(self.albumUrl)}, coverUrl: ${Mapper.asString(self.coverUrl)}, itemsCount: ${Mapper.asString(self.itemsCount)})';
  @override int? hash(AlbumShortcut self) => Mapper.hash(self.id) ^ Mapper.hash(self.title) ^ Mapper.hash(self.albumUrl) ^ Mapper.hash(self.coverUrl) ^ Mapper.hash(self.itemsCount);
  @override bool? equals(AlbumShortcut self, AlbumShortcut other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.title, other.title) && Mapper.isEqual(self.albumUrl, other.albumUrl) && Mapper.isEqual(self.coverUrl, other.coverUrl) && Mapper.isEqual(self.itemsCount, other.itemsCount);

  @override Function get typeFactory => (f) => f<AlbumShortcut>();
}

extension AlbumShortcutMapperExtension on AlbumShortcut {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  AlbumShortcutCopyWith<AlbumShortcut> get copyWith => AlbumShortcutCopyWith(this, _$identity);
}

abstract class AlbumShortcutCopyWith<$R> {
  factory AlbumShortcutCopyWith(AlbumShortcut value, Then<AlbumShortcut, $R> then) = _AlbumShortcutCopyWithImpl<$R>;
  $R call({String? id, String? title, String? albumUrl, String? coverUrl, String? itemsCount});
}

class _AlbumShortcutCopyWithImpl<$R> extends BaseCopyWith<AlbumShortcut, $R> implements AlbumShortcutCopyWith<$R> {
  _AlbumShortcutCopyWithImpl(AlbumShortcut value, Then<AlbumShortcut, $R> then) : super(value, then);

  @override $R call({String? id, Object? title = _none, String? albumUrl, String? coverUrl, Object? itemsCount = _none}) => _then(AlbumShortcut(id ?? _value.id, or(title, _value.title), albumUrl ?? _value.albumUrl, coverUrl ?? _value.coverUrl, or(itemsCount, _value.itemsCount)));
}

class ChannelInfoMapper extends BaseMapper<ChannelInfo> {
  ChannelInfoMapper._();

  @override Function get decoder => decode;
  ChannelInfo decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChannelInfo fromMap(Map<String, dynamic> map) => ChannelInfo(id: map.get('id'), name: map.get('name'), isOpen: map.getOpt('isOpen') ?? true, members: map.getListOpt('members') ?? const []);

  @override Function get encoder => (ChannelInfo v) => encode(v);
  dynamic encode(ChannelInfo v) => toMap(v);
  Map<String, dynamic> toMap(ChannelInfo c) => {'id': Mapper.toValue(c.id), 'name': Mapper.toValue(c.name), 'isOpen': Mapper.toValue(c.isOpen), 'members': Mapper.toValue(c.members)};

  @override String? stringify(ChannelInfo self) => 'ChannelInfo(name: ${Mapper.asString(self.name)}, id: ${Mapper.asString(self.id)}, isOpen: ${Mapper.asString(self.isOpen)}, members: ${Mapper.asString(self.members)})';
  @override int? hash(ChannelInfo self) => Mapper.hash(self.id) ^ Mapper.hash(self.name) ^ Mapper.hash(self.isOpen) ^ Mapper.hash(self.members);
  @override bool? equals(ChannelInfo self, ChannelInfo other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.isOpen, other.isOpen) && Mapper.isEqual(self.members, other.members);

  @override Function get typeFactory => (f) => f<ChannelInfo>();
}

extension ChannelInfoMapperExtension on ChannelInfo {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChannelInfoCopyWith<ChannelInfo> get copyWith => ChannelInfoCopyWith(this, _$identity);
}

abstract class ChannelInfoCopyWith<$R> {
  factory ChannelInfoCopyWith(ChannelInfo value, Then<ChannelInfo, $R> then) = _ChannelInfoCopyWithImpl<$R>;
  $R call({String? id, String? name, bool? isOpen, List<String>? members});
}

class _ChannelInfoCopyWithImpl<$R> extends BaseCopyWith<ChannelInfo, $R> implements ChannelInfoCopyWith<$R> {
  _ChannelInfoCopyWithImpl(ChannelInfo value, Then<ChannelInfo, $R> then) : super(value, then);

  @override $R call({String? id, String? name, bool? isOpen, List<String>? members}) => _then(ChannelInfo(id: id ?? _value.id, name: name ?? _value.name, isOpen: isOpen ?? _value.isOpen, members: members ?? _value.members));
}

class ChatMessageMapper extends BaseMapper<ChatMessage> {
  ChatMessageMapper._();

  @override Function get decoder => decode;
  ChatMessage decode(dynamic v) => _checked(v, (Map<String, dynamic> map) {
    switch(map['type']) {
      case 'file': return ChatFileMessageMapper._().decode(map);
      case 'image': return ChatImageMessageMapper._().decode(map);
      case 'text': return ChatTextMessageMapper._().decode(map);
      default: return fromMap(map);
    }
  });
  ChatMessage fromMap(Map<String, dynamic> map) => ChatMessage(sender: map.get('sender'), text: map.get('text'), sentAt: map.get('sentAt'));

  @override Function get encoder => (ChatMessage v) => encode(v);
  dynamic encode(ChatMessage v) {
    if (v is ChatTextMessage) { return ChatTextMessageMapper._().encode(v); }
    else if (v is ChatImageMessage) { return ChatImageMessageMapper._().encode(v); }
    else if (v is ChatFileMessage) { return ChatFileMessageMapper._().encode(v); }
    else { return toMap(v); }
  }
  Map<String, dynamic> toMap(ChatMessage c) => {'sender': Mapper.toValue(c.sender), 'text': Mapper.toValue(c.text), 'sentAt': Mapper.toValue(c.sentAt)};

  @override String? stringify(ChatMessage self) => 'ChatMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)})';
  @override int? hash(ChatMessage self) => Mapper.hash(self.sender) ^ Mapper.hash(self.text) ^ Mapper.hash(self.sentAt);
  @override bool? equals(ChatMessage self, ChatMessage other) => Mapper.isEqual(self.sender, other.sender) && Mapper.isEqual(self.text, other.text) && Mapper.isEqual(self.sentAt, other.sentAt);

  @override Function get typeFactory => (f) => f<ChatMessage>();
}

extension ChatMessageMapperExtension on ChatMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatMessageCopyWith<ChatMessage> get copyWith => ChatMessageCopyWith(this, _$identity);
}

abstract class ChatMessageCopyWith<$R> {
  factory ChatMessageCopyWith(ChatMessage value, Then<ChatMessage, $R> then) = _ChatMessageCopyWithImpl<$R>;
  $R call({String? sender, String? text, DateTime? sentAt});
}

class _ChatMessageCopyWithImpl<$R> extends BaseCopyWith<ChatMessage, $R> implements ChatMessageCopyWith<$R> {
  _ChatMessageCopyWithImpl(ChatMessage value, Then<ChatMessage, $R> then) : super(value, then);

  @override $R call({String? sender, String? text, DateTime? sentAt}) => _then(ChatMessage(sender: sender ?? _value.sender, text: text ?? _value.text, sentAt: sentAt ?? _value.sentAt));
}

class ChatTextMessageMapper extends BaseMapper<ChatTextMessage> {
  ChatTextMessageMapper._();

  @override Function get decoder => decode;
  ChatTextMessage decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChatTextMessage fromMap(Map<String, dynamic> map) => ChatTextMessage(sender: map.get('sender'), text: map.get('text'), sentAt: map.get('sentAt'));

  @override Function get encoder => (ChatTextMessage v) => encode(v);
  dynamic encode(ChatTextMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatTextMessage c) => {'sender': Mapper.toValue(c.sender), 'text': Mapper.toValue(c.text), 'sentAt': Mapper.toValue(c.sentAt), 'type': 'text'};

  @override String? stringify(ChatTextMessage self) => 'ChatTextMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)})';
  @override int? hash(ChatTextMessage self) => Mapper.hash(self.sender) ^ Mapper.hash(self.text) ^ Mapper.hash(self.sentAt);
  @override bool? equals(ChatTextMessage self, ChatTextMessage other) => Mapper.isEqual(self.sender, other.sender) && Mapper.isEqual(self.text, other.text) && Mapper.isEqual(self.sentAt, other.sentAt);

  @override Function get typeFactory => (f) => f<ChatTextMessage>();
}

extension ChatTextMessageMapperExtension on ChatTextMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatTextMessageCopyWith<ChatTextMessage> get copyWith => ChatTextMessageCopyWith(this, _$identity);
}

abstract class ChatTextMessageCopyWith<$R> {
  factory ChatTextMessageCopyWith(ChatTextMessage value, Then<ChatTextMessage, $R> then) = _ChatTextMessageCopyWithImpl<$R>;
  $R call({String? sender, String? text, DateTime? sentAt});
}

class _ChatTextMessageCopyWithImpl<$R> extends BaseCopyWith<ChatTextMessage, $R> implements ChatTextMessageCopyWith<$R> {
  _ChatTextMessageCopyWithImpl(ChatTextMessage value, Then<ChatTextMessage, $R> then) : super(value, then);

  @override $R call({String? sender, String? text, DateTime? sentAt}) => _then(ChatTextMessage(sender: sender ?? _value.sender, text: text ?? _value.text, sentAt: sentAt ?? _value.sentAt));
}

class ChatImageMessageMapper extends BaseMapper<ChatImageMessage> {
  ChatImageMessageMapper._();

  @override Function get decoder => decode;
  ChatImageMessage decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChatImageMessage fromMap(Map<String, dynamic> map) => ChatImageMessage(uri: map.get('uri'), size: map.get('size'), sender: map.get('sender'), text: map.get('text'), sentAt: map.get('sentAt'));

  @override Function get encoder => (ChatImageMessage v) => encode(v);
  dynamic encode(ChatImageMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatImageMessage c) => {'uri': Mapper.toValue(c.uri), 'size': Mapper.toValue(c.size), 'sender': Mapper.toValue(c.sender), 'text': Mapper.toValue(c.text), 'sentAt': Mapper.toValue(c.sentAt), 'type': 'image'};

  @override String? stringify(ChatImageMessage self) => 'ChatImageMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)}, uri: ${Mapper.asString(self.uri)}, size: ${Mapper.asString(self.size)})';
  @override int? hash(ChatImageMessage self) => Mapper.hash(self.uri) ^ Mapper.hash(self.size) ^ Mapper.hash(self.sender) ^ Mapper.hash(self.text) ^ Mapper.hash(self.sentAt);
  @override bool? equals(ChatImageMessage self, ChatImageMessage other) => Mapper.isEqual(self.uri, other.uri) && Mapper.isEqual(self.size, other.size) && Mapper.isEqual(self.sender, other.sender) && Mapper.isEqual(self.text, other.text) && Mapper.isEqual(self.sentAt, other.sentAt);

  @override Function get typeFactory => (f) => f<ChatImageMessage>();
}

extension ChatImageMessageMapperExtension on ChatImageMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatImageMessageCopyWith<ChatImageMessage> get copyWith => ChatImageMessageCopyWith(this, _$identity);
}

abstract class ChatImageMessageCopyWith<$R> {
  factory ChatImageMessageCopyWith(ChatImageMessage value, Then<ChatImageMessage, $R> then) = _ChatImageMessageCopyWithImpl<$R>;
  $R call({String? uri, int? size, String? sender, String? text, DateTime? sentAt});
}

class _ChatImageMessageCopyWithImpl<$R> extends BaseCopyWith<ChatImageMessage, $R> implements ChatImageMessageCopyWith<$R> {
  _ChatImageMessageCopyWithImpl(ChatImageMessage value, Then<ChatImageMessage, $R> then) : super(value, then);

  @override $R call({String? uri, int? size, String? sender, String? text, DateTime? sentAt}) => _then(ChatImageMessage(uri: uri ?? _value.uri, size: size ?? _value.size, sender: sender ?? _value.sender, text: text ?? _value.text, sentAt: sentAt ?? _value.sentAt));
}

class ChatFileMessageMapper extends BaseMapper<ChatFileMessage> {
  ChatFileMessageMapper._();

  @override Function get decoder => decode;
  ChatFileMessage decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChatFileMessage fromMap(Map<String, dynamic> map) => ChatFileMessage(uri: map.get('uri'), size: map.get('size'), sender: map.get('sender'), text: map.get('text'), sentAt: map.get('sentAt'));

  @override Function get encoder => (ChatFileMessage v) => encode(v);
  dynamic encode(ChatFileMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatFileMessage c) => {'uri': Mapper.toValue(c.uri), 'size': Mapper.toValue(c.size), 'sender': Mapper.toValue(c.sender), 'text': Mapper.toValue(c.text), 'sentAt': Mapper.toValue(c.sentAt), 'type': 'file'};

  @override String? stringify(ChatFileMessage self) => 'ChatFileMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)}, uri: ${Mapper.asString(self.uri)}, size: ${Mapper.asString(self.size)})';
  @override int? hash(ChatFileMessage self) => Mapper.hash(self.uri) ^ Mapper.hash(self.size) ^ Mapper.hash(self.sender) ^ Mapper.hash(self.text) ^ Mapper.hash(self.sentAt);
  @override bool? equals(ChatFileMessage self, ChatFileMessage other) => Mapper.isEqual(self.uri, other.uri) && Mapper.isEqual(self.size, other.size) && Mapper.isEqual(self.sender, other.sender) && Mapper.isEqual(self.text, other.text) && Mapper.isEqual(self.sentAt, other.sentAt);

  @override Function get typeFactory => (f) => f<ChatFileMessage>();
}

extension ChatFileMessageMapperExtension on ChatFileMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatFileMessageCopyWith<ChatFileMessage> get copyWith => ChatFileMessageCopyWith(this, _$identity);
}

abstract class ChatFileMessageCopyWith<$R> {
  factory ChatFileMessageCopyWith(ChatFileMessage value, Then<ChatFileMessage, $R> then) = _ChatFileMessageCopyWithImpl<$R>;
  $R call({String? uri, int? size, String? sender, String? text, DateTime? sentAt});
}

class _ChatFileMessageCopyWithImpl<$R> extends BaseCopyWith<ChatFileMessage, $R> implements ChatFileMessageCopyWith<$R> {
  _ChatFileMessageCopyWithImpl(ChatFileMessage value, Then<ChatFileMessage, $R> then) : super(value, then);

  @override $R call({String? uri, int? size, String? sender, String? text, DateTime? sentAt}) => _then(ChatFileMessage(uri: uri ?? _value.uri, size: size ?? _value.size, sender: sender ?? _value.sender, text: text ?? _value.text, sentAt: sentAt ?? _value.sentAt));
}

class MusicConfigMapper extends BaseMapper<MusicConfig> {
  MusicConfigMapper._();

  @override Function get decoder => decode;
  MusicConfig decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  MusicConfig fromMap(Map<String, dynamic> map) => MusicConfig(credentials: map.getOpt('credentials'), player: map.getOpt('player'), playlist: map.getOpt('playlist'));

  @override Function get encoder => (MusicConfig v) => encode(v);
  dynamic encode(MusicConfig v) => toMap(v);
  Map<String, dynamic> toMap(MusicConfig m) => {'credentials': Mapper.toValue(m.credentials), 'player': Mapper.toValue(m.player), 'playlist': Mapper.toValue(m.playlist)};

  @override String? stringify(MusicConfig self) => 'MusicConfig(credentials: ${Mapper.asString(self.credentials)}, playlist: ${Mapper.asString(self.playlist)}, player: ${Mapper.asString(self.player)})';
  @override int? hash(MusicConfig self) => Mapper.hash(self.credentials) ^ Mapper.hash(self.player) ^ Mapper.hash(self.playlist);
  @override bool? equals(MusicConfig self, MusicConfig other) => Mapper.isEqual(self.credentials, other.credentials) && Mapper.isEqual(self.player, other.player) && Mapper.isEqual(self.playlist, other.playlist);

  @override Function get typeFactory => (f) => f<MusicConfig>();
}

extension MusicConfigMapperExtension on MusicConfig {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  MusicConfigCopyWith<MusicConfig> get copyWith => MusicConfigCopyWith(this, _$identity);
}

abstract class MusicConfigCopyWith<$R> {
  factory MusicConfigCopyWith(MusicConfig value, Then<MusicConfig, $R> then) = _MusicConfigCopyWithImpl<$R>;
  SpotifyCredentialsCopyWith<$R>? get credentials;
  SpotifyPlayerCopyWith<$R>? get player;
  SpotifyPlaylistCopyWith<$R>? get playlist;
  $R call({SpotifyCredentials? credentials, SpotifyPlayer? player, SpotifyPlaylist? playlist});
}

class _MusicConfigCopyWithImpl<$R> extends BaseCopyWith<MusicConfig, $R> implements MusicConfigCopyWith<$R> {
  _MusicConfigCopyWithImpl(MusicConfig value, Then<MusicConfig, $R> then) : super(value, then);

  @override SpotifyCredentialsCopyWith<$R>? get credentials => _value.credentials != null ? SpotifyCredentialsCopyWith(_value.credentials!, (v) => call(credentials: v)) : null;
  @override SpotifyPlayerCopyWith<$R>? get player => _value.player != null ? SpotifyPlayerCopyWith(_value.player!, (v) => call(player: v)) : null;
  @override SpotifyPlaylistCopyWith<$R>? get playlist => _value.playlist != null ? SpotifyPlaylistCopyWith(_value.playlist!, (v) => call(playlist: v)) : null;
  @override $R call({Object? credentials = _none, Object? player = _none, Object? playlist = _none}) => _then(MusicConfig(credentials: or(credentials, _value.credentials), player: or(player, _value.player), playlist: or(playlist, _value.playlist)));
}

class SpotifyPlayerMapper extends BaseMapper<SpotifyPlayer> {
  SpotifyPlayerMapper._();

  @override Function get decoder => decode;
  SpotifyPlayer decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyPlayer fromMap(Map<String, dynamic> map) => SpotifyPlayer(map.get('track'), map.get('isPlaying'), map.getOpt('progressMs'));

  @override Function get encoder => (SpotifyPlayer v) => encode(v);
  dynamic encode(SpotifyPlayer v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyPlayer s) => {'track': Mapper.toValue(s.track), 'isPlaying': Mapper.toValue(s.isPlaying), 'progressMs': Mapper.toValue(s.progressMs)};

  @override String? stringify(SpotifyPlayer self) => 'SpotifyPlayer(track: ${Mapper.asString(self.track)}, isPlaying: ${Mapper.asString(self.isPlaying)}, progressMs: ${Mapper.asString(self.progressMs)})';
  @override int? hash(SpotifyPlayer self) => Mapper.hash(self.track) ^ Mapper.hash(self.isPlaying) ^ Mapper.hash(self.progressMs);
  @override bool? equals(SpotifyPlayer self, SpotifyPlayer other) => Mapper.isEqual(self.track, other.track) && Mapper.isEqual(self.isPlaying, other.isPlaying) && Mapper.isEqual(self.progressMs, other.progressMs);

  @override Function get typeFactory => (f) => f<SpotifyPlayer>();
}

extension SpotifyPlayerMapperExtension on SpotifyPlayer {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyPlayerCopyWith<SpotifyPlayer> get copyWith => SpotifyPlayerCopyWith(this, _$identity);
}

abstract class SpotifyPlayerCopyWith<$R> {
  factory SpotifyPlayerCopyWith(SpotifyPlayer value, Then<SpotifyPlayer, $R> then) = _SpotifyPlayerCopyWithImpl<$R>;
  SpotifyTrackCopyWith<$R> get track;
  $R call({SpotifyTrack? track, bool? isPlaying, int? progressMs});
}

class _SpotifyPlayerCopyWithImpl<$R> extends BaseCopyWith<SpotifyPlayer, $R> implements SpotifyPlayerCopyWith<$R> {
  _SpotifyPlayerCopyWithImpl(SpotifyPlayer value, Then<SpotifyPlayer, $R> then) : super(value, then);

  @override SpotifyTrackCopyWith<$R> get track => SpotifyTrackCopyWith(_value.track, (v) => call(track: v));
  @override $R call({SpotifyTrack? track, bool? isPlaying, Object? progressMs = _none}) => _then(SpotifyPlayer(track ?? _value.track, isPlaying ?? _value.isPlaying, or(progressMs, _value.progressMs)));
}

class SpotifyCredentialsMapper extends BaseMapper<SpotifyCredentials> {
  SpotifyCredentialsMapper._();

  @override Function get decoder => decode;
  SpotifyCredentials decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyCredentials fromMap(Map<String, dynamic> map) => SpotifyCredentials(map.get('accessToken'), map.get('refreshToken'), map.get('expiration'));

  @override Function get encoder => (SpotifyCredentials v) => encode(v);
  dynamic encode(SpotifyCredentials v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyCredentials s) => {'accessToken': Mapper.toValue(s.accessToken), 'refreshToken': Mapper.toValue(s.refreshToken), 'expiration': Mapper.toValue(s.expiration)};

  @override String? stringify(SpotifyCredentials self) => 'SpotifyCredentials(accessToken: ${Mapper.asString(self.accessToken)}, refreshToken: ${Mapper.asString(self.refreshToken)}, expiration: ${Mapper.asString(self.expiration)})';
  @override int? hash(SpotifyCredentials self) => Mapper.hash(self.accessToken) ^ Mapper.hash(self.refreshToken) ^ Mapper.hash(self.expiration);
  @override bool? equals(SpotifyCredentials self, SpotifyCredentials other) => Mapper.isEqual(self.accessToken, other.accessToken) && Mapper.isEqual(self.refreshToken, other.refreshToken) && Mapper.isEqual(self.expiration, other.expiration);

  @override Function get typeFactory => (f) => f<SpotifyCredentials>();
}

extension SpotifyCredentialsMapperExtension on SpotifyCredentials {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyCredentialsCopyWith<SpotifyCredentials> get copyWith => SpotifyCredentialsCopyWith(this, _$identity);
}

abstract class SpotifyCredentialsCopyWith<$R> {
  factory SpotifyCredentialsCopyWith(SpotifyCredentials value, Then<SpotifyCredentials, $R> then) = _SpotifyCredentialsCopyWithImpl<$R>;
  $R call({String? accessToken, String? refreshToken, Timestamp? expiration});
}

class _SpotifyCredentialsCopyWithImpl<$R> extends BaseCopyWith<SpotifyCredentials, $R> implements SpotifyCredentialsCopyWith<$R> {
  _SpotifyCredentialsCopyWithImpl(SpotifyCredentials value, Then<SpotifyCredentials, $R> then) : super(value, then);

  @override $R call({String? accessToken, String? refreshToken, Timestamp? expiration}) => _then(SpotifyCredentials(accessToken ?? _value.accessToken, refreshToken ?? _value.refreshToken, expiration ?? _value.expiration));
}

class SpotifyPlaylistMapper extends BaseMapper<SpotifyPlaylist> {
  SpotifyPlaylistMapper._();

  @override Function get decoder => decode;
  SpotifyPlaylist decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyPlaylist fromMap(Map<String, dynamic> map) => SpotifyPlaylist(map.get('id'), map.get('name'), map.getList('images'), map.get('uri'), map.get('spotifyUrl'), map.getList('tracks'));

  @override Function get encoder => (SpotifyPlaylist v) => encode(v);
  dynamic encode(SpotifyPlaylist v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyPlaylist s) => {'id': Mapper.toValue(s.id), 'name': Mapper.toValue(s.name), 'images': Mapper.toValue(s.images), 'uri': Mapper.toValue(s.uri), 'spotifyUrl': Mapper.toValue(s.spotifyUrl), 'tracks': Mapper.toValue(s.tracks)};

  @override String? stringify(SpotifyPlaylist self) => 'SpotifyPlaylist(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)}, images: ${Mapper.asString(self.images)}, uri: ${Mapper.asString(self.uri)}, spotifyUrl: ${Mapper.asString(self.spotifyUrl)}, tracks: ${Mapper.asString(self.tracks)})';
  @override int? hash(SpotifyPlaylist self) => Mapper.hash(self.id) ^ Mapper.hash(self.name) ^ Mapper.hash(self.images) ^ Mapper.hash(self.uri) ^ Mapper.hash(self.spotifyUrl) ^ Mapper.hash(self.tracks);
  @override bool? equals(SpotifyPlaylist self, SpotifyPlaylist other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.images, other.images) && Mapper.isEqual(self.uri, other.uri) && Mapper.isEqual(self.spotifyUrl, other.spotifyUrl) && Mapper.isEqual(self.tracks, other.tracks);

  @override Function get typeFactory => (f) => f<SpotifyPlaylist>();
}

extension SpotifyPlaylistMapperExtension on SpotifyPlaylist {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyPlaylistCopyWith<SpotifyPlaylist> get copyWith => SpotifyPlaylistCopyWith(this, _$identity);
}

abstract class SpotifyPlaylistCopyWith<$R> {
  factory SpotifyPlaylistCopyWith(SpotifyPlaylist value, Then<SpotifyPlaylist, $R> then) = _SpotifyPlaylistCopyWithImpl<$R>;
  ListCopyWith<$R, SpotifyImage, SpotifyImageCopyWith<$R>> get images;
  ListCopyWith<$R, SpotifyTrack, SpotifyTrackCopyWith<$R>> get tracks;
  $R call({String? id, String? name, List<SpotifyImage>? images, String? uri, String? spotifyUrl, List<SpotifyTrack>? tracks});
}

class _SpotifyPlaylistCopyWithImpl<$R> extends BaseCopyWith<SpotifyPlaylist, $R> implements SpotifyPlaylistCopyWith<$R> {
  _SpotifyPlaylistCopyWithImpl(SpotifyPlaylist value, Then<SpotifyPlaylist, $R> then) : super(value, then);

  @override ListCopyWith<$R, SpotifyImage, SpotifyImageCopyWith<$R>> get images => ListCopyWith(_value.images, (v, t) => SpotifyImageCopyWith(v, t), (v) => call(images: v));
  @override ListCopyWith<$R, SpotifyTrack, SpotifyTrackCopyWith<$R>> get tracks => ListCopyWith(_value.tracks, (v, t) => SpotifyTrackCopyWith(v, t), (v) => call(tracks: v));
  @override $R call({String? id, String? name, List<SpotifyImage>? images, String? uri, String? spotifyUrl, List<SpotifyTrack>? tracks}) => _then(SpotifyPlaylist(id ?? _value.id, name ?? _value.name, images ?? _value.images, uri ?? _value.uri, spotifyUrl ?? _value.spotifyUrl, tracks ?? _value.tracks));
}

class SpotifyTrackMapper extends BaseMapper<SpotifyTrack> {
  SpotifyTrackMapper._();

  @override Function get decoder => decode;
  SpotifyTrack decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyTrack fromMap(Map<String, dynamic> map) => SpotifyTrack(map.get('name'), map.get('id'), map.get('uri'), map.get('album'), map.getList('artists'), map.get('durationMs'));

  @override Function get encoder => (SpotifyTrack v) => encode(v);
  dynamic encode(SpotifyTrack v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyTrack s) => {'name': Mapper.toValue(s.name), 'id': Mapper.toValue(s.id), 'uri': Mapper.toValue(s.uri), 'album': Mapper.toValue(s.album), 'artists': Mapper.toValue(s.artists), 'durationMs': Mapper.toValue(s.durationMs)};

  @override String? stringify(SpotifyTrack self) => 'SpotifyTrack(name: ${Mapper.asString(self.name)}, id: ${Mapper.asString(self.id)}, uri: ${Mapper.asString(self.uri)}, album: ${Mapper.asString(self.album)}, artists: ${Mapper.asString(self.artists)}, durationMs: ${Mapper.asString(self.durationMs)})';
  @override int? hash(SpotifyTrack self) => Mapper.hash(self.name) ^ Mapper.hash(self.id) ^ Mapper.hash(self.uri) ^ Mapper.hash(self.album) ^ Mapper.hash(self.artists) ^ Mapper.hash(self.durationMs);
  @override bool? equals(SpotifyTrack self, SpotifyTrack other) => Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.uri, other.uri) && Mapper.isEqual(self.album, other.album) && Mapper.isEqual(self.artists, other.artists) && Mapper.isEqual(self.durationMs, other.durationMs);

  @override Function get typeFactory => (f) => f<SpotifyTrack>();
}

extension SpotifyTrackMapperExtension on SpotifyTrack {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyTrackCopyWith<SpotifyTrack> get copyWith => SpotifyTrackCopyWith(this, _$identity);
}

abstract class SpotifyTrackCopyWith<$R> {
  factory SpotifyTrackCopyWith(SpotifyTrack value, Then<SpotifyTrack, $R> then) = _SpotifyTrackCopyWithImpl<$R>;
  SpotifyAlbumCopyWith<$R> get album;
  ListCopyWith<$R, SpotifyArtist, SpotifyArtistCopyWith<$R>> get artists;
  $R call({String? name, String? id, String? uri, SpotifyAlbum? album, List<SpotifyArtist>? artists, int? durationMs});
}

class _SpotifyTrackCopyWithImpl<$R> extends BaseCopyWith<SpotifyTrack, $R> implements SpotifyTrackCopyWith<$R> {
  _SpotifyTrackCopyWithImpl(SpotifyTrack value, Then<SpotifyTrack, $R> then) : super(value, then);

  @override SpotifyAlbumCopyWith<$R> get album => SpotifyAlbumCopyWith(_value.album, (v) => call(album: v));
  @override ListCopyWith<$R, SpotifyArtist, SpotifyArtistCopyWith<$R>> get artists => ListCopyWith(_value.artists, (v, t) => SpotifyArtistCopyWith(v, t), (v) => call(artists: v));
  @override $R call({String? name, String? id, String? uri, SpotifyAlbum? album, List<SpotifyArtist>? artists, int? durationMs}) => _then(SpotifyTrack(name ?? _value.name, id ?? _value.id, uri ?? _value.uri, album ?? _value.album, artists ?? _value.artists, durationMs ?? _value.durationMs));
}

class SpotifyAlbumMapper extends BaseMapper<SpotifyAlbum> {
  SpotifyAlbumMapper._();

  @override Function get decoder => decode;
  SpotifyAlbum decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyAlbum fromMap(Map<String, dynamic> map) => SpotifyAlbum(map.get('id'), map.get('uri'), map.get('name'), map.getList('images'));

  @override Function get encoder => (SpotifyAlbum v) => encode(v);
  dynamic encode(SpotifyAlbum v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyAlbum s) => {'id': Mapper.toValue(s.id), 'uri': Mapper.toValue(s.uri), 'name': Mapper.toValue(s.name), 'images': Mapper.toValue(s.images)};

  @override String? stringify(SpotifyAlbum self) => 'SpotifyAlbum(id: ${Mapper.asString(self.id)}, uri: ${Mapper.asString(self.uri)}, name: ${Mapper.asString(self.name)}, images: ${Mapper.asString(self.images)})';
  @override int? hash(SpotifyAlbum self) => Mapper.hash(self.id) ^ Mapper.hash(self.uri) ^ Mapper.hash(self.name) ^ Mapper.hash(self.images);
  @override bool? equals(SpotifyAlbum self, SpotifyAlbum other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.uri, other.uri) && Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.images, other.images);

  @override Function get typeFactory => (f) => f<SpotifyAlbum>();
}

extension SpotifyAlbumMapperExtension on SpotifyAlbum {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyAlbumCopyWith<SpotifyAlbum> get copyWith => SpotifyAlbumCopyWith(this, _$identity);
}

abstract class SpotifyAlbumCopyWith<$R> {
  factory SpotifyAlbumCopyWith(SpotifyAlbum value, Then<SpotifyAlbum, $R> then) = _SpotifyAlbumCopyWithImpl<$R>;
  ListCopyWith<$R, SpotifyImage, SpotifyImageCopyWith<$R>> get images;
  $R call({String? id, String? uri, String? name, List<SpotifyImage>? images});
}

class _SpotifyAlbumCopyWithImpl<$R> extends BaseCopyWith<SpotifyAlbum, $R> implements SpotifyAlbumCopyWith<$R> {
  _SpotifyAlbumCopyWithImpl(SpotifyAlbum value, Then<SpotifyAlbum, $R> then) : super(value, then);

  @override ListCopyWith<$R, SpotifyImage, SpotifyImageCopyWith<$R>> get images => ListCopyWith(_value.images, (v, t) => SpotifyImageCopyWith(v, t), (v) => call(images: v));
  @override $R call({String? id, String? uri, String? name, List<SpotifyImage>? images}) => _then(SpotifyAlbum(id ?? _value.id, uri ?? _value.uri, name ?? _value.name, images ?? _value.images));
}

class SpotifyImageMapper extends BaseMapper<SpotifyImage> {
  SpotifyImageMapper._();

  @override Function get decoder => decode;
  SpotifyImage decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyImage fromMap(Map<String, dynamic> map) => SpotifyImage(map.get('height'), map.get('width'), map.get('url'));

  @override Function get encoder => (SpotifyImage v) => encode(v);
  dynamic encode(SpotifyImage v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyImage s) => {'height': Mapper.toValue(s.height), 'width': Mapper.toValue(s.width), 'url': Mapper.toValue(s.url)};

  @override String? stringify(SpotifyImage self) => 'SpotifyImage(height: ${Mapper.asString(self.height)}, width: ${Mapper.asString(self.width)}, url: ${Mapper.asString(self.url)})';
  @override int? hash(SpotifyImage self) => Mapper.hash(self.height) ^ Mapper.hash(self.width) ^ Mapper.hash(self.url);
  @override bool? equals(SpotifyImage self, SpotifyImage other) => Mapper.isEqual(self.height, other.height) && Mapper.isEqual(self.width, other.width) && Mapper.isEqual(self.url, other.url);

  @override Function get typeFactory => (f) => f<SpotifyImage>();
}

extension SpotifyImageMapperExtension on SpotifyImage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyImageCopyWith<SpotifyImage> get copyWith => SpotifyImageCopyWith(this, _$identity);
}

abstract class SpotifyImageCopyWith<$R> {
  factory SpotifyImageCopyWith(SpotifyImage value, Then<SpotifyImage, $R> then) = _SpotifyImageCopyWithImpl<$R>;
  $R call({int? height, int? width, String? url});
}

class _SpotifyImageCopyWithImpl<$R> extends BaseCopyWith<SpotifyImage, $R> implements SpotifyImageCopyWith<$R> {
  _SpotifyImageCopyWithImpl(SpotifyImage value, Then<SpotifyImage, $R> then) : super(value, then);

  @override $R call({int? height, int? width, String? url}) => _then(SpotifyImage(height ?? _value.height, width ?? _value.width, url ?? _value.url));
}

class SpotifyArtistMapper extends BaseMapper<SpotifyArtist> {
  SpotifyArtistMapper._();

  @override Function get decoder => decode;
  SpotifyArtist decode(dynamic v) => _checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyArtist fromMap(Map<String, dynamic> map) => SpotifyArtist(map.get('id'), map.get('name'));

  @override Function get encoder => (SpotifyArtist v) => encode(v);
  dynamic encode(SpotifyArtist v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyArtist s) => {'id': Mapper.toValue(s.id), 'name': Mapper.toValue(s.name)};

  @override String? stringify(SpotifyArtist self) => 'SpotifyArtist(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)})';
  @override int? hash(SpotifyArtist self) => Mapper.hash(self.id) ^ Mapper.hash(self.name);
  @override bool? equals(SpotifyArtist self, SpotifyArtist other) => Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.name, other.name);

  @override Function get typeFactory => (f) => f<SpotifyArtist>();
}

extension SpotifyArtistMapperExtension on SpotifyArtist {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyArtistCopyWith<SpotifyArtist> get copyWith => SpotifyArtistCopyWith(this, _$identity);
}

abstract class SpotifyArtistCopyWith<$R> {
  factory SpotifyArtistCopyWith(SpotifyArtist value, Then<SpotifyArtist, $R> then) = _SpotifyArtistCopyWithImpl<$R>;
  $R call({String? id, String? name});
}

class _SpotifyArtistCopyWithImpl<$R> extends BaseCopyWith<SpotifyArtist, $R> implements SpotifyArtistCopyWith<$R> {
  _SpotifyArtistCopyWithImpl(SpotifyArtist value, Then<SpotifyArtist, $R> then) : super(value, then);

  @override $R call({String? id, String? name}) => _then(SpotifyArtist(id ?? _value.id, name ?? _value.name));
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
        throw MapperException('Cannot decode value $value of type ${value.runtimeType} to type $T. Unknown type. Did you forgot to include the class or register a custom mapper?');
      }
    }
  }

  static dynamic toValue(dynamic value) {
    if (value == null) return null;
    var typeInfo = TypeInfo.fromValue(value);
    var mapper = _mappers[typeInfo.type] ?? _mappers.values
      .cast<BaseMapper?>()
      .firstWhere((m) => m!.isFor(value), orElse: () => null);
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
      throw MapperException('Cannot encode value $value of type ${value.runtimeType}. Unknown type. Did you forgot to include the class or register a custom mapper?');
    }
  }

  static T fromMap<T>(Map<String, dynamic> map) => fromValue<T>(map);

  static Map<String, dynamic> toMap(dynamic object) {
    var value = toValue(object);
    if (value is Map<String, dynamic>) {
      return value;
    } else {
      throw MapperException('Cannot encode value of type ${object.runtimeType} to Map. Instead encoded to type ${value.runtimeType}.');
    }
  }
  
  static T fromIterable<T>(Iterable<dynamic> iterable) => fromValue<T>(iterable);

  static Iterable<dynamic> toIterable(dynamic object) {
    var value = toValue(object);
    if (value is Iterable<dynamic>) {
      return value;
    } else {
      throw MapperException('Cannot encode value of type ${object.runtimeType} to Iterable. Instead encoded to type ${value.runtimeType}.');
    }
  }

  static T fromJson<T>(String json) {
    return fromValue<T>(jsonDecode(json));
  }
  
  static String toJson(dynamic object) {
    return jsonEncode(toValue(object));
  }

  static bool isEqual(dynamic value, Object? other) {
    if (value == null || other == null) {
      return value == other;
    } else if (value.runtimeType != other.runtimeType) {
      return false;
    }
    var type = TypeInfo.fromValue(value);
    return _mappers[type.type]?.equals(value, other) ?? value == other;
  }
  
  static int hash(dynamic value) {
    var type = TypeInfo.fromValue(value);
    return _mappers[type.type]?.hash(value) ?? value.hashCode;
  }

  static String asString(dynamic value) {
    var type = TypeInfo.fromValue(value);
    return _mappers[type.type]?.stringify(value) ?? value.toString();
  }

  static void use<T>(BaseMapper<T> mapper) => _mappers[_typeOf<T>()] = mapper;
  static BaseMapper<T>? unuse<T>() => _mappers.remove(_typeOf<T>()) as BaseMapper<T>?;
  static void useAll(List<BaseMapper> mappers) => _mappers.addEntries(mappers.map((m) => MapEntry(_typeOf(m.type), m)));
  
  static BaseMapper<T>? get<T>() => _mappers[_typeOf<T>()] as BaseMapper<T>?;
  static List<BaseMapper> getAll() => [..._mappers.values];
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

  @override String toString() => _mapper?.stringify(this) ?? super.toString();
  @override bool operator ==(Object other) => identical(this, other) || (runtimeType == other.runtimeType && (_mapper?.equals(this, other) ?? super == other));
  @override int get hashCode => _mapper?.hash(this) ?? super.hashCode;
}

T _checked<T, U>(dynamic v, T Function(U) fn) {
  if (v is U) {
    return fn(v);
  } else {
    throw MapperException('Cannot decode value of type ${v.runtimeType} to type $T, because a value of type $U is expected.');
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
      throw MapperException('Cannot decode value of type ${d.runtimeType} to type DateTime, because a value of type String or num is expected.');
    }
  }
  
  @override
  String encode(DateTime self) {
    return self.toUtc().toIso8601String();
  }
}

class MapperEquality implements Equality {
  @override bool equals(dynamic e1, dynamic e2) => Mapper.isEqual(e1, e2);
  @override int hash(dynamic e) => Mapper.hash(e);
  @override bool isValidKey(Object? o) => true;
}

class IterableMapper<I extends Iterable> extends BaseMapper<I> with MapperEqualityMixin<I> {
  Iterable<U> Function<U>(Iterable<U> iterable) fromIterable;
  IterableMapper(this.fromIterable, this.typeFactory);

  @override Function get decoder => <T>(dynamic l) => _checked(l, (Iterable l) => fromIterable(l.map((v) => Mapper.fromValue<T>(v))));
  @override Function get encoder => (I self) => self.map((v) => Mapper.toValue(v)).toList();
  @override Function typeFactory;
  
  @override Equality equality = IterableEquality(MapperEquality());
}

class MapMapper<M extends Map> extends BaseMapper<M> with MapperEqualityMixin<M> {
  Map<K, V> Function<K, V>(Map<K, V> map) fromMap;
  MapMapper(this.fromMap, this.typeFactory);

  @override Function get decoder => <K, V>(dynamic m) => _checked(m,(Map m) => fromMap(m.map((key, value) => MapEntry(Mapper.fromValue<K>(key), Mapper.fromValue<V>(value)))));
  @override Function get encoder => (M self) => self.map((key, value) => MapEntry(Mapper.toValue(key), Mapper.toValue(value)));
  @override Function typeFactory;
  
  @override Equality equality = MapEquality(keys: MapperEquality(), values: MapperEquality());
}

class PrimitiveMapper<T> extends BaseMapper<T> {
  const PrimitiveMapper(this.decoder);
  
  @override final T Function(dynamic value) decoder;
  @override Function get encoder => (T value) => value;
  @override Function get typeFactory => (f) => f<T>();
  
  @override bool isFor(dynamic v) => v.runtimeType == T;
}

class EnumMapper<T> extends SimpleMapper<T> {
  EnumMapper(this._decoder, this._encoder);
  
  final T Function(String value) _decoder;
  final String Function(T value) _encoder;
  
  @override T decode(dynamic v) => _checked(v, _decoder);
  @override dynamic encode(T value) => _encoder(value);
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
    throw MapperException('Cannot construct generic wrapper for type $info. Mapper only supports generic classes with up to 3 type arguments.');
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

class _None { const _None(); }
const _none = _None();

T _$identity<T>(T value) => value;
typedef Then<$T, $R> = $R Function($T);

class BaseCopyWith<$T, $R> {
  BaseCopyWith(this._value, this._then);

  final $T _value;
  final Then<$T, $R> _then;
  
  T or<T>(Object? _v, T v) => _v == _none ? v : _v as T;
}

class ListCopyWith<$R, $T, $C> extends BaseCopyWith<List<$T>, $R> {
  ListCopyWith(List<$T> value, this.itemCopyWith, Then<List<$T>, $R> then)
      : super(value, then);
  $C Function($T a, Then<$T, $R> b) itemCopyWith;

  $C at(int index) => itemCopyWith(_value[index], (v) => replace(index, v));

  $R add($T v) => addAll([v]);

  $R addAll(Iterable<$T> v) => _then([..._value, ...v]);

  $R replace(int index, $T v) => splice(index, 1, [v]);

  $R insert(int index, $T v) => insertAll(index, [v]);

  $R insertAll(int index, Iterable<$T> v) => splice(index, 0, v);

  $R removeAt(int index) => splice(index, 1);

  $R splice(int index, int removeCount, [Iterable<$T>? toInsert]) => _then([
        ..._value.take(index),
        if (toInsert != null) ...toInsert,
        ..._value.skip(index + removeCount),
      ]);

  $R take(int count) => _then(_value.take(count).toList());

  $R skip(int count) => _then(_value.skip(count).toList());

  $R where(bool Function($T) test) => _then(_value.where(test).toList());

  $R sublist(int start, [int? end]) => _then(_value.sublist(start, end));
}

