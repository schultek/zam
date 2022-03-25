import 'dart:ui';

import 'package:dart_mappable/internals.dart';

import 'core/layouts/drops_layout.dart';
import 'core/layouts/focus_layout.dart';
import 'core/layouts/full_page_layout.dart';
import 'core/layouts/grid_layout.dart';
import 'core/layouts/layout_model.dart';
import 'core/models/trip.dart';
import 'core/templates/swipe/swipe_template.dart';
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

var _mappers = <BaseMapper>{
  // class mappers
  TripMapper._(),
  TripUserMapper._(),
  SwipeTemplateModelMapper._(),
  TemplateModelMapper._(),
  SwipeTemplatePageMapper._(),
  TemplatePageMapper._(),
  ThemeModelMapper._(),
  FullPageLayoutModelMapper._(),
  LayoutModelMapper._(),
  GridLayoutModelMapper._(),
  DropModelMapper._(),
  DropsLayoutModelMapper._(),
  FocusLayoutModelMapper._(),
  AnnouncementMapper._(),
  EliminationGameMapper._(),
  EliminationEntryMapper._(),
  NoteMapper._(),
  PollMapper._(),
  PollStepMapper._(),
  MultipleChoiceQuestionMapper._(),
  TheButtonStateMapper._(),
  ChannelInfoMapper._(),
  ChatMessageMapper._(),
  ChatTextMessageMapper._(),
  ChatImageMessageMapper._(),
  ChatFileMessageMapper._(),
  MusicConfigMapper._(),
  SpotifyPlayerMapper._(),
  SpotifyCredentialsMapper._(),
  SpotifyPlaylistMapper._(),
  SpotifyTrackMapper._(),
  SpotifyAlbumMapper._(),
  SpotifyImageMapper._(),
  SpotifyArtistMapper._(),
  AlbumShortcutMapper._(),
  // enum mappers
  // custom mappers
  ColorMapper(),
};

// === GENERATED CLASS MAPPERS AND EXTENSIONS ===

class TripMapper extends BaseMapper<Trip> {
  TripMapper._();

  @override
  Function get decoder => decode;
  Trip decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  Trip fromMap(Map<String, dynamic> map) => Trip(
      id: map.get('id'),
      name: map.get('name'),
      pictureUrl: map.getOpt('pictureUrl'),
      template: map.get('template'),
      theme: map.get('theme'),
      users: map.getOpt('users') ?? const {},
      modules: map.getOpt('modules') ?? const {},
      moduleBlacklist: map.getOpt('moduleBlacklist') ?? const []);

  @override
  Function get encoder => (Trip v) => encode(v);
  dynamic encode(Trip v) => toMap(v);
  Map<String, dynamic> toMap(Trip t) => {
        'id': Mapper.toValue(t.id),
        'name': Mapper.toValue(t.name),
        'pictureUrl': Mapper.toValue(t.pictureUrl),
        'template': Mapper.toValue(t.template),
        'theme': Mapper.toValue(t.theme),
        'users': Mapper.toValue(t.users),
        'modules': Mapper.toValue(t.modules),
        'moduleBlacklist': Mapper.toValue(t.moduleBlacklist)
      };

  @override
  String? stringify(Trip self) =>
      'Trip(name: ${Mapper.asString(self.name)}, id: ${Mapper.asString(self.id)}, pictureUrl: ${Mapper.asString(self.pictureUrl)}, template: ${Mapper.asString(self.template)}, theme: ${Mapper.asString(self.theme)}, users: ${Mapper.asString(self.users)}, modules: ${Mapper.asString(self.modules)}, moduleBlacklist: ${Mapper.asString(self.moduleBlacklist)})';
  @override
  int? hash(Trip self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.name) ^
      Mapper.hash(self.pictureUrl) ^
      Mapper.hash(self.template) ^
      Mapper.hash(self.theme) ^
      Mapper.hash(self.users) ^
      Mapper.hash(self.modules) ^
      Mapper.hash(self.moduleBlacklist);
  @override
  bool? equals(Trip self, Trip other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.name, other.name) &&
      Mapper.isEqual(self.pictureUrl, other.pictureUrl) &&
      Mapper.isEqual(self.template, other.template) &&
      Mapper.isEqual(self.theme, other.theme) &&
      Mapper.isEqual(self.users, other.users) &&
      Mapper.isEqual(self.modules, other.modules) &&
      Mapper.isEqual(self.moduleBlacklist, other.moduleBlacklist);

  @override
  Function get typeFactory => (f) => f<Trip>();
}

extension TripMapperExtension on Trip {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  TripCopyWith<Trip> get copyWith => TripCopyWith(this, $identity);
}

abstract class TripCopyWith<$R> {
  factory TripCopyWith(Trip value, Then<Trip, $R> then) = _TripCopyWithImpl<$R>;
  ThemeModelCopyWith<$R> get theme;
  MapCopyWith<$R, String, TripUser, TripUserCopyWith<$R>> get users;
  $R call(
      {String? id,
      String? name,
      String? pictureUrl,
      TemplateModel? template,
      ThemeModel? theme,
      Map<String, TripUser>? users,
      Map<String, List<String>>? modules,
      List<String>? moduleBlacklist});
  $R apply(Trip Function(Trip) transform);
}

class _TripCopyWithImpl<$R> extends BaseCopyWith<Trip, $R> implements TripCopyWith<$R> {
  _TripCopyWithImpl(Trip value, Then<Trip, $R> then) : super(value, then);

  @override
  ThemeModelCopyWith<$R> get theme => ThemeModelCopyWith($value.theme, (v) => call(theme: v));
  @override
  MapCopyWith<$R, String, TripUser, TripUserCopyWith<$R>> get users =>
      MapCopyWith($value.users, (v, t) => TripUserCopyWith(v, t), (v) => call(users: v));
  @override
  $R call(
          {String? id,
          String? name,
          Object? pictureUrl = $none,
          TemplateModel? template,
          ThemeModel? theme,
          Map<String, TripUser>? users,
          Map<String, List<String>>? modules,
          List<String>? moduleBlacklist}) =>
      $then(Trip(
          id: id ?? $value.id,
          name: name ?? $value.name,
          pictureUrl: or(pictureUrl, $value.pictureUrl),
          template: template ?? $value.template,
          theme: theme ?? $value.theme,
          users: users ?? $value.users,
          modules: modules ?? $value.modules,
          moduleBlacklist: moduleBlacklist ?? $value.moduleBlacklist));
}

class TripUserMapper extends BaseMapper<TripUser> {
  TripUserMapper._();

  @override
  Function get decoder => decode;
  TripUser decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  TripUser fromMap(Map<String, dynamic> map) => TripUser(
      role: map.getOpt('role') ?? UserRoles.participant,
      nickname: map.getOpt('nickname'),
      profileUrl: map.getOpt('profileUrl'));

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
      'TripUser(role: ${Mapper.asString(self.role)}, nickname: ${Mapper.asString(self.nickname)}, profileUrl: ${Mapper.asString(self.profileUrl)})';
  @override
  int? hash(TripUser self) => Mapper.hash(self.role) ^ Mapper.hash(self.nickname) ^ Mapper.hash(self.profileUrl);
  @override
  bool? equals(TripUser self, TripUser other) =>
      Mapper.isEqual(self.role, other.role) &&
      Mapper.isEqual(self.nickname, other.nickname) &&
      Mapper.isEqual(self.profileUrl, other.profileUrl);

  @override
  Function get typeFactory => (f) => f<TripUser>();
}

extension TripUserMapperExtension on TripUser {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  TripUserCopyWith<TripUser> get copyWith => TripUserCopyWith(this, $identity);
}

abstract class TripUserCopyWith<$R> {
  factory TripUserCopyWith(TripUser value, Then<TripUser, $R> then) = _TripUserCopyWithImpl<$R>;
  $R call({String? role, String? nickname, String? profileUrl});
  $R apply(TripUser Function(TripUser) transform);
}

class _TripUserCopyWithImpl<$R> extends BaseCopyWith<TripUser, $R> implements TripUserCopyWith<$R> {
  _TripUserCopyWithImpl(TripUser value, Then<TripUser, $R> then) : super(value, then);

  @override
  $R call({String? role, Object? nickname = $none, Object? profileUrl = $none}) => $then(TripUser(
      role: role ?? $value.role,
      nickname: or(nickname, $value.nickname),
      profileUrl: or(profileUrl, $value.profileUrl)));
}

class SwipeTemplateModelMapper extends BaseMapper<SwipeTemplateModel> {
  SwipeTemplateModelMapper._();

  @override
  Function get decoder => decode;
  SwipeTemplateModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SwipeTemplateModel fromMap(Map<String, dynamic> map) => SwipeTemplateModel(
      type: map.getOpt('type'),
      mainPage: map.getOpt('mainPage') ?? const SwipeTemplatePage(layout: GridLayoutModel()),
      leftPage: map.getOpt('leftPage'),
      rightPage: map.getOpt('rightPage'));

  @override
  Function get encoder => (SwipeTemplateModel v) => encode(v);
  dynamic encode(SwipeTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(SwipeTemplateModel s) => {
        'mainPage': Mapper.toValue(s.mainPage),
        'leftPage': Mapper.toValue(s.leftPage),
        'rightPage': Mapper.toValue(s.rightPage),
        'type': 'swipe'
      };

  @override
  String? stringify(SwipeTemplateModel self) =>
      'SwipeTemplateModel(mainPage: ${Mapper.asString(self.mainPage)}, leftPage: ${Mapper.asString(self.leftPage)}, rightPage: ${Mapper.asString(self.rightPage)})';
  @override
  int? hash(SwipeTemplateModel self) =>
      Mapper.hash(self.mainPage) ^ Mapper.hash(self.leftPage) ^ Mapper.hash(self.rightPage);
  @override
  bool? equals(SwipeTemplateModel self, SwipeTemplateModel other) =>
      Mapper.isEqual(self.mainPage, other.mainPage) &&
      Mapper.isEqual(self.leftPage, other.leftPage) &&
      Mapper.isEqual(self.rightPage, other.rightPage);

  @override
  Function get typeFactory => (f) => f<SwipeTemplateModel>();
}

extension SwipeTemplateModelMapperExtension on SwipeTemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SwipeTemplateModelCopyWith<SwipeTemplateModel> get copyWith => SwipeTemplateModelCopyWith(this, $identity);
}

abstract class SwipeTemplateModelCopyWith<$R> {
  factory SwipeTemplateModelCopyWith(SwipeTemplateModel value, Then<SwipeTemplateModel, $R> then) =
      _SwipeTemplateModelCopyWithImpl<$R>;
  SwipeTemplatePageCopyWith<$R> get mainPage;
  SwipeTemplatePageCopyWith<$R>? get leftPage;
  SwipeTemplatePageCopyWith<$R>? get rightPage;
  $R call({String? type, SwipeTemplatePage? mainPage, SwipeTemplatePage? leftPage, SwipeTemplatePage? rightPage});
  $R apply(SwipeTemplateModel Function(SwipeTemplateModel) transform);
}

class _SwipeTemplateModelCopyWithImpl<$R> extends BaseCopyWith<SwipeTemplateModel, $R>
    implements SwipeTemplateModelCopyWith<$R> {
  _SwipeTemplateModelCopyWithImpl(SwipeTemplateModel value, Then<SwipeTemplateModel, $R> then) : super(value, then);

  @override
  SwipeTemplatePageCopyWith<$R> get mainPage => SwipeTemplatePageCopyWith($value.mainPage, (v) => call(mainPage: v));
  @override
  SwipeTemplatePageCopyWith<$R>? get leftPage =>
      $value.leftPage != null ? SwipeTemplatePageCopyWith($value.leftPage!, (v) => call(leftPage: v)) : null;
  @override
  SwipeTemplatePageCopyWith<$R>? get rightPage =>
      $value.rightPage != null ? SwipeTemplatePageCopyWith($value.rightPage!, (v) => call(rightPage: v)) : null;
  @override
  $R call({String? type, SwipeTemplatePage? mainPage, Object? leftPage = $none, Object? rightPage = $none}) =>
      $then(SwipeTemplateModel(
          type: type,
          mainPage: mainPage ?? $value.mainPage,
          leftPage: or(leftPage, $value.leftPage),
          rightPage: or(rightPage, $value.rightPage)));
}

class TemplateModelMapper extends BaseMapper<TemplateModel> {
  TemplateModelMapper._();

  @override
  Function get decoder => decode;
  TemplateModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) {
        switch (map['type']) {
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
    if (v is SwipeTemplateModel) {
      return SwipeTemplateModelMapper._().encode(v);
    } else {
      return toMap(v);
    }
  }

  Map<String, dynamic> toMap(TemplateModel t) => {};

  @override
  String? stringify(TemplateModel self) => 'TemplateModel()';
  @override
  int? hash(TemplateModel self) => self.hashCode;
  @override
  bool? equals(TemplateModel self, TemplateModel other) => true;

  @override
  Function get typeFactory => (f) => f<TemplateModel>();
}

extension TemplateModelMapperExtension on TemplateModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
}

class SwipeTemplatePageMapper extends BaseMapper<SwipeTemplatePage> {
  SwipeTemplatePageMapper._();

  @override
  Function get decoder => decode;
  SwipeTemplatePage decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SwipeTemplatePage fromMap(Map<String, dynamic> map) => SwipeTemplatePage(layout: map.get('layout'));

  @override
  Function get encoder => (SwipeTemplatePage v) => encode(v);
  dynamic encode(SwipeTemplatePage v) => toMap(v);
  Map<String, dynamic> toMap(SwipeTemplatePage s) => {'layout': Mapper.toValue(s.layout), 'type': 'swipe'};

  @override
  String? stringify(SwipeTemplatePage self) => 'SwipeTemplatePage(layout: ${Mapper.asString(self.layout)})';
  @override
  int? hash(SwipeTemplatePage self) => Mapper.hash(self.layout);
  @override
  bool? equals(SwipeTemplatePage self, SwipeTemplatePage other) => Mapper.isEqual(self.layout, other.layout);

  @override
  Function get typeFactory => (f) => f<SwipeTemplatePage>();
}

extension SwipeTemplatePageMapperExtension on SwipeTemplatePage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SwipeTemplatePageCopyWith<SwipeTemplatePage> get copyWith => SwipeTemplatePageCopyWith(this, $identity);
}

abstract class SwipeTemplatePageCopyWith<$R> {
  factory SwipeTemplatePageCopyWith(SwipeTemplatePage value, Then<SwipeTemplatePage, $R> then) =
      _SwipeTemplatePageCopyWithImpl<$R>;
  $R call({LayoutModel? layout});
  $R apply(SwipeTemplatePage Function(SwipeTemplatePage) transform);
}

class _SwipeTemplatePageCopyWithImpl<$R> extends BaseCopyWith<SwipeTemplatePage, $R>
    implements SwipeTemplatePageCopyWith<$R> {
  _SwipeTemplatePageCopyWithImpl(SwipeTemplatePage value, Then<SwipeTemplatePage, $R> then) : super(value, then);

  @override
  $R call({LayoutModel? layout}) => $then(SwipeTemplatePage(layout: layout ?? $value.layout));
}

class TemplatePageMapper extends BaseMapper<TemplatePage> {
  TemplatePageMapper._();

  @override
  Function get decoder => decode;
  TemplatePage decode(dynamic v) => checked(v, (Map<String, dynamic> map) {
        switch (map['type']) {
          case 'swipe':
            return SwipeTemplatePageMapper._().decode(map);
          default:
            return fromMap(map);
        }
      });
  TemplatePage fromMap(Map<String, dynamic> map) => TemplatePage();

  @override
  Function get encoder => (TemplatePage v) => encode(v);
  dynamic encode(TemplatePage v) {
    if (v is SwipeTemplatePage) {
      return SwipeTemplatePageMapper._().encode(v);
    } else {
      return toMap(v);
    }
  }

  Map<String, dynamic> toMap(TemplatePage t) => {};

  @override
  String? stringify(TemplatePage self) => 'TemplatePage()';
  @override
  int? hash(TemplatePage self) => self.hashCode;
  @override
  bool? equals(TemplatePage self, TemplatePage other) => true;

  @override
  Function get typeFactory => (f) => f<TemplatePage>();
}

extension TemplatePageMapperExtension on TemplatePage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  TemplatePageCopyWith<TemplatePage> get copyWith => TemplatePageCopyWith(this, $identity);
}

abstract class TemplatePageCopyWith<$R> {
  factory TemplatePageCopyWith(TemplatePage value, Then<TemplatePage, $R> then) = _TemplatePageCopyWithImpl<$R>;
  $R call();
  $R apply(TemplatePage Function(TemplatePage) transform);
}

class _TemplatePageCopyWithImpl<$R> extends BaseCopyWith<TemplatePage, $R> implements TemplatePageCopyWith<$R> {
  _TemplatePageCopyWithImpl(TemplatePage value, Then<TemplatePage, $R> then) : super(value, then);

  @override
  $R call() => $then(TemplatePage());
}

class ThemeModelMapper extends BaseMapper<ThemeModel> {
  ThemeModelMapper._();

  @override
  Function get decoder => decode;
  ThemeModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ThemeModel fromMap(Map<String, dynamic> map) =>
      ThemeModel(schemeIndex: map.get('schemeIndex'), dark: map.getOpt('dark') ?? false);

  @override
  Function get encoder => (ThemeModel v) => encode(v);
  dynamic encode(ThemeModel v) => toMap(v);
  Map<String, dynamic> toMap(ThemeModel t) =>
      {'schemeIndex': Mapper.toValue(t.schemeIndex), 'dark': Mapper.toValue(t.dark)};

  @override
  String? stringify(ThemeModel self) =>
      'ThemeModel(schemeIndex: ${Mapper.asString(self.schemeIndex)}, dark: ${Mapper.asString(self.dark)})';
  @override
  int? hash(ThemeModel self) => Mapper.hash(self.schemeIndex) ^ Mapper.hash(self.dark);
  @override
  bool? equals(ThemeModel self, ThemeModel other) =>
      Mapper.isEqual(self.schemeIndex, other.schemeIndex) && Mapper.isEqual(self.dark, other.dark);

  @override
  Function get typeFactory => (f) => f<ThemeModel>();
}

extension ThemeModelMapperExtension on ThemeModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ThemeModelCopyWith<ThemeModel> get copyWith => ThemeModelCopyWith(this, $identity);
}

abstract class ThemeModelCopyWith<$R> {
  factory ThemeModelCopyWith(ThemeModel value, Then<ThemeModel, $R> then) = _ThemeModelCopyWithImpl<$R>;
  $R call({int? schemeIndex, bool? dark});
  $R apply(ThemeModel Function(ThemeModel) transform);
}

class _ThemeModelCopyWithImpl<$R> extends BaseCopyWith<ThemeModel, $R> implements ThemeModelCopyWith<$R> {
  _ThemeModelCopyWithImpl(ThemeModel value, Then<ThemeModel, $R> then) : super(value, then);

  @override
  $R call({int? schemeIndex, bool? dark}) =>
      $then(ThemeModel(schemeIndex: schemeIndex ?? $value.schemeIndex, dark: dark ?? $value.dark));
}

class FullPageLayoutModelMapper extends BaseMapper<FullPageLayoutModel> {
  FullPageLayoutModelMapper._();

  @override
  Function get decoder => decode;
  FullPageLayoutModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  FullPageLayoutModel fromMap(Map<String, dynamic> map) => FullPageLayoutModel(type: map.getOpt('type'));

  @override
  Function get encoder => (FullPageLayoutModel v) => encode(v);
  dynamic encode(FullPageLayoutModel v) => toMap(v);
  Map<String, dynamic> toMap(FullPageLayoutModel f) => {'type': Mapper.toValue(f.type)};

  @override
  String? stringify(FullPageLayoutModel self) => 'FullPageLayoutModel(type: ${Mapper.asString(self.type)})';
  @override
  int? hash(FullPageLayoutModel self) => Mapper.hash(self.type);
  @override
  bool? equals(FullPageLayoutModel self, FullPageLayoutModel other) => Mapper.isEqual(self.type, other.type);

  @override
  Function get typeFactory => (f) => f<FullPageLayoutModel>();
}

extension FullPageLayoutModelMapperExtension on FullPageLayoutModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  FullPageLayoutModelCopyWith<FullPageLayoutModel> get copyWith => FullPageLayoutModelCopyWith(this, $identity);
}

abstract class FullPageLayoutModelCopyWith<$R> {
  factory FullPageLayoutModelCopyWith(FullPageLayoutModel value, Then<FullPageLayoutModel, $R> then) =
      _FullPageLayoutModelCopyWithImpl<$R>;
  $R call({String? type});
  $R apply(FullPageLayoutModel Function(FullPageLayoutModel) transform);
}

class _FullPageLayoutModelCopyWithImpl<$R> extends BaseCopyWith<FullPageLayoutModel, $R>
    implements FullPageLayoutModelCopyWith<$R> {
  _FullPageLayoutModelCopyWithImpl(FullPageLayoutModel value, Then<FullPageLayoutModel, $R> then) : super(value, then);

  @override
  $R call({Object? type = $none}) => $then(FullPageLayoutModel(type: or(type, $value.type)));
}

class LayoutModelMapper extends BaseMapper<LayoutModel> {
  LayoutModelMapper._();

  @override
  Function get decoder => decode;
  LayoutModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) {
        switch (map['type']) {
          case 'drops':
            return DropsLayoutModelMapper._().decode(map);
          case 'focus':
            return FocusLayoutModelMapper._().decode(map);
          case 'grid':
            return GridLayoutModelMapper._().decode(map);
          case 'page':
            return FullPageLayoutModelMapper._().decode(map);
          default:
            return fromMap(map);
        }
      });
  LayoutModel fromMap(Map<String, dynamic> map) => throw MapperException(
      "Cannot instantiate class LayoutModel, did you forgot to specify a subclass for [ type: '${map['type']}' ] or a default subclass?");

  @override
  Function get encoder => (LayoutModel v) => encode(v);
  dynamic encode(LayoutModel v) {
    if (v is FullPageLayoutModel) {
      return FullPageLayoutModelMapper._().encode(v);
    } else if (v is GridLayoutModel) {
      return GridLayoutModelMapper._().encode(v);
    } else if (v is DropsLayoutModel) {
      return DropsLayoutModelMapper._().encode(v);
    } else if (v is FocusLayoutModel) {
      return FocusLayoutModelMapper._().encode(v);
    } else {
      return toMap(v);
    }
  }

  Map<String, dynamic> toMap(LayoutModel l) => {'type': Mapper.toValue(l.type)};

  @override
  String? stringify(LayoutModel self) => 'LayoutModel(type: ${Mapper.asString(self.type)})';
  @override
  int? hash(LayoutModel self) => Mapper.hash(self.type);
  @override
  bool? equals(LayoutModel self, LayoutModel other) => Mapper.isEqual(self.type, other.type);

  @override
  Function get typeFactory => (f) => f<LayoutModel>();
}

extension LayoutModelMapperExtension on LayoutModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
}

class GridLayoutModelMapper extends BaseMapper<GridLayoutModel> {
  GridLayoutModelMapper._();

  @override
  Function get decoder => decode;
  GridLayoutModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  GridLayoutModel fromMap(Map<String, dynamic> map) => GridLayoutModel(type: map.getOpt('type'));

  @override
  Function get encoder => (GridLayoutModel v) => encode(v);
  dynamic encode(GridLayoutModel v) => toMap(v);
  Map<String, dynamic> toMap(GridLayoutModel g) => {'type': Mapper.toValue(g.type)};

  @override
  String? stringify(GridLayoutModel self) => 'GridLayoutModel(type: ${Mapper.asString(self.type)})';
  @override
  int? hash(GridLayoutModel self) => Mapper.hash(self.type);
  @override
  bool? equals(GridLayoutModel self, GridLayoutModel other) => Mapper.isEqual(self.type, other.type);

  @override
  Function get typeFactory => (f) => f<GridLayoutModel>();
}

extension GridLayoutModelMapperExtension on GridLayoutModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  GridLayoutModelCopyWith<GridLayoutModel> get copyWith => GridLayoutModelCopyWith(this, $identity);
}

abstract class GridLayoutModelCopyWith<$R> {
  factory GridLayoutModelCopyWith(GridLayoutModel value, Then<GridLayoutModel, $R> then) =
      _GridLayoutModelCopyWithImpl<$R>;
  $R call({String? type});
  $R apply(GridLayoutModel Function(GridLayoutModel) transform);
}

class _GridLayoutModelCopyWithImpl<$R> extends BaseCopyWith<GridLayoutModel, $R>
    implements GridLayoutModelCopyWith<$R> {
  _GridLayoutModelCopyWithImpl(GridLayoutModel value, Then<GridLayoutModel, $R> then) : super(value, then);

  @override
  $R call({Object? type = $none}) => $then(GridLayoutModel(type: or(type, $value.type)));
}

class DropModelMapper extends BaseMapper<DropModel> {
  DropModelMapper._();

  @override
  Function get decoder => decode;
  DropModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  DropModel fromMap(Map<String, dynamic> map) =>
      DropModel(id: map.get('id'), label: map.getOpt('label'), isHidden: map.getOpt('isHidden') ?? false);

  @override
  Function get encoder => (DropModel v) => encode(v);
  dynamic encode(DropModel v) => toMap(v);
  Map<String, dynamic> toMap(DropModel d) =>
      {'id': Mapper.toValue(d.id), 'label': Mapper.toValue(d.label), 'isHidden': Mapper.toValue(d.isHidden)};

  @override
  String? stringify(DropModel self) =>
      'DropModel(id: ${Mapper.asString(self.id)}, label: ${Mapper.asString(self.label)}, isHidden: ${Mapper.asString(self.isHidden)})';
  @override
  int? hash(DropModel self) => Mapper.hash(self.id) ^ Mapper.hash(self.label) ^ Mapper.hash(self.isHidden);
  @override
  bool? equals(DropModel self, DropModel other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.label, other.label) &&
      Mapper.isEqual(self.isHidden, other.isHidden);

  @override
  Function get typeFactory => (f) => f<DropModel>();
}

extension DropModelMapperExtension on DropModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  DropModelCopyWith<DropModel> get copyWith => DropModelCopyWith(this, $identity);
}

abstract class DropModelCopyWith<$R> {
  factory DropModelCopyWith(DropModel value, Then<DropModel, $R> then) = _DropModelCopyWithImpl<$R>;
  $R call({String? id, String? label, bool? isHidden});
  $R apply(DropModel Function(DropModel) transform);
}

class _DropModelCopyWithImpl<$R> extends BaseCopyWith<DropModel, $R> implements DropModelCopyWith<$R> {
  _DropModelCopyWithImpl(DropModel value, Then<DropModel, $R> then) : super(value, then);

  @override
  $R call({String? id, Object? label = $none, bool? isHidden}) =>
      $then(DropModel(id: id ?? $value.id, label: or(label, $value.label), isHidden: isHidden ?? $value.isHidden));
}

class DropsLayoutModelMapper extends BaseMapper<DropsLayoutModel> {
  DropsLayoutModelMapper._();

  @override
  Function get decoder => decode;
  DropsLayoutModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  DropsLayoutModel fromMap(Map<String, dynamic> map) =>
      DropsLayoutModel(type: map.getOpt('type'), drops: map.getOpt('drops') ?? const []);

  @override
  Function get encoder => (DropsLayoutModel v) => encode(v);
  dynamic encode(DropsLayoutModel v) => toMap(v);
  Map<String, dynamic> toMap(DropsLayoutModel d) => {'type': Mapper.toValue(d.type), 'drops': Mapper.toValue(d.drops)};

  @override
  String? stringify(DropsLayoutModel self) =>
      'DropsLayoutModel(type: ${Mapper.asString(self.type)}, drops: ${Mapper.asString(self.drops)})';
  @override
  int? hash(DropsLayoutModel self) => Mapper.hash(self.type) ^ Mapper.hash(self.drops);
  @override
  bool? equals(DropsLayoutModel self, DropsLayoutModel other) =>
      Mapper.isEqual(self.type, other.type) && Mapper.isEqual(self.drops, other.drops);

  @override
  Function get typeFactory => (f) => f<DropsLayoutModel>();
}

extension DropsLayoutModelMapperExtension on DropsLayoutModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  DropsLayoutModelCopyWith<DropsLayoutModel> get copyWith => DropsLayoutModelCopyWith(this, $identity);
}

abstract class DropsLayoutModelCopyWith<$R> {
  factory DropsLayoutModelCopyWith(DropsLayoutModel value, Then<DropsLayoutModel, $R> then) =
      _DropsLayoutModelCopyWithImpl<$R>;
  ListCopyWith<$R, DropModel, DropModelCopyWith<$R>> get drops;
  $R call({String? type, List<DropModel>? drops});
  $R apply(DropsLayoutModel Function(DropsLayoutModel) transform);
}

class _DropsLayoutModelCopyWithImpl<$R> extends BaseCopyWith<DropsLayoutModel, $R>
    implements DropsLayoutModelCopyWith<$R> {
  _DropsLayoutModelCopyWithImpl(DropsLayoutModel value, Then<DropsLayoutModel, $R> then) : super(value, then);

  @override
  ListCopyWith<$R, DropModel, DropModelCopyWith<$R>> get drops =>
      ListCopyWith($value.drops, (v, t) => DropModelCopyWith(v, t), (v) => call(drops: v));
  @override
  $R call({Object? type = $none, List<DropModel>? drops}) =>
      $then(DropsLayoutModel(type: or(type, $value.type), drops: drops ?? $value.drops));
}

class FocusLayoutModelMapper extends BaseMapper<FocusLayoutModel> {
  FocusLayoutModelMapper._();

  @override
  Function get decoder => decode;
  FocusLayoutModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  FocusLayoutModel fromMap(Map<String, dynamic> map) => FocusLayoutModel(type: map.getOpt('type'));

  @override
  Function get encoder => (FocusLayoutModel v) => encode(v);
  dynamic encode(FocusLayoutModel v) => toMap(v);
  Map<String, dynamic> toMap(FocusLayoutModel f) => {'type': Mapper.toValue(f.type)};

  @override
  String? stringify(FocusLayoutModel self) => 'FocusLayoutModel(type: ${Mapper.asString(self.type)})';
  @override
  int? hash(FocusLayoutModel self) => Mapper.hash(self.type);
  @override
  bool? equals(FocusLayoutModel self, FocusLayoutModel other) => Mapper.isEqual(self.type, other.type);

  @override
  Function get typeFactory => (f) => f<FocusLayoutModel>();
}

extension FocusLayoutModelMapperExtension on FocusLayoutModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  FocusLayoutModelCopyWith<FocusLayoutModel> get copyWith => FocusLayoutModelCopyWith(this, $identity);
}

abstract class FocusLayoutModelCopyWith<$R> {
  factory FocusLayoutModelCopyWith(FocusLayoutModel value, Then<FocusLayoutModel, $R> then) =
      _FocusLayoutModelCopyWithImpl<$R>;
  $R call({String? type});
  $R apply(FocusLayoutModel Function(FocusLayoutModel) transform);
}

class _FocusLayoutModelCopyWithImpl<$R> extends BaseCopyWith<FocusLayoutModel, $R>
    implements FocusLayoutModelCopyWith<$R> {
  _FocusLayoutModelCopyWithImpl(FocusLayoutModel value, Then<FocusLayoutModel, $R> then) : super(value, then);

  @override
  $R call({Object? type = $none}) => $then(FocusLayoutModel(type: or(type, $value.type)));
}

class AnnouncementMapper extends BaseMapper<Announcement> {
  AnnouncementMapper._();

  @override
  Function get decoder => decode;
  Announcement decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  Announcement fromMap(Map<String, dynamic> map) => Announcement(
      title: map.getOpt('title'),
      message: map.get('message'),
      textColor: map.getOpt('textColor'),
      backgroundColor: map.getOpt('backgroundColor'),
      isDismissible: map.getOpt('isDismissible') ?? false);

  @override
  Function get encoder => (Announcement v) => encode(v);
  dynamic encode(Announcement v) => toMap(v);
  Map<String, dynamic> toMap(Announcement a) => {
        'title': Mapper.toValue(a.title),
        'message': Mapper.toValue(a.message),
        'textColor': Mapper.toValue(a.textColor),
        'backgroundColor': Mapper.toValue(a.backgroundColor),
        'isDismissible': Mapper.toValue(a.isDismissible)
      };

  @override
  String? stringify(Announcement self) =>
      'Announcement(title: ${Mapper.asString(self.title)}, message: ${Mapper.asString(self.message)}, textColor: ${Mapper.asString(self.textColor)}, backgroundColor: ${Mapper.asString(self.backgroundColor)}, isDismissible: ${Mapper.asString(self.isDismissible)})';
  @override
  int? hash(Announcement self) =>
      Mapper.hash(self.title) ^
      Mapper.hash(self.message) ^
      Mapper.hash(self.textColor) ^
      Mapper.hash(self.backgroundColor) ^
      Mapper.hash(self.isDismissible);
  @override
  bool? equals(Announcement self, Announcement other) =>
      Mapper.isEqual(self.title, other.title) &&
      Mapper.isEqual(self.message, other.message) &&
      Mapper.isEqual(self.textColor, other.textColor) &&
      Mapper.isEqual(self.backgroundColor, other.backgroundColor) &&
      Mapper.isEqual(self.isDismissible, other.isDismissible);

  @override
  Function get typeFactory => (f) => f<Announcement>();
}

extension AnnouncementMapperExtension on Announcement {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  AnnouncementCopyWith<Announcement> get copyWith => AnnouncementCopyWith(this, $identity);
}

abstract class AnnouncementCopyWith<$R> {
  factory AnnouncementCopyWith(Announcement value, Then<Announcement, $R> then) = _AnnouncementCopyWithImpl<$R>;
  $R call({String? title, String? message, Color? textColor, Color? backgroundColor, bool? isDismissible});
  $R apply(Announcement Function(Announcement) transform);
}

class _AnnouncementCopyWithImpl<$R> extends BaseCopyWith<Announcement, $R> implements AnnouncementCopyWith<$R> {
  _AnnouncementCopyWithImpl(Announcement value, Then<Announcement, $R> then) : super(value, then);

  @override
  $R call(
          {Object? title = $none,
          String? message,
          Object? textColor = $none,
          Object? backgroundColor = $none,
          bool? isDismissible}) =>
      $then(Announcement(
          title: or(title, $value.title),
          message: message ?? $value.message,
          textColor: or(textColor, $value.textColor),
          backgroundColor: or(backgroundColor, $value.backgroundColor),
          isDismissible: isDismissible ?? $value.isDismissible));
}

class EliminationGameMapper extends BaseMapper<EliminationGame> {
  EliminationGameMapper._();

  @override
  Function get decoder => decode;
  EliminationGame decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  EliminationGame fromMap(Map<String, dynamic> map) => EliminationGame(
      map.get('id'), map.get('name'), map.get('startedAt'), map.get('initialTargets'), map.get('eliminations'));

  @override
  Function get encoder => (EliminationGame v) => encode(v);
  dynamic encode(EliminationGame v) => toMap(v);
  Map<String, dynamic> toMap(EliminationGame e) => {
        'id': Mapper.toValue(e.id),
        'name': Mapper.toValue(e.name),
        'startedAt': Mapper.toValue(e.startedAt),
        'initialTargets': Mapper.toValue(e.initialTargets),
        'eliminations': Mapper.toValue(e.eliminations)
      };

  @override
  String? stringify(EliminationGame self) =>
      'EliminationGame(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)}, startedAt: ${Mapper.asString(self.startedAt)}, initialTargets: ${Mapper.asString(self.initialTargets)}, eliminations: ${Mapper.asString(self.eliminations)})';
  @override
  int? hash(EliminationGame self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.name) ^
      Mapper.hash(self.startedAt) ^
      Mapper.hash(self.initialTargets) ^
      Mapper.hash(self.eliminations);
  @override
  bool? equals(EliminationGame self, EliminationGame other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.name, other.name) &&
      Mapper.isEqual(self.startedAt, other.startedAt) &&
      Mapper.isEqual(self.initialTargets, other.initialTargets) &&
      Mapper.isEqual(self.eliminations, other.eliminations);

  @override
  Function get typeFactory => (f) => f<EliminationGame>();
}

extension EliminationGameMapperExtension on EliminationGame {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  EliminationGameCopyWith<EliminationGame> get copyWith => EliminationGameCopyWith(this, $identity);
}

abstract class EliminationGameCopyWith<$R> {
  factory EliminationGameCopyWith(EliminationGame value, Then<EliminationGame, $R> then) =
      _EliminationGameCopyWithImpl<$R>;
  ListCopyWith<$R, EliminationEntry, EliminationEntryCopyWith<$R>> get eliminations;
  $R call(
      {String? id,
      String? name,
      DateTime? startedAt,
      Map<String, String>? initialTargets,
      List<EliminationEntry>? eliminations});
  $R apply(EliminationGame Function(EliminationGame) transform);
}

class _EliminationGameCopyWithImpl<$R> extends BaseCopyWith<EliminationGame, $R>
    implements EliminationGameCopyWith<$R> {
  _EliminationGameCopyWithImpl(EliminationGame value, Then<EliminationGame, $R> then) : super(value, then);

  @override
  ListCopyWith<$R, EliminationEntry, EliminationEntryCopyWith<$R>> get eliminations =>
      ListCopyWith($value.eliminations, (v, t) => EliminationEntryCopyWith(v, t), (v) => call(eliminations: v));
  @override
  $R call(
          {String? id,
          String? name,
          DateTime? startedAt,
          Map<String, String>? initialTargets,
          List<EliminationEntry>? eliminations}) =>
      $then(EliminationGame(id ?? $value.id, name ?? $value.name, startedAt ?? $value.startedAt,
          initialTargets ?? $value.initialTargets, eliminations ?? $value.eliminations));
}

class EliminationEntryMapper extends BaseMapper<EliminationEntry> {
  EliminationEntryMapper._();

  @override
  Function get decoder => decode;
  EliminationEntry decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  EliminationEntry fromMap(Map<String, dynamic> map) =>
      EliminationEntry(map.get('target'), map.get('eliminatedBy'), map.get('description'), map.get('time'));

  @override
  Function get encoder => (EliminationEntry v) => encode(v);
  dynamic encode(EliminationEntry v) => toMap(v);
  Map<String, dynamic> toMap(EliminationEntry e) => {
        'target': Mapper.toValue(e.target),
        'eliminatedBy': Mapper.toValue(e.eliminatedBy),
        'description': Mapper.toValue(e.description),
        'time': Mapper.toValue(e.time)
      };

  @override
  String? stringify(EliminationEntry self) =>
      'EliminationEntry(target: ${Mapper.asString(self.target)}, eliminatedBy: ${Mapper.asString(self.eliminatedBy)}, description: ${Mapper.asString(self.description)}, time: ${Mapper.asString(self.time)})';
  @override
  int? hash(EliminationEntry self) =>
      Mapper.hash(self.target) ^
      Mapper.hash(self.eliminatedBy) ^
      Mapper.hash(self.description) ^
      Mapper.hash(self.time);
  @override
  bool? equals(EliminationEntry self, EliminationEntry other) =>
      Mapper.isEqual(self.target, other.target) &&
      Mapper.isEqual(self.eliminatedBy, other.eliminatedBy) &&
      Mapper.isEqual(self.description, other.description) &&
      Mapper.isEqual(self.time, other.time);

  @override
  Function get typeFactory => (f) => f<EliminationEntry>();
}

extension EliminationEntryMapperExtension on EliminationEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  EliminationEntryCopyWith<EliminationEntry> get copyWith => EliminationEntryCopyWith(this, $identity);
}

abstract class EliminationEntryCopyWith<$R> {
  factory EliminationEntryCopyWith(EliminationEntry value, Then<EliminationEntry, $R> then) =
      _EliminationEntryCopyWithImpl<$R>;
  $R call({String? target, String? eliminatedBy, String? description, DateTime? time});
  $R apply(EliminationEntry Function(EliminationEntry) transform);
}

class _EliminationEntryCopyWithImpl<$R> extends BaseCopyWith<EliminationEntry, $R>
    implements EliminationEntryCopyWith<$R> {
  _EliminationEntryCopyWithImpl(EliminationEntry value, Then<EliminationEntry, $R> then) : super(value, then);

  @override
  $R call({String? target, String? eliminatedBy, String? description, DateTime? time}) => $then(EliminationEntry(
      target ?? $value.target,
      eliminatedBy ?? $value.eliminatedBy,
      description ?? $value.description,
      time ?? $value.time));
}

class NoteMapper extends BaseMapper<Note> {
  NoteMapper._();

  @override
  Function get decoder => decode;
  Note decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  Note fromMap(Map<String, dynamic> map) => Note(map.get('id'), map.getOpt('title'), map.get('content'),
      folder: map.getOpt('folder'),
      isArchived: map.getOpt('isArchived') ?? false,
      author: map.get('author'),
      editors: map.getOpt('editors') ?? const []);

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
      'Note(id: ${Mapper.asString(self.id)}, title: ${Mapper.asString(self.title)}, content: ${Mapper.asString(self.content)}, folder: ${Mapper.asString(self.folder)}, isArchived: ${Mapper.asString(self.isArchived)}, author: ${Mapper.asString(self.author)}, editors: ${Mapper.asString(self.editors)})';
  @override
  int? hash(Note self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.title) ^
      Mapper.hash(self.content) ^
      Mapper.hash(self.folder) ^
      Mapper.hash(self.isArchived) ^
      Mapper.hash(self.author) ^
      Mapper.hash(self.editors);
  @override
  bool? equals(Note self, Note other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.title, other.title) &&
      Mapper.isEqual(self.content, other.content) &&
      Mapper.isEqual(self.folder, other.folder) &&
      Mapper.isEqual(self.isArchived, other.isArchived) &&
      Mapper.isEqual(self.author, other.author) &&
      Mapper.isEqual(self.editors, other.editors);

  @override
  Function get typeFactory => (f) => f<Note>();
}

extension NoteMapperExtension on Note {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  NoteCopyWith<Note> get copyWith => NoteCopyWith(this, $identity);
}

abstract class NoteCopyWith<$R> {
  factory NoteCopyWith(Note value, Then<Note, $R> then) = _NoteCopyWithImpl<$R>;
  $R call(
      {String? id,
      String? title,
      List<dynamic>? content,
      String? folder,
      bool? isArchived,
      String? author,
      List<String>? editors});
  $R apply(Note Function(Note) transform);
}

class _NoteCopyWithImpl<$R> extends BaseCopyWith<Note, $R> implements NoteCopyWith<$R> {
  _NoteCopyWithImpl(Note value, Then<Note, $R> then) : super(value, then);

  @override
  $R call(
          {String? id,
          Object? title = $none,
          List<dynamic>? content,
          Object? folder = $none,
          bool? isArchived,
          String? author,
          List<String>? editors}) =>
      $then(Note(id ?? $value.id, or(title, $value.title), content ?? $value.content,
          folder: or(folder, $value.folder),
          isArchived: isArchived ?? $value.isArchived,
          author: author ?? $value.author,
          editors: editors ?? $value.editors));
}

class PollMapper extends BaseMapper<Poll> {
  PollMapper._();

  @override
  Function get decoder => decode;
  Poll decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  Poll fromMap(Map<String, dynamic> map) =>
      Poll(map.get('id'), map.get('name'), map.get('startedAt'), map.get('steps'));

  @override
  Function get encoder => (Poll v) => encode(v);
  dynamic encode(Poll v) => toMap(v);
  Map<String, dynamic> toMap(Poll p) => {
        'id': Mapper.toValue(p.id),
        'name': Mapper.toValue(p.name),
        'startedAt': Mapper.toValue(p.startedAt),
        'steps': Mapper.toValue(p.steps)
      };

  @override
  String? stringify(Poll self) =>
      'Poll(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)}, startedAt: ${Mapper.asString(self.startedAt)}, steps: ${Mapper.asString(self.steps)})';
  @override
  int? hash(Poll self) =>
      Mapper.hash(self.id) ^ Mapper.hash(self.name) ^ Mapper.hash(self.startedAt) ^ Mapper.hash(self.steps);
  @override
  bool? equals(Poll self, Poll other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.name, other.name) &&
      Mapper.isEqual(self.startedAt, other.startedAt) &&
      Mapper.isEqual(self.steps, other.steps);

  @override
  Function get typeFactory => (f) => f<Poll>();
}

extension PollMapperExtension on Poll {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  PollCopyWith<Poll> get copyWith => PollCopyWith(this, $identity);
}

abstract class PollCopyWith<$R> {
  factory PollCopyWith(Poll value, Then<Poll, $R> then) = _PollCopyWithImpl<$R>;
  ListCopyWith<$R, PollStep, PollStepCopyWith<$R>> get steps;
  $R call({String? id, String? name, DateTime? startedAt, List<PollStep>? steps});
  $R apply(Poll Function(Poll) transform);
}

class _PollCopyWithImpl<$R> extends BaseCopyWith<Poll, $R> implements PollCopyWith<$R> {
  _PollCopyWithImpl(Poll value, Then<Poll, $R> then) : super(value, then);

  @override
  ListCopyWith<$R, PollStep, PollStepCopyWith<$R>> get steps =>
      ListCopyWith($value.steps, (v, t) => PollStepCopyWith(v, t), (v) => call(steps: v));
  @override
  $R call({String? id, String? name, DateTime? startedAt, List<PollStep>? steps}) =>
      $then(Poll(id ?? $value.id, name ?? $value.name, startedAt ?? $value.startedAt, steps ?? $value.steps));
}

class PollStepMapper extends BaseMapper<PollStep> {
  PollStepMapper._();

  @override
  Function get decoder => decode;
  PollStep decode(dynamic v) => checked(v, (Map<String, dynamic> map) {
        switch (map['type']) {
          case 'multiple-choice':
            return MultipleChoiceQuestionMapper._().decode(map);
          default:
            return fromMap(map);
        }
      });
  PollStep fromMap(Map<String, dynamic> map) => PollStep(map.get('type'));

  @override
  Function get encoder => (PollStep v) => encode(v);
  dynamic encode(PollStep v) {
    if (v is MultipleChoiceQuestion) {
      return MultipleChoiceQuestionMapper._().encode(v);
    } else {
      return toMap(v);
    }
  }

  Map<String, dynamic> toMap(PollStep p) => {'type': Mapper.toValue(p.type)};

  @override
  String? stringify(PollStep self) => 'PollStep(type: ${Mapper.asString(self.type)})';
  @override
  int? hash(PollStep self) => Mapper.hash(self.type);
  @override
  bool? equals(PollStep self, PollStep other) => Mapper.isEqual(self.type, other.type);

  @override
  Function get typeFactory => (f) => f<PollStep>();
}

extension PollStepMapperExtension on PollStep {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  PollStepCopyWith<PollStep> get copyWith => PollStepCopyWith(this, $identity);
}

abstract class PollStepCopyWith<$R> {
  factory PollStepCopyWith(PollStep value, Then<PollStep, $R> then) = _PollStepCopyWithImpl<$R>;
  $R call({String? type});
  $R apply(PollStep Function(PollStep) transform);
}

class _PollStepCopyWithImpl<$R> extends BaseCopyWith<PollStep, $R> implements PollStepCopyWith<$R> {
  _PollStepCopyWithImpl(PollStep value, Then<PollStep, $R> then) : super(value, then);

  @override
  $R call({String? type}) => $then(PollStep(type ?? $value.type));
}

class MultipleChoiceQuestionMapper extends BaseMapper<MultipleChoiceQuestion> {
  MultipleChoiceQuestionMapper._();

  @override
  Function get decoder => decode;
  MultipleChoiceQuestion decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  MultipleChoiceQuestion fromMap(Map<String, dynamic> map) =>
      MultipleChoiceQuestion(map.get('choices'), map.get('multiselect'), map.get('type'));

  @override
  Function get encoder => (MultipleChoiceQuestion v) => encode(v);
  dynamic encode(MultipleChoiceQuestion v) => toMap(v);
  Map<String, dynamic> toMap(MultipleChoiceQuestion m) => {
        'choices': Mapper.toValue(m.choices),
        'multiselect': Mapper.toValue(m.multiselect),
        'type': Mapper.toValue(m.type)
      };

  @override
  String? stringify(MultipleChoiceQuestion self) =>
      'MultipleChoiceQuestion(type: ${Mapper.asString(self.type)}, choices: ${Mapper.asString(self.choices)}, multiselect: ${Mapper.asString(self.multiselect)})';
  @override
  int? hash(MultipleChoiceQuestion self) =>
      Mapper.hash(self.choices) ^ Mapper.hash(self.multiselect) ^ Mapper.hash(self.type);
  @override
  bool? equals(MultipleChoiceQuestion self, MultipleChoiceQuestion other) =>
      Mapper.isEqual(self.choices, other.choices) &&
      Mapper.isEqual(self.multiselect, other.multiselect) &&
      Mapper.isEqual(self.type, other.type);

  @override
  Function get typeFactory => (f) => f<MultipleChoiceQuestion>();
}

extension MultipleChoiceQuestionMapperExtension on MultipleChoiceQuestion {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  MultipleChoiceQuestionCopyWith<MultipleChoiceQuestion> get copyWith =>
      MultipleChoiceQuestionCopyWith(this, $identity);
}

abstract class MultipleChoiceQuestionCopyWith<$R> {
  factory MultipleChoiceQuestionCopyWith(MultipleChoiceQuestion value, Then<MultipleChoiceQuestion, $R> then) =
      _MultipleChoiceQuestionCopyWithImpl<$R>;
  $R call({List<String>? choices, bool? multiselect, String? type});
  $R apply(MultipleChoiceQuestion Function(MultipleChoiceQuestion) transform);
}

class _MultipleChoiceQuestionCopyWithImpl<$R> extends BaseCopyWith<MultipleChoiceQuestion, $R>
    implements MultipleChoiceQuestionCopyWith<$R> {
  _MultipleChoiceQuestionCopyWithImpl(MultipleChoiceQuestion value, Then<MultipleChoiceQuestion, $R> then)
      : super(value, then);

  @override
  $R call({List<String>? choices, bool? multiselect, String? type}) =>
      $then(MultipleChoiceQuestion(choices ?? $value.choices, multiselect ?? $value.multiselect, type ?? $value.type));
}

class TheButtonStateMapper extends BaseMapper<TheButtonState> {
  TheButtonStateMapper._();

  @override
  Function get decoder => decode;
  TheButtonState decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  TheButtonState fromMap(Map<String, dynamic> map) =>
      TheButtonState(map.get('lastReset'), map.get('aliveHours'), map.get('leaderboard'),
          showInAvatars: map.getOpt('showInAvatars') ?? false);

  @override
  Function get encoder => (TheButtonState v) => encode(v);
  dynamic encode(TheButtonState v) => toMap(v);
  Map<String, dynamic> toMap(TheButtonState t) => {
        'lastReset': Mapper.toValue(t.lastReset),
        'aliveHours': Mapper.toValue(t.aliveHours),
        'leaderboard': Mapper.toValue(t.leaderboard),
        'showInAvatars': Mapper.toValue(t.showInAvatars)
      };

  @override
  String? stringify(TheButtonState self) =>
      'TheButtonState(lastReset: ${Mapper.asString(self.lastReset)}, aliveHours: ${Mapper.asString(self.aliveHours)}, leaderboard: ${Mapper.asString(self.leaderboard)}, showInAvatars: ${Mapper.asString(self.showInAvatars)})';
  @override
  int? hash(TheButtonState self) =>
      Mapper.hash(self.lastReset) ^
      Mapper.hash(self.aliveHours) ^
      Mapper.hash(self.leaderboard) ^
      Mapper.hash(self.showInAvatars);
  @override
  bool? equals(TheButtonState self, TheButtonState other) =>
      Mapper.isEqual(self.lastReset, other.lastReset) &&
      Mapper.isEqual(self.aliveHours, other.aliveHours) &&
      Mapper.isEqual(self.leaderboard, other.leaderboard) &&
      Mapper.isEqual(self.showInAvatars, other.showInAvatars);

  @override
  Function get typeFactory => (f) => f<TheButtonState>();
}

extension TheButtonStateMapperExtension on TheButtonState {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  TheButtonStateCopyWith<TheButtonState> get copyWith => TheButtonStateCopyWith(this, $identity);
}

abstract class TheButtonStateCopyWith<$R> {
  factory TheButtonStateCopyWith(TheButtonState value, Then<TheButtonState, $R> then) = _TheButtonStateCopyWithImpl<$R>;
  $R call({Timestamp? lastReset, double? aliveHours, Map<String, int>? leaderboard, bool? showInAvatars});
  $R apply(TheButtonState Function(TheButtonState) transform);
}

class _TheButtonStateCopyWithImpl<$R> extends BaseCopyWith<TheButtonState, $R> implements TheButtonStateCopyWith<$R> {
  _TheButtonStateCopyWithImpl(TheButtonState value, Then<TheButtonState, $R> then) : super(value, then);

  @override
  $R call({Timestamp? lastReset, double? aliveHours, Map<String, int>? leaderboard, bool? showInAvatars}) => $then(
      TheButtonState(lastReset ?? $value.lastReset, aliveHours ?? $value.aliveHours, leaderboard ?? $value.leaderboard,
          showInAvatars: showInAvatars ?? $value.showInAvatars));
}

class ChannelInfoMapper extends BaseMapper<ChannelInfo> {
  ChannelInfoMapper._();

  @override
  Function get decoder => decode;
  ChannelInfo decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChannelInfo fromMap(Map<String, dynamic> map) => ChannelInfo(
      id: map.get('id'),
      name: map.get('name'),
      isOpen: map.getOpt('isOpen') ?? true,
      members: map.getOpt('members') ?? const []);

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
      'ChannelInfo(name: ${Mapper.asString(self.name)}, id: ${Mapper.asString(self.id)}, isOpen: ${Mapper.asString(self.isOpen)}, members: ${Mapper.asString(self.members)})';
  @override
  int? hash(ChannelInfo self) =>
      Mapper.hash(self.id) ^ Mapper.hash(self.name) ^ Mapper.hash(self.isOpen) ^ Mapper.hash(self.members);
  @override
  bool? equals(ChannelInfo self, ChannelInfo other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.name, other.name) &&
      Mapper.isEqual(self.isOpen, other.isOpen) &&
      Mapper.isEqual(self.members, other.members);

  @override
  Function get typeFactory => (f) => f<ChannelInfo>();
}

extension ChannelInfoMapperExtension on ChannelInfo {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChannelInfoCopyWith<ChannelInfo> get copyWith => ChannelInfoCopyWith(this, $identity);
}

abstract class ChannelInfoCopyWith<$R> {
  factory ChannelInfoCopyWith(ChannelInfo value, Then<ChannelInfo, $R> then) = _ChannelInfoCopyWithImpl<$R>;
  $R call({String? id, String? name, bool? isOpen, List<String>? members});
  $R apply(ChannelInfo Function(ChannelInfo) transform);
}

class _ChannelInfoCopyWithImpl<$R> extends BaseCopyWith<ChannelInfo, $R> implements ChannelInfoCopyWith<$R> {
  _ChannelInfoCopyWithImpl(ChannelInfo value, Then<ChannelInfo, $R> then) : super(value, then);

  @override
  $R call({String? id, String? name, bool? isOpen, List<String>? members}) => $then(ChannelInfo(
      id: id ?? $value.id,
      name: name ?? $value.name,
      isOpen: isOpen ?? $value.isOpen,
      members: members ?? $value.members));
}

class ChatMessageMapper extends BaseMapper<ChatMessage> {
  ChatMessageMapper._();

  @override
  Function get decoder => decode;
  ChatMessage decode(dynamic v) => checked(v, (Map<String, dynamic> map) {
        switch (map['type']) {
          case 'file':
            return ChatFileMessageMapper._().decode(map);
          case 'image':
            return ChatImageMessageMapper._().decode(map);
          case 'text':
            return ChatTextMessageMapper._().decode(map);
          default:
            return fromMap(map);
        }
      });
  ChatMessage fromMap(Map<String, dynamic> map) =>
      ChatMessage(sender: map.get('sender'), text: map.get('text'), sentAt: map.get('sentAt'));

  @override
  Function get encoder => (ChatMessage v) => encode(v);
  dynamic encode(ChatMessage v) {
    if (v is ChatTextMessage) {
      return ChatTextMessageMapper._().encode(v);
    } else if (v is ChatImageMessage) {
      return ChatImageMessageMapper._().encode(v);
    } else if (v is ChatFileMessage) {
      return ChatFileMessageMapper._().encode(v);
    } else {
      return toMap(v);
    }
  }

  Map<String, dynamic> toMap(ChatMessage c) =>
      {'sender': Mapper.toValue(c.sender), 'text': Mapper.toValue(c.text), 'sentAt': Mapper.toValue(c.sentAt)};

  @override
  String? stringify(ChatMessage self) =>
      'ChatMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)})';
  @override
  int? hash(ChatMessage self) => Mapper.hash(self.sender) ^ Mapper.hash(self.text) ^ Mapper.hash(self.sentAt);
  @override
  bool? equals(ChatMessage self, ChatMessage other) =>
      Mapper.isEqual(self.sender, other.sender) &&
      Mapper.isEqual(self.text, other.text) &&
      Mapper.isEqual(self.sentAt, other.sentAt);

  @override
  Function get typeFactory => (f) => f<ChatMessage>();
}

extension ChatMessageMapperExtension on ChatMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatMessageCopyWith<ChatMessage> get copyWith => ChatMessageCopyWith(this, $identity);
}

abstract class ChatMessageCopyWith<$R> {
  factory ChatMessageCopyWith(ChatMessage value, Then<ChatMessage, $R> then) = _ChatMessageCopyWithImpl<$R>;
  $R call({String? sender, String? text, DateTime? sentAt});
  $R apply(ChatMessage Function(ChatMessage) transform);
}

class _ChatMessageCopyWithImpl<$R> extends BaseCopyWith<ChatMessage, $R> implements ChatMessageCopyWith<$R> {
  _ChatMessageCopyWithImpl(ChatMessage value, Then<ChatMessage, $R> then) : super(value, then);

  @override
  $R call({String? sender, String? text, DateTime? sentAt}) =>
      $then(ChatMessage(sender: sender ?? $value.sender, text: text ?? $value.text, sentAt: sentAt ?? $value.sentAt));
}

class ChatTextMessageMapper extends BaseMapper<ChatTextMessage> {
  ChatTextMessageMapper._();

  @override
  Function get decoder => decode;
  ChatTextMessage decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChatTextMessage fromMap(Map<String, dynamic> map) =>
      ChatTextMessage(sender: map.get('sender'), text: map.get('text'), sentAt: map.get('sentAt'));

  @override
  Function get encoder => (ChatTextMessage v) => encode(v);
  dynamic encode(ChatTextMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatTextMessage c) => {
        'sender': Mapper.toValue(c.sender),
        'text': Mapper.toValue(c.text),
        'sentAt': Mapper.toValue(c.sentAt),
        'type': 'text'
      };

  @override
  String? stringify(ChatTextMessage self) =>
      'ChatTextMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)})';
  @override
  int? hash(ChatTextMessage self) => Mapper.hash(self.sender) ^ Mapper.hash(self.text) ^ Mapper.hash(self.sentAt);
  @override
  bool? equals(ChatTextMessage self, ChatTextMessage other) =>
      Mapper.isEqual(self.sender, other.sender) &&
      Mapper.isEqual(self.text, other.text) &&
      Mapper.isEqual(self.sentAt, other.sentAt);

  @override
  Function get typeFactory => (f) => f<ChatTextMessage>();
}

extension ChatTextMessageMapperExtension on ChatTextMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatTextMessageCopyWith<ChatTextMessage> get copyWith => ChatTextMessageCopyWith(this, $identity);
}

abstract class ChatTextMessageCopyWith<$R> {
  factory ChatTextMessageCopyWith(ChatTextMessage value, Then<ChatTextMessage, $R> then) =
      _ChatTextMessageCopyWithImpl<$R>;
  $R call({String? sender, String? text, DateTime? sentAt});
  $R apply(ChatTextMessage Function(ChatTextMessage) transform);
}

class _ChatTextMessageCopyWithImpl<$R> extends BaseCopyWith<ChatTextMessage, $R>
    implements ChatTextMessageCopyWith<$R> {
  _ChatTextMessageCopyWithImpl(ChatTextMessage value, Then<ChatTextMessage, $R> then) : super(value, then);

  @override
  $R call({String? sender, String? text, DateTime? sentAt}) => $then(
      ChatTextMessage(sender: sender ?? $value.sender, text: text ?? $value.text, sentAt: sentAt ?? $value.sentAt));
}

class ChatImageMessageMapper extends BaseMapper<ChatImageMessage> {
  ChatImageMessageMapper._();

  @override
  Function get decoder => decode;
  ChatImageMessage decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChatImageMessage fromMap(Map<String, dynamic> map) => ChatImageMessage(
      uri: map.get('uri'),
      size: map.get('size'),
      sender: map.get('sender'),
      text: map.get('text'),
      sentAt: map.get('sentAt'));

  @override
  Function get encoder => (ChatImageMessage v) => encode(v);
  dynamic encode(ChatImageMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatImageMessage c) => {
        'uri': Mapper.toValue(c.uri),
        'size': Mapper.toValue(c.size),
        'sender': Mapper.toValue(c.sender),
        'text': Mapper.toValue(c.text),
        'sentAt': Mapper.toValue(c.sentAt),
        'type': 'image'
      };

  @override
  String? stringify(ChatImageMessage self) =>
      'ChatImageMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)}, uri: ${Mapper.asString(self.uri)}, size: ${Mapper.asString(self.size)})';
  @override
  int? hash(ChatImageMessage self) =>
      Mapper.hash(self.uri) ^
      Mapper.hash(self.size) ^
      Mapper.hash(self.sender) ^
      Mapper.hash(self.text) ^
      Mapper.hash(self.sentAt);
  @override
  bool? equals(ChatImageMessage self, ChatImageMessage other) =>
      Mapper.isEqual(self.uri, other.uri) &&
      Mapper.isEqual(self.size, other.size) &&
      Mapper.isEqual(self.sender, other.sender) &&
      Mapper.isEqual(self.text, other.text) &&
      Mapper.isEqual(self.sentAt, other.sentAt);

  @override
  Function get typeFactory => (f) => f<ChatImageMessage>();
}

extension ChatImageMessageMapperExtension on ChatImageMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatImageMessageCopyWith<ChatImageMessage> get copyWith => ChatImageMessageCopyWith(this, $identity);
}

abstract class ChatImageMessageCopyWith<$R> {
  factory ChatImageMessageCopyWith(ChatImageMessage value, Then<ChatImageMessage, $R> then) =
      _ChatImageMessageCopyWithImpl<$R>;
  $R call({String? uri, int? size, String? sender, String? text, DateTime? sentAt});
  $R apply(ChatImageMessage Function(ChatImageMessage) transform);
}

class _ChatImageMessageCopyWithImpl<$R> extends BaseCopyWith<ChatImageMessage, $R>
    implements ChatImageMessageCopyWith<$R> {
  _ChatImageMessageCopyWithImpl(ChatImageMessage value, Then<ChatImageMessage, $R> then) : super(value, then);

  @override
  $R call({String? uri, int? size, String? sender, String? text, DateTime? sentAt}) => $then(ChatImageMessage(
      uri: uri ?? $value.uri,
      size: size ?? $value.size,
      sender: sender ?? $value.sender,
      text: text ?? $value.text,
      sentAt: sentAt ?? $value.sentAt));
}

class ChatFileMessageMapper extends BaseMapper<ChatFileMessage> {
  ChatFileMessageMapper._();

  @override
  Function get decoder => decode;
  ChatFileMessage decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChatFileMessage fromMap(Map<String, dynamic> map) => ChatFileMessage(
      uri: map.get('uri'),
      size: map.get('size'),
      sender: map.get('sender'),
      text: map.get('text'),
      sentAt: map.get('sentAt'));

  @override
  Function get encoder => (ChatFileMessage v) => encode(v);
  dynamic encode(ChatFileMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatFileMessage c) => {
        'uri': Mapper.toValue(c.uri),
        'size': Mapper.toValue(c.size),
        'sender': Mapper.toValue(c.sender),
        'text': Mapper.toValue(c.text),
        'sentAt': Mapper.toValue(c.sentAt),
        'type': 'file'
      };

  @override
  String? stringify(ChatFileMessage self) =>
      'ChatFileMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)}, uri: ${Mapper.asString(self.uri)}, size: ${Mapper.asString(self.size)})';
  @override
  int? hash(ChatFileMessage self) =>
      Mapper.hash(self.uri) ^
      Mapper.hash(self.size) ^
      Mapper.hash(self.sender) ^
      Mapper.hash(self.text) ^
      Mapper.hash(self.sentAt);
  @override
  bool? equals(ChatFileMessage self, ChatFileMessage other) =>
      Mapper.isEqual(self.uri, other.uri) &&
      Mapper.isEqual(self.size, other.size) &&
      Mapper.isEqual(self.sender, other.sender) &&
      Mapper.isEqual(self.text, other.text) &&
      Mapper.isEqual(self.sentAt, other.sentAt);

  @override
  Function get typeFactory => (f) => f<ChatFileMessage>();
}

extension ChatFileMessageMapperExtension on ChatFileMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatFileMessageCopyWith<ChatFileMessage> get copyWith => ChatFileMessageCopyWith(this, $identity);
}

abstract class ChatFileMessageCopyWith<$R> {
  factory ChatFileMessageCopyWith(ChatFileMessage value, Then<ChatFileMessage, $R> then) =
      _ChatFileMessageCopyWithImpl<$R>;
  $R call({String? uri, int? size, String? sender, String? text, DateTime? sentAt});
  $R apply(ChatFileMessage Function(ChatFileMessage) transform);
}

class _ChatFileMessageCopyWithImpl<$R> extends BaseCopyWith<ChatFileMessage, $R>
    implements ChatFileMessageCopyWith<$R> {
  _ChatFileMessageCopyWithImpl(ChatFileMessage value, Then<ChatFileMessage, $R> then) : super(value, then);

  @override
  $R call({String? uri, int? size, String? sender, String? text, DateTime? sentAt}) => $then(ChatFileMessage(
      uri: uri ?? $value.uri,
      size: size ?? $value.size,
      sender: sender ?? $value.sender,
      text: text ?? $value.text,
      sentAt: sentAt ?? $value.sentAt));
}

class MusicConfigMapper extends BaseMapper<MusicConfig> {
  MusicConfigMapper._();

  @override
  Function get decoder => decode;
  MusicConfig decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  MusicConfig fromMap(Map<String, dynamic> map) => MusicConfig(
      credentials: map.getOpt('credentials'), player: map.getOpt('player'), playlist: map.getOpt('playlist'));

  @override
  Function get encoder => (MusicConfig v) => encode(v);
  dynamic encode(MusicConfig v) => toMap(v);
  Map<String, dynamic> toMap(MusicConfig m) => {
        'credentials': Mapper.toValue(m.credentials),
        'player': Mapper.toValue(m.player),
        'playlist': Mapper.toValue(m.playlist)
      };

  @override
  String? stringify(MusicConfig self) =>
      'MusicConfig(credentials: ${Mapper.asString(self.credentials)}, playlist: ${Mapper.asString(self.playlist)}, player: ${Mapper.asString(self.player)})';
  @override
  int? hash(MusicConfig self) => Mapper.hash(self.credentials) ^ Mapper.hash(self.player) ^ Mapper.hash(self.playlist);
  @override
  bool? equals(MusicConfig self, MusicConfig other) =>
      Mapper.isEqual(self.credentials, other.credentials) &&
      Mapper.isEqual(self.player, other.player) &&
      Mapper.isEqual(self.playlist, other.playlist);

  @override
  Function get typeFactory => (f) => f<MusicConfig>();
}

extension MusicConfigMapperExtension on MusicConfig {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  MusicConfigCopyWith<MusicConfig> get copyWith => MusicConfigCopyWith(this, $identity);
}

abstract class MusicConfigCopyWith<$R> {
  factory MusicConfigCopyWith(MusicConfig value, Then<MusicConfig, $R> then) = _MusicConfigCopyWithImpl<$R>;
  SpotifyCredentialsCopyWith<$R>? get credentials;
  SpotifyPlayerCopyWith<$R>? get player;
  SpotifyPlaylistCopyWith<$R>? get playlist;
  $R call({SpotifyCredentials? credentials, SpotifyPlayer? player, SpotifyPlaylist? playlist});
  $R apply(MusicConfig Function(MusicConfig) transform);
}

class _MusicConfigCopyWithImpl<$R> extends BaseCopyWith<MusicConfig, $R> implements MusicConfigCopyWith<$R> {
  _MusicConfigCopyWithImpl(MusicConfig value, Then<MusicConfig, $R> then) : super(value, then);

  @override
  SpotifyCredentialsCopyWith<$R>? get credentials =>
      $value.credentials != null ? SpotifyCredentialsCopyWith($value.credentials!, (v) => call(credentials: v)) : null;
  @override
  SpotifyPlayerCopyWith<$R>? get player =>
      $value.player != null ? SpotifyPlayerCopyWith($value.player!, (v) => call(player: v)) : null;
  @override
  SpotifyPlaylistCopyWith<$R>? get playlist =>
      $value.playlist != null ? SpotifyPlaylistCopyWith($value.playlist!, (v) => call(playlist: v)) : null;
  @override
  $R call({Object? credentials = $none, Object? player = $none, Object? playlist = $none}) => $then(MusicConfig(
      credentials: or(credentials, $value.credentials),
      player: or(player, $value.player),
      playlist: or(playlist, $value.playlist)));
}

class SpotifyPlayerMapper extends BaseMapper<SpotifyPlayer> {
  SpotifyPlayerMapper._();

  @override
  Function get decoder => decode;
  SpotifyPlayer decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyPlayer fromMap(Map<String, dynamic> map) =>
      SpotifyPlayer(map.get('track'), map.get('isPlaying'), map.getOpt('progressMs'));

  @override
  Function get encoder => (SpotifyPlayer v) => encode(v);
  dynamic encode(SpotifyPlayer v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyPlayer s) => {
        'track': Mapper.toValue(s.track),
        'isPlaying': Mapper.toValue(s.isPlaying),
        'progressMs': Mapper.toValue(s.progressMs)
      };

  @override
  String? stringify(SpotifyPlayer self) =>
      'SpotifyPlayer(track: ${Mapper.asString(self.track)}, isPlaying: ${Mapper.asString(self.isPlaying)}, progressMs: ${Mapper.asString(self.progressMs)})';
  @override
  int? hash(SpotifyPlayer self) => Mapper.hash(self.track) ^ Mapper.hash(self.isPlaying) ^ Mapper.hash(self.progressMs);
  @override
  bool? equals(SpotifyPlayer self, SpotifyPlayer other) =>
      Mapper.isEqual(self.track, other.track) &&
      Mapper.isEqual(self.isPlaying, other.isPlaying) &&
      Mapper.isEqual(self.progressMs, other.progressMs);

  @override
  Function get typeFactory => (f) => f<SpotifyPlayer>();
}

extension SpotifyPlayerMapperExtension on SpotifyPlayer {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyPlayerCopyWith<SpotifyPlayer> get copyWith => SpotifyPlayerCopyWith(this, $identity);
}

abstract class SpotifyPlayerCopyWith<$R> {
  factory SpotifyPlayerCopyWith(SpotifyPlayer value, Then<SpotifyPlayer, $R> then) = _SpotifyPlayerCopyWithImpl<$R>;
  SpotifyTrackCopyWith<$R> get track;
  $R call({SpotifyTrack? track, bool? isPlaying, int? progressMs});
  $R apply(SpotifyPlayer Function(SpotifyPlayer) transform);
}

class _SpotifyPlayerCopyWithImpl<$R> extends BaseCopyWith<SpotifyPlayer, $R> implements SpotifyPlayerCopyWith<$R> {
  _SpotifyPlayerCopyWithImpl(SpotifyPlayer value, Then<SpotifyPlayer, $R> then) : super(value, then);

  @override
  SpotifyTrackCopyWith<$R> get track => SpotifyTrackCopyWith($value.track, (v) => call(track: v));
  @override
  $R call({SpotifyTrack? track, bool? isPlaying, Object? progressMs = $none}) =>
      $then(SpotifyPlayer(track ?? $value.track, isPlaying ?? $value.isPlaying, or(progressMs, $value.progressMs)));
}

class SpotifyCredentialsMapper extends BaseMapper<SpotifyCredentials> {
  SpotifyCredentialsMapper._();

  @override
  Function get decoder => decode;
  SpotifyCredentials decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyCredentials fromMap(Map<String, dynamic> map) =>
      SpotifyCredentials(map.get('accessToken'), map.get('refreshToken'), map.get('expiration'));

  @override
  Function get encoder => (SpotifyCredentials v) => encode(v);
  dynamic encode(SpotifyCredentials v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyCredentials s) => {
        'accessToken': Mapper.toValue(s.accessToken),
        'refreshToken': Mapper.toValue(s.refreshToken),
        'expiration': Mapper.toValue(s.expiration)
      };

  @override
  String? stringify(SpotifyCredentials self) =>
      'SpotifyCredentials(accessToken: ${Mapper.asString(self.accessToken)}, refreshToken: ${Mapper.asString(self.refreshToken)}, expiration: ${Mapper.asString(self.expiration)})';
  @override
  int? hash(SpotifyCredentials self) =>
      Mapper.hash(self.accessToken) ^ Mapper.hash(self.refreshToken) ^ Mapper.hash(self.expiration);
  @override
  bool? equals(SpotifyCredentials self, SpotifyCredentials other) =>
      Mapper.isEqual(self.accessToken, other.accessToken) &&
      Mapper.isEqual(self.refreshToken, other.refreshToken) &&
      Mapper.isEqual(self.expiration, other.expiration);

  @override
  Function get typeFactory => (f) => f<SpotifyCredentials>();
}

extension SpotifyCredentialsMapperExtension on SpotifyCredentials {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyCredentialsCopyWith<SpotifyCredentials> get copyWith => SpotifyCredentialsCopyWith(this, $identity);
}

abstract class SpotifyCredentialsCopyWith<$R> {
  factory SpotifyCredentialsCopyWith(SpotifyCredentials value, Then<SpotifyCredentials, $R> then) =
      _SpotifyCredentialsCopyWithImpl<$R>;
  $R call({String? accessToken, String? refreshToken, Timestamp? expiration});
  $R apply(SpotifyCredentials Function(SpotifyCredentials) transform);
}

class _SpotifyCredentialsCopyWithImpl<$R> extends BaseCopyWith<SpotifyCredentials, $R>
    implements SpotifyCredentialsCopyWith<$R> {
  _SpotifyCredentialsCopyWithImpl(SpotifyCredentials value, Then<SpotifyCredentials, $R> then) : super(value, then);

  @override
  $R call({String? accessToken, String? refreshToken, Timestamp? expiration}) => $then(SpotifyCredentials(
      accessToken ?? $value.accessToken, refreshToken ?? $value.refreshToken, expiration ?? $value.expiration));
}

class SpotifyPlaylistMapper extends BaseMapper<SpotifyPlaylist> {
  SpotifyPlaylistMapper._();

  @override
  Function get decoder => decode;
  SpotifyPlaylist decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyPlaylist fromMap(Map<String, dynamic> map) => SpotifyPlaylist(
      map.get('id'), map.get('name'), map.get('images'), map.get('uri'), map.get('spotifyUrl'), map.get('tracks'));

  @override
  Function get encoder => (SpotifyPlaylist v) => encode(v);
  dynamic encode(SpotifyPlaylist v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyPlaylist s) => {
        'id': Mapper.toValue(s.id),
        'name': Mapper.toValue(s.name),
        'images': Mapper.toValue(s.images),
        'uri': Mapper.toValue(s.uri),
        'spotifyUrl': Mapper.toValue(s.spotifyUrl),
        'tracks': Mapper.toValue(s.tracks)
      };

  @override
  String? stringify(SpotifyPlaylist self) =>
      'SpotifyPlaylist(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)}, images: ${Mapper.asString(self.images)}, uri: ${Mapper.asString(self.uri)}, spotifyUrl: ${Mapper.asString(self.spotifyUrl)}, tracks: ${Mapper.asString(self.tracks)})';
  @override
  int? hash(SpotifyPlaylist self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.name) ^
      Mapper.hash(self.images) ^
      Mapper.hash(self.uri) ^
      Mapper.hash(self.spotifyUrl) ^
      Mapper.hash(self.tracks);
  @override
  bool? equals(SpotifyPlaylist self, SpotifyPlaylist other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.name, other.name) &&
      Mapper.isEqual(self.images, other.images) &&
      Mapper.isEqual(self.uri, other.uri) &&
      Mapper.isEqual(self.spotifyUrl, other.spotifyUrl) &&
      Mapper.isEqual(self.tracks, other.tracks);

  @override
  Function get typeFactory => (f) => f<SpotifyPlaylist>();
}

extension SpotifyPlaylistMapperExtension on SpotifyPlaylist {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyPlaylistCopyWith<SpotifyPlaylist> get copyWith => SpotifyPlaylistCopyWith(this, $identity);
}

abstract class SpotifyPlaylistCopyWith<$R> {
  factory SpotifyPlaylistCopyWith(SpotifyPlaylist value, Then<SpotifyPlaylist, $R> then) =
      _SpotifyPlaylistCopyWithImpl<$R>;
  ListCopyWith<$R, SpotifyImage, SpotifyImageCopyWith<$R>> get images;
  ListCopyWith<$R, SpotifyTrack, SpotifyTrackCopyWith<$R>> get tracks;
  $R call(
      {String? id,
      String? name,
      List<SpotifyImage>? images,
      String? uri,
      String? spotifyUrl,
      List<SpotifyTrack>? tracks});
  $R apply(SpotifyPlaylist Function(SpotifyPlaylist) transform);
}

class _SpotifyPlaylistCopyWithImpl<$R> extends BaseCopyWith<SpotifyPlaylist, $R>
    implements SpotifyPlaylistCopyWith<$R> {
  _SpotifyPlaylistCopyWithImpl(SpotifyPlaylist value, Then<SpotifyPlaylist, $R> then) : super(value, then);

  @override
  ListCopyWith<$R, SpotifyImage, SpotifyImageCopyWith<$R>> get images =>
      ListCopyWith($value.images, (v, t) => SpotifyImageCopyWith(v, t), (v) => call(images: v));
  @override
  ListCopyWith<$R, SpotifyTrack, SpotifyTrackCopyWith<$R>> get tracks =>
      ListCopyWith($value.tracks, (v, t) => SpotifyTrackCopyWith(v, t), (v) => call(tracks: v));
  @override
  $R call(
          {String? id,
          String? name,
          List<SpotifyImage>? images,
          String? uri,
          String? spotifyUrl,
          List<SpotifyTrack>? tracks}) =>
      $then(SpotifyPlaylist(id ?? $value.id, name ?? $value.name, images ?? $value.images, uri ?? $value.uri,
          spotifyUrl ?? $value.spotifyUrl, tracks ?? $value.tracks));
}

class SpotifyTrackMapper extends BaseMapper<SpotifyTrack> {
  SpotifyTrackMapper._();

  @override
  Function get decoder => decode;
  SpotifyTrack decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyTrack fromMap(Map<String, dynamic> map) => SpotifyTrack(
      map.get('name'), map.get('id'), map.get('uri'), map.get('album'), map.get('artists'), map.get('durationMs'));

  @override
  Function get encoder => (SpotifyTrack v) => encode(v);
  dynamic encode(SpotifyTrack v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyTrack s) => {
        'name': Mapper.toValue(s.name),
        'id': Mapper.toValue(s.id),
        'uri': Mapper.toValue(s.uri),
        'album': Mapper.toValue(s.album),
        'artists': Mapper.toValue(s.artists),
        'durationMs': Mapper.toValue(s.durationMs)
      };

  @override
  String? stringify(SpotifyTrack self) =>
      'SpotifyTrack(name: ${Mapper.asString(self.name)}, id: ${Mapper.asString(self.id)}, uri: ${Mapper.asString(self.uri)}, album: ${Mapper.asString(self.album)}, artists: ${Mapper.asString(self.artists)}, durationMs: ${Mapper.asString(self.durationMs)})';
  @override
  int? hash(SpotifyTrack self) =>
      Mapper.hash(self.name) ^
      Mapper.hash(self.id) ^
      Mapper.hash(self.uri) ^
      Mapper.hash(self.album) ^
      Mapper.hash(self.artists) ^
      Mapper.hash(self.durationMs);
  @override
  bool? equals(SpotifyTrack self, SpotifyTrack other) =>
      Mapper.isEqual(self.name, other.name) &&
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.uri, other.uri) &&
      Mapper.isEqual(self.album, other.album) &&
      Mapper.isEqual(self.artists, other.artists) &&
      Mapper.isEqual(self.durationMs, other.durationMs);

  @override
  Function get typeFactory => (f) => f<SpotifyTrack>();
}

extension SpotifyTrackMapperExtension on SpotifyTrack {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyTrackCopyWith<SpotifyTrack> get copyWith => SpotifyTrackCopyWith(this, $identity);
}

abstract class SpotifyTrackCopyWith<$R> {
  factory SpotifyTrackCopyWith(SpotifyTrack value, Then<SpotifyTrack, $R> then) = _SpotifyTrackCopyWithImpl<$R>;
  SpotifyAlbumCopyWith<$R> get album;
  ListCopyWith<$R, SpotifyArtist, SpotifyArtistCopyWith<$R>> get artists;
  $R call({String? name, String? id, String? uri, SpotifyAlbum? album, List<SpotifyArtist>? artists, int? durationMs});
  $R apply(SpotifyTrack Function(SpotifyTrack) transform);
}

class _SpotifyTrackCopyWithImpl<$R> extends BaseCopyWith<SpotifyTrack, $R> implements SpotifyTrackCopyWith<$R> {
  _SpotifyTrackCopyWithImpl(SpotifyTrack value, Then<SpotifyTrack, $R> then) : super(value, then);

  @override
  SpotifyAlbumCopyWith<$R> get album => SpotifyAlbumCopyWith($value.album, (v) => call(album: v));
  @override
  ListCopyWith<$R, SpotifyArtist, SpotifyArtistCopyWith<$R>> get artists =>
      ListCopyWith($value.artists, (v, t) => SpotifyArtistCopyWith(v, t), (v) => call(artists: v));
  @override
  $R call(
          {String? name,
          String? id,
          String? uri,
          SpotifyAlbum? album,
          List<SpotifyArtist>? artists,
          int? durationMs}) =>
      $then(SpotifyTrack(name ?? $value.name, id ?? $value.id, uri ?? $value.uri, album ?? $value.album,
          artists ?? $value.artists, durationMs ?? $value.durationMs));
}

class SpotifyAlbumMapper extends BaseMapper<SpotifyAlbum> {
  SpotifyAlbumMapper._();

  @override
  Function get decoder => decode;
  SpotifyAlbum decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyAlbum fromMap(Map<String, dynamic> map) =>
      SpotifyAlbum(map.get('id'), map.get('uri'), map.get('name'), map.get('images'));

  @override
  Function get encoder => (SpotifyAlbum v) => encode(v);
  dynamic encode(SpotifyAlbum v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyAlbum s) => {
        'id': Mapper.toValue(s.id),
        'uri': Mapper.toValue(s.uri),
        'name': Mapper.toValue(s.name),
        'images': Mapper.toValue(s.images)
      };

  @override
  String? stringify(SpotifyAlbum self) =>
      'SpotifyAlbum(id: ${Mapper.asString(self.id)}, uri: ${Mapper.asString(self.uri)}, name: ${Mapper.asString(self.name)}, images: ${Mapper.asString(self.images)})';
  @override
  int? hash(SpotifyAlbum self) =>
      Mapper.hash(self.id) ^ Mapper.hash(self.uri) ^ Mapper.hash(self.name) ^ Mapper.hash(self.images);
  @override
  bool? equals(SpotifyAlbum self, SpotifyAlbum other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.uri, other.uri) &&
      Mapper.isEqual(self.name, other.name) &&
      Mapper.isEqual(self.images, other.images);

  @override
  Function get typeFactory => (f) => f<SpotifyAlbum>();
}

extension SpotifyAlbumMapperExtension on SpotifyAlbum {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyAlbumCopyWith<SpotifyAlbum> get copyWith => SpotifyAlbumCopyWith(this, $identity);
}

abstract class SpotifyAlbumCopyWith<$R> {
  factory SpotifyAlbumCopyWith(SpotifyAlbum value, Then<SpotifyAlbum, $R> then) = _SpotifyAlbumCopyWithImpl<$R>;
  ListCopyWith<$R, SpotifyImage, SpotifyImageCopyWith<$R>> get images;
  $R call({String? id, String? uri, String? name, List<SpotifyImage>? images});
  $R apply(SpotifyAlbum Function(SpotifyAlbum) transform);
}

class _SpotifyAlbumCopyWithImpl<$R> extends BaseCopyWith<SpotifyAlbum, $R> implements SpotifyAlbumCopyWith<$R> {
  _SpotifyAlbumCopyWithImpl(SpotifyAlbum value, Then<SpotifyAlbum, $R> then) : super(value, then);

  @override
  ListCopyWith<$R, SpotifyImage, SpotifyImageCopyWith<$R>> get images =>
      ListCopyWith($value.images, (v, t) => SpotifyImageCopyWith(v, t), (v) => call(images: v));
  @override
  $R call({String? id, String? uri, String? name, List<SpotifyImage>? images}) =>
      $then(SpotifyAlbum(id ?? $value.id, uri ?? $value.uri, name ?? $value.name, images ?? $value.images));
}

class SpotifyImageMapper extends BaseMapper<SpotifyImage> {
  SpotifyImageMapper._();

  @override
  Function get decoder => decode;
  SpotifyImage decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyImage fromMap(Map<String, dynamic> map) => SpotifyImage(map.get('height'), map.get('width'), map.get('url'));

  @override
  Function get encoder => (SpotifyImage v) => encode(v);
  dynamic encode(SpotifyImage v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyImage s) =>
      {'height': Mapper.toValue(s.height), 'width': Mapper.toValue(s.width), 'url': Mapper.toValue(s.url)};

  @override
  String? stringify(SpotifyImage self) =>
      'SpotifyImage(height: ${Mapper.asString(self.height)}, width: ${Mapper.asString(self.width)}, url: ${Mapper.asString(self.url)})';
  @override
  int? hash(SpotifyImage self) => Mapper.hash(self.height) ^ Mapper.hash(self.width) ^ Mapper.hash(self.url);
  @override
  bool? equals(SpotifyImage self, SpotifyImage other) =>
      Mapper.isEqual(self.height, other.height) &&
      Mapper.isEqual(self.width, other.width) &&
      Mapper.isEqual(self.url, other.url);

  @override
  Function get typeFactory => (f) => f<SpotifyImage>();
}

extension SpotifyImageMapperExtension on SpotifyImage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyImageCopyWith<SpotifyImage> get copyWith => SpotifyImageCopyWith(this, $identity);
}

abstract class SpotifyImageCopyWith<$R> {
  factory SpotifyImageCopyWith(SpotifyImage value, Then<SpotifyImage, $R> then) = _SpotifyImageCopyWithImpl<$R>;
  $R call({int? height, int? width, String? url});
  $R apply(SpotifyImage Function(SpotifyImage) transform);
}

class _SpotifyImageCopyWithImpl<$R> extends BaseCopyWith<SpotifyImage, $R> implements SpotifyImageCopyWith<$R> {
  _SpotifyImageCopyWithImpl(SpotifyImage value, Then<SpotifyImage, $R> then) : super(value, then);

  @override
  $R call({int? height, int? width, String? url}) =>
      $then(SpotifyImage(height ?? $value.height, width ?? $value.width, url ?? $value.url));
}

class SpotifyArtistMapper extends BaseMapper<SpotifyArtist> {
  SpotifyArtistMapper._();

  @override
  Function get decoder => decode;
  SpotifyArtist decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SpotifyArtist fromMap(Map<String, dynamic> map) => SpotifyArtist(map.get('id'), map.get('name'));

  @override
  Function get encoder => (SpotifyArtist v) => encode(v);
  dynamic encode(SpotifyArtist v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyArtist s) => {'id': Mapper.toValue(s.id), 'name': Mapper.toValue(s.name)};

  @override
  String? stringify(SpotifyArtist self) =>
      'SpotifyArtist(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)})';
  @override
  int? hash(SpotifyArtist self) => Mapper.hash(self.id) ^ Mapper.hash(self.name);
  @override
  bool? equals(SpotifyArtist self, SpotifyArtist other) =>
      Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.name, other.name);

  @override
  Function get typeFactory => (f) => f<SpotifyArtist>();
}

extension SpotifyArtistMapperExtension on SpotifyArtist {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SpotifyArtistCopyWith<SpotifyArtist> get copyWith => SpotifyArtistCopyWith(this, $identity);
}

abstract class SpotifyArtistCopyWith<$R> {
  factory SpotifyArtistCopyWith(SpotifyArtist value, Then<SpotifyArtist, $R> then) = _SpotifyArtistCopyWithImpl<$R>;
  $R call({String? id, String? name});
  $R apply(SpotifyArtist Function(SpotifyArtist) transform);
}

class _SpotifyArtistCopyWithImpl<$R> extends BaseCopyWith<SpotifyArtist, $R> implements SpotifyArtistCopyWith<$R> {
  _SpotifyArtistCopyWithImpl(SpotifyArtist value, Then<SpotifyArtist, $R> then) : super(value, then);

  @override
  $R call({String? id, String? name}) => $then(SpotifyArtist(id ?? $value.id, name ?? $value.name));
}

class AlbumShortcutMapper extends BaseMapper<AlbumShortcut> {
  AlbumShortcutMapper._();

  @override
  Function get decoder => decode;
  AlbumShortcut decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  AlbumShortcut fromMap(Map<String, dynamic> map) => AlbumShortcut(
      map.get('id'), map.getOpt('title'), map.get('albumUrl'), map.get('coverUrl'), map.getOpt('itemsCount'));

  @override
  Function get encoder => (AlbumShortcut v) => encode(v);
  dynamic encode(AlbumShortcut v) => toMap(v);
  Map<String, dynamic> toMap(AlbumShortcut a) => {
        'id': Mapper.toValue(a.id),
        'title': Mapper.toValue(a.title),
        'albumUrl': Mapper.toValue(a.albumUrl),
        'coverUrl': Mapper.toValue(a.coverUrl),
        'itemsCount': Mapper.toValue(a.itemsCount)
      };

  @override
  String? stringify(AlbumShortcut self) =>
      'AlbumShortcut(id: ${Mapper.asString(self.id)}, title: ${Mapper.asString(self.title)}, albumUrl: ${Mapper.asString(self.albumUrl)}, coverUrl: ${Mapper.asString(self.coverUrl)}, itemsCount: ${Mapper.asString(self.itemsCount)})';
  @override
  int? hash(AlbumShortcut self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.title) ^
      Mapper.hash(self.albumUrl) ^
      Mapper.hash(self.coverUrl) ^
      Mapper.hash(self.itemsCount);
  @override
  bool? equals(AlbumShortcut self, AlbumShortcut other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.title, other.title) &&
      Mapper.isEqual(self.albumUrl, other.albumUrl) &&
      Mapper.isEqual(self.coverUrl, other.coverUrl) &&
      Mapper.isEqual(self.itemsCount, other.itemsCount);

  @override
  Function get typeFactory => (f) => f<AlbumShortcut>();
}

extension AlbumShortcutMapperExtension on AlbumShortcut {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  AlbumShortcutCopyWith<AlbumShortcut> get copyWith => AlbumShortcutCopyWith(this, $identity);
}

abstract class AlbumShortcutCopyWith<$R> {
  factory AlbumShortcutCopyWith(AlbumShortcut value, Then<AlbumShortcut, $R> then) = _AlbumShortcutCopyWithImpl<$R>;
  $R call({String? id, String? title, String? albumUrl, String? coverUrl, String? itemsCount});
  $R apply(AlbumShortcut Function(AlbumShortcut) transform);
}

class _AlbumShortcutCopyWithImpl<$R> extends BaseCopyWith<AlbumShortcut, $R> implements AlbumShortcutCopyWith<$R> {
  _AlbumShortcutCopyWithImpl(AlbumShortcut value, Then<AlbumShortcut, $R> then) : super(value, then);

  @override
  $R call({String? id, Object? title = $none, String? albumUrl, String? coverUrl, Object? itemsCount = $none}) =>
      $then(AlbumShortcut(id ?? $value.id, or(title, $value.title), albumUrl ?? $value.albumUrl,
          coverUrl ?? $value.coverUrl, or(itemsCount, $value.itemsCount)));
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

mixin Mappable {
  BaseMapper? get _mapper => Mapper.get(runtimeType);

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

extension MapGet on Map<String, dynamic> {
  T get<T>(String key, {MappingHooks? hooks}) =>
      _getOr(key, hooks, () => throw MapperException('Parameter $key is required.'));

  T? getOpt<T>(String key, {MappingHooks? hooks}) => _getOr(key, hooks, () => null);

  T _getOr<T>(String key, MappingHooks? hooks, T Function() or) =>
      hooks.decode(this[key], (v) => v == null ? or() : Mapper.fromValue<T>(v));
}
