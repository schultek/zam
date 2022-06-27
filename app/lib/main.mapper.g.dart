import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:dart_mappable/internals.dart';
import 'package:shared/api/modules/announcement.dart';
import 'package:shared/api/modules/chat.dart';
import 'package:shared/models/core/user.dart';

import 'core/layouts/drops_layout.dart';
import 'core/layouts/focus_layout.dart';
import 'core/layouts/full_page_layout.dart';
import 'core/layouts/grid_layout.dart';
import 'core/layouts/layout_model.dart';
import 'core/models/group.dart';
import 'core/models/models.dart';
import 'core/module/module_builder.dart';
import 'core/module/module_context.dart';
import 'core/templates/swipe/swipe_template.dart';
import 'core/templates/template_model.dart';
import 'core/themes/theme_model.dart';
import 'modules/announcement/announcement.module.dart';
import 'modules/chat/chat.module.dart';
import 'modules/counter/counter_module.dart';
import 'modules/elimination/elimination.module.dart';
import 'modules/labels/labels.module.dart';
import 'modules/music/music.module.dart';
import 'modules/notes/notes.module.dart';
import 'modules/polls/polls.module.dart';
import 'modules/profile/profile.module.dart';
import 'modules/split/split.module.dart';
import 'modules/thebutton/thebutton.module.dart';
import 'modules/web/web_module.dart';
import 'providers/links/shortcuts_provider.dart';
import 'screens/admin/providers/admin_groups_provider.dart';
import 'screens/admin/providers/admin_users_provider.dart';

// === ALL STATICALLY REGISTERED MAPPERS ===

var _mappers = <BaseMapper>{
  // class mappers
  LaunchThemeMapper._(),
  ModuleMessageMapper._(),
  ModuleIdMapper._(),
  ThemeModelMapper._(),
  GroupMapper._(),
  GroupUserMapper._(),
  SwipeTemplateModelMapper._(),
  TemplateModelMapper._(),
  SwipeTemplatePageMapper._(),
  TemplatePageMapper._(),
  AnnouncementMapper._(),
  ChannelInfoMapper._(),
  ChatMessageMapper._(),
  ChatTextMessageMapper._(),
  ChatImageMessageMapper._(),
  ChatFileMessageMapper._(),
  EliminationGameMapper._(),
  EliminationEntryMapper._(),
  LabelParamsMapper._(),
  PlayerParamsMapper._(),
  MusicConfigMapper._(),
  SpotifyPlayerMapper._(),
  SpotifyCredentialsMapper._(),
  SpotifyPlaylistMapper._(),
  SpotifyTrackMapper._(),
  SpotifyAlbumMapper._(),
  SpotifyImageMapper._(),
  SpotifyArtistMapper._(),
  NotesListParamsMapper._(),
  NoteMapper._(),
  PollMapper._(),
  PollStepMapper._(),
  MultipleChoiceQuestionMapper._(),
  ProfileImageElementParamsMapper._(),
  BalancesListParamsMapper._(),
  BalanceFocusParamsMapper._(),
  SplitStateMapper._(),
  BillingStatsMapper._(),
  SplitSpendingsMapper._(),
  SplitSpendingMapper._(),
  BillingRatesMapper._(),
  SplitTemplateMapper._(),
  BalanceEntryMapper._(),
  BillingEntryMapper._(),
  SplitPotMapper._(),
  SplitEntryMapper._(),
  SplitSourceMapper._(),
  ExpenseEntryMapper._(),
  PaymentEntryMapper._(),
  ExchangeEntryMapper._(),
  ExpenseTargetMapper._(),
  TheButtonStateMapper._(),
  LaunchUrlParamsMapper._(),
  WebPageParamsMapper._(),
  CounterStateMapper._(),
  LayoutModelMapper._(),
  UserDataMapper._(),
  UserMetadataMapper._(),
  UserInfoMapper._(),
  UserClaimsMapper._(),
  AnnouncementNotificationMapper._(),
  ChatNotificationMapper._(),
  GroupFilterMapper._(),
  UserFilterMapper._(),
  DropModelMapper._(),
  DropsLayoutModelMapper._(),
  FocusLayoutModelMapper._(),
  FullPageLayoutModelMapper._(),
  GridLayoutModelMapper._(),
  // enum mappers
  LabelColorMapper._(),
  CurrencyMapper._(),
  SplitSourceTypeMapper._(),
  ExpenseTargetTypeMapper._(),
  UserStatusMapper._(),
  // custom mappers
  ColorMapper(),
};

// === GENERATED CLASS MAPPERS AND EXTENSIONS ===

class LaunchThemeMapper extends BaseMapper<LaunchTheme> {
  LaunchThemeMapper._();

  @override
  Function get decoder => decode;
  LaunchTheme decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  LaunchTheme fromMap(Map<String, dynamic> map) => LaunchTheme(Mapper.i.$get(map, 'name'), Mapper.i.$get(map, 'theme'));

  @override
  Function get encoder => (LaunchTheme v) => encode(v);
  dynamic encode(LaunchTheme v) => toMap(v);
  Map<String, dynamic> toMap(LaunchTheme l) =>
      {'name': Mapper.i.$enc(l.name, 'name'), 'theme': Mapper.i.$enc(l.theme, 'theme')};

  @override
  String stringify(LaunchTheme self) =>
      'LaunchTheme(name: ${Mapper.asString(self.name)}, theme: ${Mapper.asString(self.theme)})';
  @override
  int hash(LaunchTheme self) => Mapper.hash(self.name) ^ Mapper.hash(self.theme);
  @override
  bool equals(LaunchTheme self, LaunchTheme other) =>
      Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.theme, other.theme);

  @override
  Function get typeFactory => (f) => f<LaunchTheme>();
}

extension LaunchThemeMapperExtension on LaunchTheme {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  LaunchThemeCopyWith<LaunchTheme> get copyWith => LaunchThemeCopyWith(this, $identity);
}

abstract class LaunchThemeCopyWith<$R> {
  factory LaunchThemeCopyWith(LaunchTheme value, Then<LaunchTheme, $R> then) = _LaunchThemeCopyWithImpl<$R>;
  ThemeModelCopyWith<$R> get theme;
  $R call({String? name, ThemeModel? theme});
  $R apply(LaunchTheme Function(LaunchTheme) transform);
}

class _LaunchThemeCopyWithImpl<$R> extends BaseCopyWith<LaunchTheme, $R> implements LaunchThemeCopyWith<$R> {
  _LaunchThemeCopyWithImpl(LaunchTheme value, Then<LaunchTheme, $R> then) : super(value, then);

  @override
  ThemeModelCopyWith<$R> get theme => ThemeModelCopyWith($value.theme, (v) => call(theme: v));
  @override
  $R call({String? name, ThemeModel? theme}) => $then(LaunchTheme(name ?? $value.name, theme ?? $value.theme));
}

class ModuleMessageMapper extends BaseMapper<ModuleMessage> {
  ModuleMessageMapper._();

  @override
  Function get decoder => decode;
  ModuleMessage decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ModuleMessage fromMap(Map<String, dynamic> map) => ModuleMessage(Mapper.i.$getOpt(map, 'moduleId'));

  @override
  Function get encoder => (ModuleMessage v) => encode(v);
  dynamic encode(ModuleMessage v) => toMap(v);
  Map<String, dynamic> toMap(ModuleMessage m) => {'moduleId': Mapper.i.$enc(m.moduleId, 'moduleId')};

  @override
  String stringify(ModuleMessage self) => 'ModuleMessage(moduleId: ${Mapper.asString(self.moduleId)})';
  @override
  int hash(ModuleMessage self) => Mapper.hash(self.moduleId);
  @override
  bool equals(ModuleMessage self, ModuleMessage other) => Mapper.isEqual(self.moduleId, other.moduleId);

  @override
  Function get typeFactory => (f) => f<ModuleMessage>();
}

extension ModuleMessageMapperExtension on ModuleMessage {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ModuleMessageCopyWith<ModuleMessage> get copyWith => ModuleMessageCopyWith(this, $identity);
}

abstract class ModuleMessageCopyWith<$R> {
  factory ModuleMessageCopyWith(ModuleMessage value, Then<ModuleMessage, $R> then) = _ModuleMessageCopyWithImpl<$R>;
  $R call({String? moduleId});
  $R apply(ModuleMessage Function(ModuleMessage) transform);
}

class _ModuleMessageCopyWithImpl<$R> extends BaseCopyWith<ModuleMessage, $R> implements ModuleMessageCopyWith<$R> {
  _ModuleMessageCopyWithImpl(ModuleMessage value, Then<ModuleMessage, $R> then) : super(value, then);

  @override
  $R call({Object? moduleId = $none}) => $then(ModuleMessage(or(moduleId, $value.moduleId)));
}

class ModuleIdMapper extends BaseMapper<ModuleId> {
  ModuleIdMapper._();

  @override
  Function get decoder => decode;
  ModuleId decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ModuleId fromMap(Map<String, dynamic> map) => ModuleId(Mapper.i.$get(map, 'moduleId'),
      Mapper.i.$get(map, 'elementId'), Mapper.i.$get(map, 'uniqueId'), Mapper.i.$getOpt(map, 'params'));

  @override
  Function get encoder => (ModuleId v) => encode(v);
  dynamic encode(ModuleId v) => toMap(v);
  Map<String, dynamic> toMap(ModuleId m) => {
        'moduleId': Mapper.i.$enc(m.moduleId, 'moduleId'),
        'elementId': Mapper.i.$enc(m.elementId, 'elementId'),
        'uniqueId': Mapper.i.$enc(m.uniqueId, 'uniqueId'),
        'params': Mapper.i.$enc(m.params, 'params')
      };

  @override
  String stringify(ModuleId self) =>
      'ModuleId(moduleId: ${Mapper.asString(self.moduleId)}, elementId: ${Mapper.asString(self.elementId)}, uniqueId: ${Mapper.asString(self.uniqueId)}, params: ${Mapper.asString(self.params)})';
  @override
  int hash(ModuleId self) =>
      Mapper.hash(self.moduleId) ^ Mapper.hash(self.elementId) ^ Mapper.hash(self.uniqueId) ^ Mapper.hash(self.params);
  @override
  bool equals(ModuleId self, ModuleId other) =>
      Mapper.isEqual(self.moduleId, other.moduleId) &&
      Mapper.isEqual(self.elementId, other.elementId) &&
      Mapper.isEqual(self.uniqueId, other.uniqueId) &&
      Mapper.isEqual(self.params, other.params);

  @override
  Function get typeFactory => (f) => f<ModuleId>();
}

extension ModuleIdMapperExtension on ModuleId {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ModuleIdCopyWith<ModuleId> get copyWith => ModuleIdCopyWith(this, $identity);
}

abstract class ModuleIdCopyWith<$R> {
  factory ModuleIdCopyWith(ModuleId value, Then<ModuleId, $R> then) = _ModuleIdCopyWithImpl<$R>;
  $R call({String? moduleId, String? elementId, String? uniqueId, dynamic params});
  $R apply(ModuleId Function(ModuleId) transform);
}

class _ModuleIdCopyWithImpl<$R> extends BaseCopyWith<ModuleId, $R> implements ModuleIdCopyWith<$R> {
  _ModuleIdCopyWithImpl(ModuleId value, Then<ModuleId, $R> then) : super(value, then);

  @override
  $R call({String? moduleId, String? elementId, String? uniqueId, Object? params = $none}) => $then(ModuleId(
      moduleId ?? $value.moduleId,
      elementId ?? $value.elementId,
      uniqueId ?? $value.uniqueId,
      or(params, $value.params)));
}

class ThemeModelMapper extends BaseMapper<ThemeModel> {
  ThemeModelMapper._();

  @override
  Function get decoder => decode;
  ThemeModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ThemeModel fromMap(Map<String, dynamic> map) =>
      ThemeModel(schemeIndex: Mapper.i.$get(map, 'schemeIndex'), dark: Mapper.i.$getOpt(map, 'dark') ?? false);

  @override
  Function get encoder => (ThemeModel v) => encode(v);
  dynamic encode(ThemeModel v) => toMap(v);
  Map<String, dynamic> toMap(ThemeModel t) =>
      {'schemeIndex': Mapper.i.$enc(t.schemeIndex, 'schemeIndex'), 'dark': Mapper.i.$enc(t.dark, 'dark')};

  @override
  String stringify(ThemeModel self) =>
      'ThemeModel(schemeIndex: ${Mapper.asString(self.schemeIndex)}, dark: ${Mapper.asString(self.dark)})';
  @override
  int hash(ThemeModel self) => Mapper.hash(self.schemeIndex) ^ Mapper.hash(self.dark);
  @override
  bool equals(ThemeModel self, ThemeModel other) =>
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

class GroupMapper extends BaseMapper<Group> {
  GroupMapper._();

  @override
  Function get decoder => decode;
  Group decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  Group fromMap(Map<String, dynamic> map) => Group(
      id: Mapper.i.$get(map, 'id'),
      name: Mapper.i.$get(map, 'name'),
      pictureUrl: Mapper.i.$getOpt(map, 'pictureUrl'),
      logoUrl: Mapper.i.$getOpt(map, 'logoUrl'),
      template: Mapper.i.$get(map, 'template'),
      theme: Mapper.i.$get(map, 'theme'),
      users: Mapper.i.$getOpt(map, 'users') ?? const {},
      modules: Mapper.i.$getOpt(map, 'modules') ?? const {},
      moduleBlacklist: Mapper.i.$getOpt(map, 'moduleBlacklist') ?? const []);

  @override
  Function get encoder => (Group v) => encode(v);
  dynamic encode(Group v) => toMap(v);
  Map<String, dynamic> toMap(Group g) => {
        'id': Mapper.i.$enc(g.id, 'id'),
        'name': Mapper.i.$enc(g.name, 'name'),
        'pictureUrl': Mapper.i.$enc(g.pictureUrl, 'pictureUrl'),
        'logoUrl': Mapper.i.$enc(g.logoUrl, 'logoUrl'),
        'template': Mapper.i.$enc(g.template, 'template'),
        'theme': Mapper.i.$enc(g.theme, 'theme'),
        'users': Mapper.i.$enc(g.users, 'users'),
        'modules': Mapper.i.$enc(g.modules, 'modules'),
        'moduleBlacklist': Mapper.i.$enc(g.moduleBlacklist, 'moduleBlacklist')
      };

  @override
  String stringify(Group self) =>
      'Group(name: ${Mapper.asString(self.name)}, id: ${Mapper.asString(self.id)}, pictureUrl: ${Mapper.asString(self.pictureUrl)}, logoUrl: ${Mapper.asString(self.logoUrl)}, template: ${Mapper.asString(self.template)}, theme: ${Mapper.asString(self.theme)}, users: ${Mapper.asString(self.users)}, modules: ${Mapper.asString(self.modules)}, moduleBlacklist: ${Mapper.asString(self.moduleBlacklist)})';
  @override
  int hash(Group self) =>
      Mapper.hash(self.name) ^
      Mapper.hash(self.id) ^
      Mapper.hash(self.pictureUrl) ^
      Mapper.hash(self.logoUrl) ^
      Mapper.hash(self.template) ^
      Mapper.hash(self.theme) ^
      Mapper.hash(self.users) ^
      Mapper.hash(self.modules) ^
      Mapper.hash(self.moduleBlacklist);
  @override
  bool equals(Group self, Group other) =>
      Mapper.isEqual(self.name, other.name) &&
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.pictureUrl, other.pictureUrl) &&
      Mapper.isEqual(self.logoUrl, other.logoUrl) &&
      Mapper.isEqual(self.template, other.template) &&
      Mapper.isEqual(self.theme, other.theme) &&
      Mapper.isEqual(self.users, other.users) &&
      Mapper.isEqual(self.modules, other.modules) &&
      Mapper.isEqual(self.moduleBlacklist, other.moduleBlacklist);

  @override
  Function get typeFactory => (f) => f<Group>();
}

extension GroupMapperExtension on Group {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  GroupCopyWith<Group> get copyWith => GroupCopyWith(this, $identity);
}

abstract class GroupCopyWith<$R> {
  factory GroupCopyWith(Group value, Then<Group, $R> then) = _GroupCopyWithImpl<$R>;
  ThemeModelCopyWith<$R> get theme;
  MapCopyWith<$R, String, GroupUser, GroupUserCopyWith<$R>> get users;
  $R call(
      {String? id,
      String? name,
      String? pictureUrl,
      String? logoUrl,
      TemplateModel? template,
      ThemeModel? theme,
      Map<String, GroupUser>? users,
      Map<String, List<String>>? modules,
      List<String>? moduleBlacklist});
  $R apply(Group Function(Group) transform);
}

class _GroupCopyWithImpl<$R> extends BaseCopyWith<Group, $R> implements GroupCopyWith<$R> {
  _GroupCopyWithImpl(Group value, Then<Group, $R> then) : super(value, then);

  @override
  ThemeModelCopyWith<$R> get theme => ThemeModelCopyWith($value.theme, (v) => call(theme: v));
  @override
  MapCopyWith<$R, String, GroupUser, GroupUserCopyWith<$R>> get users =>
      MapCopyWith($value.users, (v, t) => GroupUserCopyWith(v, t), (v) => call(users: v));
  @override
  $R call(
          {String? id,
          String? name,
          Object? pictureUrl = $none,
          Object? logoUrl = $none,
          TemplateModel? template,
          ThemeModel? theme,
          Map<String, GroupUser>? users,
          Map<String, List<String>>? modules,
          List<String>? moduleBlacklist}) =>
      $then(Group(
          id: id ?? $value.id,
          name: name ?? $value.name,
          pictureUrl: or(pictureUrl, $value.pictureUrl),
          logoUrl: or(logoUrl, $value.logoUrl),
          template: template ?? $value.template,
          theme: theme ?? $value.theme,
          users: users ?? $value.users,
          modules: modules ?? $value.modules,
          moduleBlacklist: moduleBlacklist ?? $value.moduleBlacklist));
}

class GroupUserMapper extends BaseMapper<GroupUser> {
  GroupUserMapper._();

  @override
  Function get decoder => decode;
  GroupUser decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  GroupUser fromMap(Map<String, dynamic> map) => GroupUser(
      role: Mapper.i.$getOpt(map, 'role') ?? UserRoles.participant,
      nickname: Mapper.i.$getOpt(map, 'nickname'),
      profileUrl: Mapper.i.$getOpt(map, 'profileUrl'));

  @override
  Function get encoder => (GroupUser v) => encode(v);
  dynamic encode(GroupUser v) => toMap(v);
  Map<String, dynamic> toMap(GroupUser g) => {
        'role': Mapper.i.$enc(g.role, 'role'),
        'nickname': Mapper.i.$enc(g.nickname, 'nickname'),
        'profileUrl': Mapper.i.$enc(g.profileUrl, 'profileUrl')
      };

  @override
  String stringify(GroupUser self) =>
      'GroupUser(role: ${Mapper.asString(self.role)}, nickname: ${Mapper.asString(self.nickname)}, profileUrl: ${Mapper.asString(self.profileUrl)})';
  @override
  int hash(GroupUser self) => Mapper.hash(self.role) ^ Mapper.hash(self.nickname) ^ Mapper.hash(self.profileUrl);
  @override
  bool equals(GroupUser self, GroupUser other) =>
      Mapper.isEqual(self.role, other.role) &&
      Mapper.isEqual(self.nickname, other.nickname) &&
      Mapper.isEqual(self.profileUrl, other.profileUrl);

  @override
  Function get typeFactory => (f) => f<GroupUser>();
}

extension GroupUserMapperExtension on GroupUser {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  GroupUserCopyWith<GroupUser> get copyWith => GroupUserCopyWith(this, $identity);
}

abstract class GroupUserCopyWith<$R> {
  factory GroupUserCopyWith(GroupUser value, Then<GroupUser, $R> then) = _GroupUserCopyWithImpl<$R>;
  $R call({String? role, String? nickname, String? profileUrl});
  $R apply(GroupUser Function(GroupUser) transform);
}

class _GroupUserCopyWithImpl<$R> extends BaseCopyWith<GroupUser, $R> implements GroupUserCopyWith<$R> {
  _GroupUserCopyWithImpl(GroupUser value, Then<GroupUser, $R> then) : super(value, then);

  @override
  $R call({String? role, Object? nickname = $none, Object? profileUrl = $none}) => $then(GroupUser(
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
      mainPage: Mapper.i.$getOpt(map, 'mainPage') ?? const SwipeTemplatePage(layout: GridLayoutModel()),
      leftPage: Mapper.i.$getOpt(map, 'leftPage'),
      rightPage: Mapper.i.$getOpt(map, 'rightPage'));

  @override
  Function get encoder => (SwipeTemplateModel v) => encode(v);
  dynamic encode(SwipeTemplateModel v) => toMap(v);
  Map<String, dynamic> toMap(SwipeTemplateModel s) => {
        'mainPage': Mapper.i.$enc(s.mainPage, 'mainPage'),
        'leftPage': Mapper.i.$enc(s.leftPage, 'leftPage'),
        'rightPage': Mapper.i.$enc(s.rightPage, 'rightPage'),
        'type': 'swipe'
      };

  @override
  String stringify(SwipeTemplateModel self) =>
      'SwipeTemplateModel(mainPage: ${Mapper.asString(self.mainPage)}, leftPage: ${Mapper.asString(self.leftPage)}, rightPage: ${Mapper.asString(self.rightPage)})';
  @override
  int hash(SwipeTemplateModel self) =>
      Mapper.hash(self.mainPage) ^ Mapper.hash(self.leftPage) ^ Mapper.hash(self.rightPage);
  @override
  bool equals(SwipeTemplateModel self, SwipeTemplateModel other) =>
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
  $R call({SwipeTemplatePage? mainPage, SwipeTemplatePage? leftPage, SwipeTemplatePage? rightPage});
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
  $R call({SwipeTemplatePage? mainPage, Object? leftPage = $none, Object? rightPage = $none}) =>
      $then(SwipeTemplateModel(
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
  TemplateModel fromMap(Map<String, dynamic> map) =>
      throw MapperException.missingSubclass('TemplateModel', 'type', '${map['type']}');

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
  String stringify(TemplateModel self) => 'TemplateModel()';
  @override
  int hash(TemplateModel self) => 0;
  @override
  bool equals(TemplateModel self, TemplateModel other) => true;

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
  SwipeTemplatePage fromMap(Map<String, dynamic> map) => SwipeTemplatePage(layout: Mapper.i.$get(map, 'layout'));

  @override
  Function get encoder => (SwipeTemplatePage v) => encode(v);
  dynamic encode(SwipeTemplatePage v) => toMap(v);
  Map<String, dynamic> toMap(SwipeTemplatePage s) => {'layout': Mapper.i.$enc(s.layout, 'layout'), 'type': 'swipe'};

  @override
  String stringify(SwipeTemplatePage self) => 'SwipeTemplatePage(layout: ${Mapper.asString(self.layout)})';
  @override
  int hash(SwipeTemplatePage self) => Mapper.hash(self.layout);
  @override
  bool equals(SwipeTemplatePage self, SwipeTemplatePage other) => Mapper.isEqual(self.layout, other.layout);

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
  String stringify(TemplatePage self) => 'TemplatePage()';
  @override
  int hash(TemplatePage self) => 0;
  @override
  bool equals(TemplatePage self, TemplatePage other) => true;

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

class AnnouncementMapper extends BaseMapper<Announcement> {
  AnnouncementMapper._();

  @override
  Function get decoder => decode;
  Announcement decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  Announcement fromMap(Map<String, dynamic> map) => Announcement(
      title: Mapper.i.$getOpt(map, 'title'),
      message: Mapper.i.$get(map, 'message'),
      textColor: Mapper.i.$getOpt(map, 'textColor'),
      backgroundColor: Mapper.i.$getOpt(map, 'backgroundColor'),
      isDismissible: Mapper.i.$getOpt(map, 'isDismissible') ?? false);

  @override
  Function get encoder => (Announcement v) => encode(v);
  dynamic encode(Announcement v) => toMap(v);
  Map<String, dynamic> toMap(Announcement a) => {
        'title': Mapper.i.$enc(a.title, 'title'),
        'message': Mapper.i.$enc(a.message, 'message'),
        'textColor': Mapper.i.$enc(a.textColor, 'textColor'),
        'backgroundColor': Mapper.i.$enc(a.backgroundColor, 'backgroundColor'),
        'isDismissible': Mapper.i.$enc(a.isDismissible, 'isDismissible')
      };

  @override
  String stringify(Announcement self) =>
      'Announcement(title: ${Mapper.asString(self.title)}, message: ${Mapper.asString(self.message)}, textColor: ${Mapper.asString(self.textColor)}, backgroundColor: ${Mapper.asString(self.backgroundColor)}, isDismissible: ${Mapper.asString(self.isDismissible)})';
  @override
  int hash(Announcement self) =>
      Mapper.hash(self.title) ^
      Mapper.hash(self.message) ^
      Mapper.hash(self.textColor) ^
      Mapper.hash(self.backgroundColor) ^
      Mapper.hash(self.isDismissible);
  @override
  bool equals(Announcement self, Announcement other) =>
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

class ChannelInfoMapper extends BaseMapper<ChannelInfo> {
  ChannelInfoMapper._();

  @override
  Function get decoder => decode;
  ChannelInfo decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChannelInfo fromMap(Map<String, dynamic> map) => ChannelInfo(
      id: Mapper.i.$get(map, 'id'),
      name: Mapper.i.$get(map, 'name'),
      isOpen: Mapper.i.$getOpt(map, 'isOpen') ?? true,
      members: Mapper.i.$getOpt(map, 'members') ?? const []);

  @override
  Function get encoder => (ChannelInfo v) => encode(v);
  dynamic encode(ChannelInfo v) => toMap(v);
  Map<String, dynamic> toMap(ChannelInfo c) => {
        'id': Mapper.i.$enc(c.id, 'id'),
        'name': Mapper.i.$enc(c.name, 'name'),
        'isOpen': Mapper.i.$enc(c.isOpen, 'isOpen'),
        'members': Mapper.i.$enc(c.members, 'members')
      };

  @override
  String stringify(ChannelInfo self) =>
      'ChannelInfo(name: ${Mapper.asString(self.name)}, id: ${Mapper.asString(self.id)}, isOpen: ${Mapper.asString(self.isOpen)}, members: ${Mapper.asString(self.members)})';
  @override
  int hash(ChannelInfo self) =>
      Mapper.hash(self.name) ^ Mapper.hash(self.id) ^ Mapper.hash(self.isOpen) ^ Mapper.hash(self.members);
  @override
  bool equals(ChannelInfo self, ChannelInfo other) =>
      Mapper.isEqual(self.name, other.name) &&
      Mapper.isEqual(self.id, other.id) &&
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
  ChatMessage fromMap(Map<String, dynamic> map) => ChatMessage(
      sender: Mapper.i.$get(map, 'sender'), text: Mapper.i.$get(map, 'text'), sentAt: Mapper.i.$get(map, 'sentAt'));

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

  Map<String, dynamic> toMap(ChatMessage c) => {
        'sender': Mapper.i.$enc(c.sender, 'sender'),
        'text': Mapper.i.$enc(c.text, 'text'),
        'sentAt': Mapper.i.$enc(c.sentAt, 'sentAt')
      };

  @override
  String stringify(ChatMessage self) =>
      'ChatMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)})';
  @override
  int hash(ChatMessage self) => Mapper.hash(self.sender) ^ Mapper.hash(self.text) ^ Mapper.hash(self.sentAt);
  @override
  bool equals(ChatMessage self, ChatMessage other) =>
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
  ChatTextMessage fromMap(Map<String, dynamic> map) => ChatTextMessage(
      sender: Mapper.i.$get(map, 'sender'), text: Mapper.i.$get(map, 'text'), sentAt: Mapper.i.$get(map, 'sentAt'));

  @override
  Function get encoder => (ChatTextMessage v) => encode(v);
  dynamic encode(ChatTextMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatTextMessage c) => {
        'sender': Mapper.i.$enc(c.sender, 'sender'),
        'text': Mapper.i.$enc(c.text, 'text'),
        'sentAt': Mapper.i.$enc(c.sentAt, 'sentAt'),
        'type': 'text'
      };

  @override
  String stringify(ChatTextMessage self) =>
      'ChatTextMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)})';
  @override
  int hash(ChatTextMessage self) => Mapper.hash(self.sender) ^ Mapper.hash(self.text) ^ Mapper.hash(self.sentAt);
  @override
  bool equals(ChatTextMessage self, ChatTextMessage other) =>
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
      uri: Mapper.i.$get(map, 'uri'),
      size: Mapper.i.$get(map, 'size'),
      sender: Mapper.i.$get(map, 'sender'),
      text: Mapper.i.$get(map, 'text'),
      sentAt: Mapper.i.$get(map, 'sentAt'));

  @override
  Function get encoder => (ChatImageMessage v) => encode(v);
  dynamic encode(ChatImageMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatImageMessage c) => {
        'uri': Mapper.i.$enc(c.uri, 'uri'),
        'size': Mapper.i.$enc(c.size, 'size'),
        'sender': Mapper.i.$enc(c.sender, 'sender'),
        'text': Mapper.i.$enc(c.text, 'text'),
        'sentAt': Mapper.i.$enc(c.sentAt, 'sentAt'),
        'type': 'image'
      };

  @override
  String stringify(ChatImageMessage self) =>
      'ChatImageMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)}, uri: ${Mapper.asString(self.uri)}, size: ${Mapper.asString(self.size)})';
  @override
  int hash(ChatImageMessage self) =>
      Mapper.hash(self.sender) ^
      Mapper.hash(self.text) ^
      Mapper.hash(self.sentAt) ^
      Mapper.hash(self.uri) ^
      Mapper.hash(self.size);
  @override
  bool equals(ChatImageMessage self, ChatImageMessage other) =>
      Mapper.isEqual(self.sender, other.sender) &&
      Mapper.isEqual(self.text, other.text) &&
      Mapper.isEqual(self.sentAt, other.sentAt) &&
      Mapper.isEqual(self.uri, other.uri) &&
      Mapper.isEqual(self.size, other.size);

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
      uri: Mapper.i.$get(map, 'uri'),
      size: Mapper.i.$get(map, 'size'),
      sender: Mapper.i.$get(map, 'sender'),
      text: Mapper.i.$get(map, 'text'),
      sentAt: Mapper.i.$get(map, 'sentAt'));

  @override
  Function get encoder => (ChatFileMessage v) => encode(v);
  dynamic encode(ChatFileMessage v) => toMap(v);
  Map<String, dynamic> toMap(ChatFileMessage c) => {
        'uri': Mapper.i.$enc(c.uri, 'uri'),
        'size': Mapper.i.$enc(c.size, 'size'),
        'sender': Mapper.i.$enc(c.sender, 'sender'),
        'text': Mapper.i.$enc(c.text, 'text'),
        'sentAt': Mapper.i.$enc(c.sentAt, 'sentAt'),
        'type': 'file'
      };

  @override
  String stringify(ChatFileMessage self) =>
      'ChatFileMessage(sender: ${Mapper.asString(self.sender)}, text: ${Mapper.asString(self.text)}, sentAt: ${Mapper.asString(self.sentAt)}, uri: ${Mapper.asString(self.uri)}, size: ${Mapper.asString(self.size)})';
  @override
  int hash(ChatFileMessage self) =>
      Mapper.hash(self.sender) ^
      Mapper.hash(self.text) ^
      Mapper.hash(self.sentAt) ^
      Mapper.hash(self.uri) ^
      Mapper.hash(self.size);
  @override
  bool equals(ChatFileMessage self, ChatFileMessage other) =>
      Mapper.isEqual(self.sender, other.sender) &&
      Mapper.isEqual(self.text, other.text) &&
      Mapper.isEqual(self.sentAt, other.sentAt) &&
      Mapper.isEqual(self.uri, other.uri) &&
      Mapper.isEqual(self.size, other.size);

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

class EliminationGameMapper extends BaseMapper<EliminationGame> {
  EliminationGameMapper._();

  @override
  Function get decoder => decode;
  EliminationGame decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  EliminationGame fromMap(Map<String, dynamic> map) => EliminationGame(
      Mapper.i.$get(map, 'id'),
      Mapper.i.$get(map, 'name'),
      Mapper.i.$get(map, 'startedAt'),
      Mapper.i.$get(map, 'initialTargets'),
      Mapper.i.$get(map, 'eliminations'));

  @override
  Function get encoder => (EliminationGame v) => encode(v);
  dynamic encode(EliminationGame v) => toMap(v);
  Map<String, dynamic> toMap(EliminationGame e) => {
        'id': Mapper.i.$enc(e.id, 'id'),
        'name': Mapper.i.$enc(e.name, 'name'),
        'startedAt': Mapper.i.$enc(e.startedAt, 'startedAt'),
        'initialTargets': Mapper.i.$enc(e.initialTargets, 'initialTargets'),
        'eliminations': Mapper.i.$enc(e.eliminations, 'eliminations')
      };

  @override
  String stringify(EliminationGame self) =>
      'EliminationGame(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)}, startedAt: ${Mapper.asString(self.startedAt)}, initialTargets: ${Mapper.asString(self.initialTargets)}, eliminations: ${Mapper.asString(self.eliminations)})';
  @override
  int hash(EliminationGame self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.name) ^
      Mapper.hash(self.startedAt) ^
      Mapper.hash(self.initialTargets) ^
      Mapper.hash(self.eliminations);
  @override
  bool equals(EliminationGame self, EliminationGame other) =>
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
  EliminationEntry fromMap(Map<String, dynamic> map) => EliminationEntry(Mapper.i.$get(map, 'target'),
      Mapper.i.$get(map, 'eliminatedBy'), Mapper.i.$get(map, 'description'), Mapper.i.$get(map, 'time'));

  @override
  Function get encoder => (EliminationEntry v) => encode(v);
  dynamic encode(EliminationEntry v) => toMap(v);
  Map<String, dynamic> toMap(EliminationEntry e) => {
        'target': Mapper.i.$enc(e.target, 'target'),
        'eliminatedBy': Mapper.i.$enc(e.eliminatedBy, 'eliminatedBy'),
        'description': Mapper.i.$enc(e.description, 'description'),
        'time': Mapper.i.$enc(e.time, 'time')
      };

  @override
  String stringify(EliminationEntry self) =>
      'EliminationEntry(target: ${Mapper.asString(self.target)}, eliminatedBy: ${Mapper.asString(self.eliminatedBy)}, description: ${Mapper.asString(self.description)}, time: ${Mapper.asString(self.time)})';
  @override
  int hash(EliminationEntry self) =>
      Mapper.hash(self.target) ^
      Mapper.hash(self.eliminatedBy) ^
      Mapper.hash(self.description) ^
      Mapper.hash(self.time);
  @override
  bool equals(EliminationEntry self, EliminationEntry other) =>
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

class LabelParamsMapper extends BaseMapper<LabelParams> {
  LabelParamsMapper._();

  @override
  Function get decoder => decode;
  LabelParams decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  LabelParams fromMap(Map<String, dynamic> map) => LabelParams(
      label: Mapper.i.$getOpt(map, 'label'),
      centered: Mapper.i.$getOpt(map, 'centered') ?? false,
      color: Mapper.i.$getOpt(map, 'color') ?? LabelColor.text);

  @override
  Function get encoder => (LabelParams v) => encode(v);
  dynamic encode(LabelParams v) => toMap(v);
  Map<String, dynamic> toMap(LabelParams l) => {
        'label': Mapper.i.$enc(l.label, 'label'),
        'centered': Mapper.i.$enc(l.centered, 'centered'),
        'color': Mapper.i.$enc(l.color, 'color')
      };

  @override
  String stringify(LabelParams self) =>
      'LabelParams(label: ${Mapper.asString(self.label)}, centered: ${Mapper.asString(self.centered)}, color: ${Mapper.asString(self.color)})';
  @override
  int hash(LabelParams self) => Mapper.hash(self.label) ^ Mapper.hash(self.centered) ^ Mapper.hash(self.color);
  @override
  bool equals(LabelParams self, LabelParams other) =>
      Mapper.isEqual(self.label, other.label) &&
      Mapper.isEqual(self.centered, other.centered) &&
      Mapper.isEqual(self.color, other.color);

  @override
  Function get typeFactory => (f) => f<LabelParams>();
}

extension LabelParamsMapperExtension on LabelParams {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  LabelParamsCopyWith<LabelParams> get copyWith => LabelParamsCopyWith(this, $identity);
}

abstract class LabelParamsCopyWith<$R> {
  factory LabelParamsCopyWith(LabelParams value, Then<LabelParams, $R> then) = _LabelParamsCopyWithImpl<$R>;
  $R call({String? label, bool? centered, LabelColor? color});
  $R apply(LabelParams Function(LabelParams) transform);
}

class _LabelParamsCopyWithImpl<$R> extends BaseCopyWith<LabelParams, $R> implements LabelParamsCopyWith<$R> {
  _LabelParamsCopyWithImpl(LabelParams value, Then<LabelParams, $R> then) : super(value, then);

  @override
  $R call({Object? label = $none, bool? centered, LabelColor? color}) => $then(
      LabelParams(label: or(label, $value.label), centered: centered ?? $value.centered, color: color ?? $value.color));
}

class PlayerParamsMapper extends BaseMapper<PlayerParams> {
  PlayerParamsMapper._();

  @override
  Function get decoder => decode;
  PlayerParams decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  PlayerParams fromMap(Map<String, dynamic> map) => PlayerParams(
      allowUserAccount: Mapper.i.$getOpt(map, 'allowUserAccount') ?? false,
      showPlayerControls: Mapper.i.$getOpt(map, 'showPlayerControls') ?? true,
      showPlaylistControls: Mapper.i.$getOpt(map, 'showPlaylistControls') ?? true);

  @override
  Function get encoder => (PlayerParams v) => encode(v);
  dynamic encode(PlayerParams v) => toMap(v);
  Map<String, dynamic> toMap(PlayerParams p) => {
        'allowUserAccount': Mapper.i.$enc(p.allowUserAccount, 'allowUserAccount'),
        'showPlayerControls': Mapper.i.$enc(p.showPlayerControls, 'showPlayerControls'),
        'showPlaylistControls': Mapper.i.$enc(p.showPlaylistControls, 'showPlaylistControls')
      };

  @override
  String stringify(PlayerParams self) =>
      'PlayerParams(allowUserAccount: ${Mapper.asString(self.allowUserAccount)}, showPlayerControls: ${Mapper.asString(self.showPlayerControls)}, showPlaylistControls: ${Mapper.asString(self.showPlaylistControls)})';
  @override
  int hash(PlayerParams self) =>
      Mapper.hash(self.allowUserAccount) ^
      Mapper.hash(self.showPlayerControls) ^
      Mapper.hash(self.showPlaylistControls);
  @override
  bool equals(PlayerParams self, PlayerParams other) =>
      Mapper.isEqual(self.allowUserAccount, other.allowUserAccount) &&
      Mapper.isEqual(self.showPlayerControls, other.showPlayerControls) &&
      Mapper.isEqual(self.showPlaylistControls, other.showPlaylistControls);

  @override
  Function get typeFactory => (f) => f<PlayerParams>();
}

extension PlayerParamsMapperExtension on PlayerParams {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  PlayerParamsCopyWith<PlayerParams> get copyWith => PlayerParamsCopyWith(this, $identity);
}

abstract class PlayerParamsCopyWith<$R> {
  factory PlayerParamsCopyWith(PlayerParams value, Then<PlayerParams, $R> then) = _PlayerParamsCopyWithImpl<$R>;
  $R call({bool? allowUserAccount, bool? showPlayerControls, bool? showPlaylistControls});
  $R apply(PlayerParams Function(PlayerParams) transform);
}

class _PlayerParamsCopyWithImpl<$R> extends BaseCopyWith<PlayerParams, $R> implements PlayerParamsCopyWith<$R> {
  _PlayerParamsCopyWithImpl(PlayerParams value, Then<PlayerParams, $R> then) : super(value, then);

  @override
  $R call({bool? allowUserAccount, bool? showPlayerControls, bool? showPlaylistControls}) => $then(PlayerParams(
      allowUserAccount: allowUserAccount ?? $value.allowUserAccount,
      showPlayerControls: showPlayerControls ?? $value.showPlayerControls,
      showPlaylistControls: showPlaylistControls ?? $value.showPlaylistControls));
}

class MusicConfigMapper extends BaseMapper<MusicConfig> {
  MusicConfigMapper._();

  @override
  Function get decoder => decode;
  MusicConfig decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  MusicConfig fromMap(Map<String, dynamic> map) => MusicConfig(
      credentials: Mapper.i.$getOpt(map, 'credentials'),
      player: Mapper.i.$getOpt(map, 'player'),
      playlist: Mapper.i.$getOpt(map, 'playlist'));

  @override
  Function get encoder => (MusicConfig v) => encode(v);
  dynamic encode(MusicConfig v) => toMap(v);
  Map<String, dynamic> toMap(MusicConfig m) => {
        'credentials': Mapper.i.$enc(m.credentials, 'credentials'),
        'player': Mapper.i.$enc(m.player, 'player'),
        'playlist': Mapper.i.$enc(m.playlist, 'playlist')
      };

  @override
  String stringify(MusicConfig self) =>
      'MusicConfig(credentials: ${Mapper.asString(self.credentials)}, playlist: ${Mapper.asString(self.playlist)}, player: ${Mapper.asString(self.player)})';
  @override
  int hash(MusicConfig self) => Mapper.hash(self.credentials) ^ Mapper.hash(self.playlist) ^ Mapper.hash(self.player);
  @override
  bool equals(MusicConfig self, MusicConfig other) =>
      Mapper.isEqual(self.credentials, other.credentials) &&
      Mapper.isEqual(self.playlist, other.playlist) &&
      Mapper.isEqual(self.player, other.player);

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
      SpotifyPlayer(Mapper.i.$get(map, 'track'), Mapper.i.$get(map, 'isPlaying'), Mapper.i.$getOpt(map, 'progressMs'));

  @override
  Function get encoder => (SpotifyPlayer v) => encode(v);
  dynamic encode(SpotifyPlayer v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyPlayer s) => {
        'track': Mapper.i.$enc(s.track, 'track'),
        'isPlaying': Mapper.i.$enc(s.isPlaying, 'isPlaying'),
        'progressMs': Mapper.i.$enc(s.progressMs, 'progressMs')
      };

  @override
  String stringify(SpotifyPlayer self) =>
      'SpotifyPlayer(track: ${Mapper.asString(self.track)}, isPlaying: ${Mapper.asString(self.isPlaying)}, progressMs: ${Mapper.asString(self.progressMs)})';
  @override
  int hash(SpotifyPlayer self) => Mapper.hash(self.track) ^ Mapper.hash(self.isPlaying) ^ Mapper.hash(self.progressMs);
  @override
  bool equals(SpotifyPlayer self, SpotifyPlayer other) =>
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
  SpotifyCredentials fromMap(Map<String, dynamic> map) => SpotifyCredentials(
      Mapper.i.$get(map, 'accessToken'), Mapper.i.$get(map, 'refreshToken'), Mapper.i.$get(map, 'expiration'));

  @override
  Function get encoder => (SpotifyCredentials v) => encode(v);
  dynamic encode(SpotifyCredentials v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyCredentials s) => {
        'accessToken': Mapper.i.$enc(s.accessToken, 'accessToken'),
        'refreshToken': Mapper.i.$enc(s.refreshToken, 'refreshToken'),
        'expiration': Mapper.i.$enc(s.expiration, 'expiration')
      };

  @override
  String stringify(SpotifyCredentials self) =>
      'SpotifyCredentials(accessToken: ${Mapper.asString(self.accessToken)}, refreshToken: ${Mapper.asString(self.refreshToken)}, expiration: ${Mapper.asString(self.expiration)})';
  @override
  int hash(SpotifyCredentials self) =>
      Mapper.hash(self.accessToken) ^ Mapper.hash(self.refreshToken) ^ Mapper.hash(self.expiration);
  @override
  bool equals(SpotifyCredentials self, SpotifyCredentials other) =>
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
      Mapper.i.$get(map, 'id'),
      Mapper.i.$get(map, 'name'),
      Mapper.i.$get(map, 'images'),
      Mapper.i.$get(map, 'uri'),
      Mapper.i.$get(map, 'spotifyUrl'),
      Mapper.i.$get(map, 'tracks'));

  @override
  Function get encoder => (SpotifyPlaylist v) => encode(v);
  dynamic encode(SpotifyPlaylist v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyPlaylist s) => {
        'id': Mapper.i.$enc(s.id, 'id'),
        'name': Mapper.i.$enc(s.name, 'name'),
        'images': Mapper.i.$enc(s.images, 'images'),
        'uri': Mapper.i.$enc(s.uri, 'uri'),
        'spotifyUrl': Mapper.i.$enc(s.spotifyUrl, 'spotifyUrl'),
        'tracks': Mapper.i.$enc(s.tracks, 'tracks')
      };

  @override
  String stringify(SpotifyPlaylist self) =>
      'SpotifyPlaylist(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)}, images: ${Mapper.asString(self.images)}, uri: ${Mapper.asString(self.uri)}, spotifyUrl: ${Mapper.asString(self.spotifyUrl)}, tracks: ${Mapper.asString(self.tracks)})';
  @override
  int hash(SpotifyPlaylist self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.name) ^
      Mapper.hash(self.images) ^
      Mapper.hash(self.uri) ^
      Mapper.hash(self.spotifyUrl) ^
      Mapper.hash(self.tracks);
  @override
  bool equals(SpotifyPlaylist self, SpotifyPlaylist other) =>
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
      Mapper.i.$get(map, 'name'),
      Mapper.i.$get(map, 'id'),
      Mapper.i.$get(map, 'uri'),
      Mapper.i.$get(map, 'album'),
      Mapper.i.$get(map, 'artists'),
      Mapper.i.$get(map, 'durationMs'));

  @override
  Function get encoder => (SpotifyTrack v) => encode(v);
  dynamic encode(SpotifyTrack v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyTrack s) => {
        'name': Mapper.i.$enc(s.name, 'name'),
        'id': Mapper.i.$enc(s.id, 'id'),
        'uri': Mapper.i.$enc(s.uri, 'uri'),
        'album': Mapper.i.$enc(s.album, 'album'),
        'artists': Mapper.i.$enc(s.artists, 'artists'),
        'durationMs': Mapper.i.$enc(s.durationMs, 'durationMs')
      };

  @override
  String stringify(SpotifyTrack self) =>
      'SpotifyTrack(name: ${Mapper.asString(self.name)}, id: ${Mapper.asString(self.id)}, uri: ${Mapper.asString(self.uri)}, album: ${Mapper.asString(self.album)}, artists: ${Mapper.asString(self.artists)}, durationMs: ${Mapper.asString(self.durationMs)})';
  @override
  int hash(SpotifyTrack self) =>
      Mapper.hash(self.name) ^
      Mapper.hash(self.id) ^
      Mapper.hash(self.uri) ^
      Mapper.hash(self.album) ^
      Mapper.hash(self.artists) ^
      Mapper.hash(self.durationMs);
  @override
  bool equals(SpotifyTrack self, SpotifyTrack other) =>
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
  SpotifyAlbum fromMap(Map<String, dynamic> map) => SpotifyAlbum(
      Mapper.i.$get(map, 'id'), Mapper.i.$get(map, 'uri'), Mapper.i.$get(map, 'name'), Mapper.i.$get(map, 'images'));

  @override
  Function get encoder => (SpotifyAlbum v) => encode(v);
  dynamic encode(SpotifyAlbum v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyAlbum s) => {
        'id': Mapper.i.$enc(s.id, 'id'),
        'uri': Mapper.i.$enc(s.uri, 'uri'),
        'name': Mapper.i.$enc(s.name, 'name'),
        'images': Mapper.i.$enc(s.images, 'images')
      };

  @override
  String stringify(SpotifyAlbum self) =>
      'SpotifyAlbum(id: ${Mapper.asString(self.id)}, uri: ${Mapper.asString(self.uri)}, name: ${Mapper.asString(self.name)}, images: ${Mapper.asString(self.images)})';
  @override
  int hash(SpotifyAlbum self) =>
      Mapper.hash(self.id) ^ Mapper.hash(self.uri) ^ Mapper.hash(self.name) ^ Mapper.hash(self.images);
  @override
  bool equals(SpotifyAlbum self, SpotifyAlbum other) =>
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
  SpotifyImage fromMap(Map<String, dynamic> map) =>
      SpotifyImage(Mapper.i.$get(map, 'height'), Mapper.i.$get(map, 'width'), Mapper.i.$get(map, 'url'));

  @override
  Function get encoder => (SpotifyImage v) => encode(v);
  dynamic encode(SpotifyImage v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyImage s) => {
        'height': Mapper.i.$enc(s.height, 'height'),
        'width': Mapper.i.$enc(s.width, 'width'),
        'url': Mapper.i.$enc(s.url, 'url')
      };

  @override
  String stringify(SpotifyImage self) =>
      'SpotifyImage(height: ${Mapper.asString(self.height)}, width: ${Mapper.asString(self.width)}, url: ${Mapper.asString(self.url)})';
  @override
  int hash(SpotifyImage self) => Mapper.hash(self.height) ^ Mapper.hash(self.width) ^ Mapper.hash(self.url);
  @override
  bool equals(SpotifyImage self, SpotifyImage other) =>
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
  SpotifyArtist fromMap(Map<String, dynamic> map) =>
      SpotifyArtist(Mapper.i.$get(map, 'id'), Mapper.i.$get(map, 'name'));

  @override
  Function get encoder => (SpotifyArtist v) => encode(v);
  dynamic encode(SpotifyArtist v) => toMap(v);
  Map<String, dynamic> toMap(SpotifyArtist s) =>
      {'id': Mapper.i.$enc(s.id, 'id'), 'name': Mapper.i.$enc(s.name, 'name')};

  @override
  String stringify(SpotifyArtist self) =>
      'SpotifyArtist(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)})';
  @override
  int hash(SpotifyArtist self) => Mapper.hash(self.id) ^ Mapper.hash(self.name);
  @override
  bool equals(SpotifyArtist self, SpotifyArtist other) =>
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

class NotesListParamsMapper extends BaseMapper<NotesListParams> {
  NotesListParamsMapper._();

  @override
  Function get decoder => decode;
  NotesListParams decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  NotesListParams fromMap(Map<String, dynamic> map) => NotesListParams(
      showAdd: Mapper.i.$getOpt(map, 'showAdd') ?? true,
      folder: Mapper.i.$getOpt(map, 'folder'),
      showFolders: Mapper.i.$getOpt(map, 'showFolders') ?? true);

  @override
  Function get encoder => (NotesListParams v) => encode(v);
  dynamic encode(NotesListParams v) => toMap(v);
  Map<String, dynamic> toMap(NotesListParams n) => {
        'showAdd': Mapper.i.$enc(n.showAdd, 'showAdd'),
        'folder': Mapper.i.$enc(n.folder, 'folder'),
        'showFolders': Mapper.i.$enc(n.showFolders, 'showFolders')
      };

  @override
  String stringify(NotesListParams self) =>
      'NotesListParams(showAdd: ${Mapper.asString(self.showAdd)}, folder: ${Mapper.asString(self.folder)}, showFolders: ${Mapper.asString(self.showFolders)})';
  @override
  int hash(NotesListParams self) =>
      Mapper.hash(self.showAdd) ^ Mapper.hash(self.folder) ^ Mapper.hash(self.showFolders);
  @override
  bool equals(NotesListParams self, NotesListParams other) =>
      Mapper.isEqual(self.showAdd, other.showAdd) &&
      Mapper.isEqual(self.folder, other.folder) &&
      Mapper.isEqual(self.showFolders, other.showFolders);

  @override
  Function get typeFactory => (f) => f<NotesListParams>();
}

extension NotesListParamsMapperExtension on NotesListParams {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  NotesListParamsCopyWith<NotesListParams> get copyWith => NotesListParamsCopyWith(this, $identity);
}

abstract class NotesListParamsCopyWith<$R> {
  factory NotesListParamsCopyWith(NotesListParams value, Then<NotesListParams, $R> then) =
      _NotesListParamsCopyWithImpl<$R>;
  $R call({bool? showAdd, String? folder, bool? showFolders});
  $R apply(NotesListParams Function(NotesListParams) transform);
}

class _NotesListParamsCopyWithImpl<$R> extends BaseCopyWith<NotesListParams, $R>
    implements NotesListParamsCopyWith<$R> {
  _NotesListParamsCopyWithImpl(NotesListParams value, Then<NotesListParams, $R> then) : super(value, then);

  @override
  $R call({bool? showAdd, Object? folder = $none, bool? showFolders}) => $then(NotesListParams(
      showAdd: showAdd ?? $value.showAdd,
      folder: or(folder, $value.folder),
      showFolders: showFolders ?? $value.showFolders));
}

class NoteMapper extends BaseMapper<Note> {
  NoteMapper._();

  @override
  Function get decoder => decode;
  Note decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  Note fromMap(Map<String, dynamic> map) =>
      Note(Mapper.i.$get(map, 'id'), Mapper.i.$getOpt(map, 'title'), Mapper.i.$get(map, 'content'),
          folder: Mapper.i.$getOpt(map, 'folder'),
          isArchived: Mapper.i.$getOpt(map, 'isArchived') ?? false,
          author: Mapper.i.$get(map, 'author'),
          editors: Mapper.i.$getOpt(map, 'editors') ?? const []);

  @override
  Function get encoder => (Note v) => encode(v);
  dynamic encode(Note v) => toMap(v);
  Map<String, dynamic> toMap(Note n) => {
        'id': Mapper.i.$enc(n.id, 'id'),
        'title': Mapper.i.$enc(n.title, 'title'),
        'content': Mapper.i.$enc(n.content, 'content'),
        'folder': Mapper.i.$enc(n.folder, 'folder'),
        'isArchived': Mapper.i.$enc(n.isArchived, 'isArchived'),
        'author': Mapper.i.$enc(n.author, 'author'),
        'editors': Mapper.i.$enc(n.editors, 'editors')
      };

  @override
  String stringify(Note self) =>
      'Note(id: ${Mapper.asString(self.id)}, title: ${Mapper.asString(self.title)}, content: ${Mapper.asString(self.content)}, folder: ${Mapper.asString(self.folder)}, isArchived: ${Mapper.asString(self.isArchived)}, author: ${Mapper.asString(self.author)}, editors: ${Mapper.asString(self.editors)})';
  @override
  int hash(Note self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.title) ^
      Mapper.hash(self.content) ^
      Mapper.hash(self.folder) ^
      Mapper.hash(self.isArchived) ^
      Mapper.hash(self.author) ^
      Mapper.hash(self.editors);
  @override
  bool equals(Note self, Note other) =>
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
  Poll fromMap(Map<String, dynamic> map) => Poll(Mapper.i.$get(map, 'id'), Mapper.i.$get(map, 'name'),
      Mapper.i.$get(map, 'startedAt'), Mapper.i.$get(map, 'steps'));

  @override
  Function get encoder => (Poll v) => encode(v);
  dynamic encode(Poll v) => toMap(v);
  Map<String, dynamic> toMap(Poll p) => {
        'id': Mapper.i.$enc(p.id, 'id'),
        'name': Mapper.i.$enc(p.name, 'name'),
        'startedAt': Mapper.i.$enc(p.startedAt, 'startedAt'),
        'steps': Mapper.i.$enc(p.steps, 'steps')
      };

  @override
  String stringify(Poll self) =>
      'Poll(id: ${Mapper.asString(self.id)}, name: ${Mapper.asString(self.name)}, startedAt: ${Mapper.asString(self.startedAt)}, steps: ${Mapper.asString(self.steps)})';
  @override
  int hash(Poll self) =>
      Mapper.hash(self.id) ^ Mapper.hash(self.name) ^ Mapper.hash(self.startedAt) ^ Mapper.hash(self.steps);
  @override
  bool equals(Poll self, Poll other) =>
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
  PollStep fromMap(Map<String, dynamic> map) => PollStep(Mapper.i.$get(map, 'type'));

  @override
  Function get encoder => (PollStep v) => encode(v);
  dynamic encode(PollStep v) {
    if (v is MultipleChoiceQuestion) {
      return MultipleChoiceQuestionMapper._().encode(v);
    } else {
      return toMap(v);
    }
  }

  Map<String, dynamic> toMap(PollStep p) => {'type': Mapper.i.$enc(p.type, 'type')};

  @override
  String stringify(PollStep self) => 'PollStep(type: ${Mapper.asString(self.type)})';
  @override
  int hash(PollStep self) => Mapper.hash(self.type);
  @override
  bool equals(PollStep self, PollStep other) => Mapper.isEqual(self.type, other.type);

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
  MultipleChoiceQuestion fromMap(Map<String, dynamic> map) => MultipleChoiceQuestion(
      Mapper.i.$get(map, 'choices'), Mapper.i.$get(map, 'multiselect'), Mapper.i.$get(map, 'type'));

  @override
  Function get encoder => (MultipleChoiceQuestion v) => encode(v);
  dynamic encode(MultipleChoiceQuestion v) => toMap(v);
  Map<String, dynamic> toMap(MultipleChoiceQuestion m) => {
        'choices': Mapper.i.$enc(m.choices, 'choices'),
        'multiselect': Mapper.i.$enc(m.multiselect, 'multiselect'),
        'type': Mapper.i.$enc(m.type, 'type')
      };

  @override
  String stringify(MultipleChoiceQuestion self) =>
      'MultipleChoiceQuestion(type: ${Mapper.asString(self.type)}, choices: ${Mapper.asString(self.choices)}, multiselect: ${Mapper.asString(self.multiselect)})';
  @override
  int hash(MultipleChoiceQuestion self) =>
      Mapper.hash(self.type) ^ Mapper.hash(self.choices) ^ Mapper.hash(self.multiselect);
  @override
  bool equals(MultipleChoiceQuestion self, MultipleChoiceQuestion other) =>
      Mapper.isEqual(self.type, other.type) &&
      Mapper.isEqual(self.choices, other.choices) &&
      Mapper.isEqual(self.multiselect, other.multiselect);

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

class ProfileImageElementParamsMapper extends BaseMapper<ProfileImageElementParams> {
  ProfileImageElementParamsMapper._();

  @override
  Function get decoder => decode;
  ProfileImageElementParams decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ProfileImageElementParams fromMap(Map<String, dynamic> map) => ProfileImageElementParams(
      showName: Mapper.i.$getOpt(map, 'showName') ?? true, showGreeting: Mapper.i.$getOpt(map, 'showGreeting') ?? true);

  @override
  Function get encoder => (ProfileImageElementParams v) => encode(v);
  dynamic encode(ProfileImageElementParams v) => toMap(v);
  Map<String, dynamic> toMap(ProfileImageElementParams p) => {
        'showName': Mapper.i.$enc(p.showName, 'showName'),
        'showGreeting': Mapper.i.$enc(p.showGreeting, 'showGreeting')
      };

  @override
  String stringify(ProfileImageElementParams self) =>
      'ProfileImageElementParams(showName: ${Mapper.asString(self.showName)}, showGreeting: ${Mapper.asString(self.showGreeting)})';
  @override
  int hash(ProfileImageElementParams self) => Mapper.hash(self.showName) ^ Mapper.hash(self.showGreeting);
  @override
  bool equals(ProfileImageElementParams self, ProfileImageElementParams other) =>
      Mapper.isEqual(self.showName, other.showName) && Mapper.isEqual(self.showGreeting, other.showGreeting);

  @override
  Function get typeFactory => (f) => f<ProfileImageElementParams>();
}

extension ProfileImageElementParamsMapperExtension on ProfileImageElementParams {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ProfileImageElementParamsCopyWith<ProfileImageElementParams> get copyWith =>
      ProfileImageElementParamsCopyWith(this, $identity);
}

abstract class ProfileImageElementParamsCopyWith<$R> {
  factory ProfileImageElementParamsCopyWith(ProfileImageElementParams value, Then<ProfileImageElementParams, $R> then) =
      _ProfileImageElementParamsCopyWithImpl<$R>;
  $R call({bool? showName, bool? showGreeting});
  $R apply(ProfileImageElementParams Function(ProfileImageElementParams) transform);
}

class _ProfileImageElementParamsCopyWithImpl<$R> extends BaseCopyWith<ProfileImageElementParams, $R>
    implements ProfileImageElementParamsCopyWith<$R> {
  _ProfileImageElementParamsCopyWithImpl(ProfileImageElementParams value, Then<ProfileImageElementParams, $R> then)
      : super(value, then);

  @override
  $R call({bool? showName, bool? showGreeting}) => $then(ProfileImageElementParams(
      showName: showName ?? $value.showName, showGreeting: showGreeting ?? $value.showGreeting));
}

class BalancesListParamsMapper extends BaseMapper<BalancesListParams> {
  BalancesListParamsMapper._();

  @override
  Function get decoder => decode;
  BalancesListParams decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  BalancesListParams fromMap(Map<String, dynamic> map) => BalancesListParams(
      showZeroBalances: Mapper.i.$getOpt(map, 'showZeroBalances') ?? true,
      showPots: Mapper.i.$getOpt(map, 'showPots') ?? true);

  @override
  Function get encoder => (BalancesListParams v) => encode(v);
  dynamic encode(BalancesListParams v) => toMap(v);
  Map<String, dynamic> toMap(BalancesListParams b) => {
        'showZeroBalances': Mapper.i.$enc(b.showZeroBalances, 'showZeroBalances'),
        'showPots': Mapper.i.$enc(b.showPots, 'showPots')
      };

  @override
  String stringify(BalancesListParams self) =>
      'BalancesListParams(showZeroBalances: ${Mapper.asString(self.showZeroBalances)}, showPots: ${Mapper.asString(self.showPots)})';
  @override
  int hash(BalancesListParams self) => Mapper.hash(self.showZeroBalances) ^ Mapper.hash(self.showPots);
  @override
  bool equals(BalancesListParams self, BalancesListParams other) =>
      Mapper.isEqual(self.showZeroBalances, other.showZeroBalances) && Mapper.isEqual(self.showPots, other.showPots);

  @override
  Function get typeFactory => (f) => f<BalancesListParams>();
}

extension BalancesListParamsMapperExtension on BalancesListParams {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  BalancesListParamsCopyWith<BalancesListParams> get copyWith => BalancesListParamsCopyWith(this, $identity);
}

abstract class BalancesListParamsCopyWith<$R> {
  factory BalancesListParamsCopyWith(BalancesListParams value, Then<BalancesListParams, $R> then) =
      _BalancesListParamsCopyWithImpl<$R>;
  $R call({bool? showZeroBalances, bool? showPots});
  $R apply(BalancesListParams Function(BalancesListParams) transform);
}

class _BalancesListParamsCopyWithImpl<$R> extends BaseCopyWith<BalancesListParams, $R>
    implements BalancesListParamsCopyWith<$R> {
  _BalancesListParamsCopyWithImpl(BalancesListParams value, Then<BalancesListParams, $R> then) : super(value, then);

  @override
  $R call({bool? showZeroBalances, bool? showPots}) => $then(BalancesListParams(
      showZeroBalances: showZeroBalances ?? $value.showZeroBalances, showPots: showPots ?? $value.showPots));
}

class BalanceFocusParamsMapper extends BaseMapper<BalanceFocusParams> {
  BalanceFocusParamsMapper._();

  @override
  Function get decoder => decode;
  BalanceFocusParams decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  BalanceFocusParams fromMap(Map<String, dynamic> map) => BalanceFocusParams(
      source: Mapper.i.$getOpt(map, 'source'), currentUser: Mapper.i.$getOpt(map, 'currentUser') ?? true);

  @override
  Function get encoder => (BalanceFocusParams v) => encode(v);
  dynamic encode(BalanceFocusParams v) => toMap(v);
  Map<String, dynamic> toMap(BalanceFocusParams b) =>
      {'source': Mapper.i.$enc(b.source, 'source'), 'currentUser': Mapper.i.$enc(b.currentUser, 'currentUser')};

  @override
  String stringify(BalanceFocusParams self) =>
      'BalanceFocusParams(source: ${Mapper.asString(self.source)}, currentUser: ${Mapper.asString(self.currentUser)})';
  @override
  int hash(BalanceFocusParams self) => Mapper.hash(self.source) ^ Mapper.hash(self.currentUser);
  @override
  bool equals(BalanceFocusParams self, BalanceFocusParams other) =>
      Mapper.isEqual(self.source, other.source) && Mapper.isEqual(self.currentUser, other.currentUser);

  @override
  Function get typeFactory => (f) => f<BalanceFocusParams>();
}

extension BalanceFocusParamsMapperExtension on BalanceFocusParams {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  BalanceFocusParamsCopyWith<BalanceFocusParams> get copyWith => BalanceFocusParamsCopyWith(this, $identity);
}

abstract class BalanceFocusParamsCopyWith<$R> {
  factory BalanceFocusParamsCopyWith(BalanceFocusParams value, Then<BalanceFocusParams, $R> then) =
      _BalanceFocusParamsCopyWithImpl<$R>;
  SplitSourceCopyWith<$R>? get source;
  $R call({SplitSource? source, bool? currentUser});
  $R apply(BalanceFocusParams Function(BalanceFocusParams) transform);
}

class _BalanceFocusParamsCopyWithImpl<$R> extends BaseCopyWith<BalanceFocusParams, $R>
    implements BalanceFocusParamsCopyWith<$R> {
  _BalanceFocusParamsCopyWithImpl(BalanceFocusParams value, Then<BalanceFocusParams, $R> then) : super(value, then);

  @override
  SplitSourceCopyWith<$R>? get source =>
      $value.source != null ? SplitSourceCopyWith($value.source!, (v) => call(source: v)) : null;
  @override
  $R call({Object? source = $none, bool? currentUser}) =>
      $then(BalanceFocusParams(source: or(source, $value.source), currentUser: currentUser ?? $value.currentUser));
}

class SplitStateMapper extends BaseMapper<SplitState> {
  SplitStateMapper._();

  @override
  Function get decoder => decode;
  SplitState decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SplitState fromMap(Map<String, dynamic> map) => SplitState(
      pots: Mapper.i.$getOpt(map, 'pots') ?? const {},
      entries: Mapper.i.$getOpt(map, 'entries') ?? const {},
      showBilling: Mapper.i.$getOpt(map, 'showBilling') ?? false,
      templates: Mapper.i.$getOpt(map, 'templates') ?? const [],
      billingRates: Mapper.i.$getOpt(map, 'billingRates'));

  @override
  Function get encoder => (SplitState v) => encode(v);
  dynamic encode(SplitState v) => toMap(v);
  Map<String, dynamic> toMap(SplitState s) => {
        'pots': Mapper.i.$enc(s.pots, 'pots'),
        'entries': Mapper.i.$enc(s.entries, 'entries'),
        'showBilling': Mapper.i.$enc(s.showBilling, 'showBilling'),
        'templates': Mapper.i.$enc(s.templates, 'templates'),
        'billingRates': Mapper.i.$enc(s.billingRates, 'billingRates')
      };

  @override
  String stringify(SplitState self) =>
      'SplitState(pots: ${Mapper.asString(self.pots)}, entries: ${Mapper.asString(self.entries)}, templates: ${Mapper.asString(self.templates)}, showBilling: ${Mapper.asString(self.showBilling)}, billingRates: ${Mapper.asString(self.billingRates)}, balances: ${Mapper.asString(self.balances)}, billing: ${Mapper.asString(self.billing)}, stats: ${Mapper.asString(self.stats)})';
  @override
  int hash(SplitState self) =>
      Mapper.hash(self.pots) ^
      Mapper.hash(self.entries) ^
      Mapper.hash(self.templates) ^
      Mapper.hash(self.showBilling) ^
      Mapper.hash(self.billingRates) ^
      Mapper.hash(self.balances) ^
      Mapper.hash(self.billing) ^
      Mapper.hash(self.stats);
  @override
  bool equals(SplitState self, SplitState other) =>
      Mapper.isEqual(self.pots, other.pots) &&
      Mapper.isEqual(self.entries, other.entries) &&
      Mapper.isEqual(self.templates, other.templates) &&
      Mapper.isEqual(self.showBilling, other.showBilling) &&
      Mapper.isEqual(self.billingRates, other.billingRates) &&
      Mapper.isEqual(self.balances, other.balances) &&
      Mapper.isEqual(self.billing, other.billing) &&
      Mapper.isEqual(self.stats, other.stats);

  @override
  Function get typeFactory => (f) => f<SplitState>();
}

extension SplitStateMapperExtension on SplitState {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SplitStateCopyWith<SplitState> get copyWith => SplitStateCopyWith(this, $identity);
}

abstract class SplitStateCopyWith<$R> {
  factory SplitStateCopyWith(SplitState value, Then<SplitState, $R> then) = _SplitStateCopyWithImpl<$R>;
  MapCopyWith<$R, String, SplitPot, SplitPotCopyWith<$R>> get pots;
  MapCopyWith<$R, String, SplitEntry, SplitEntryCopyWith<$R>> get entries;
  ListCopyWith<$R, SplitTemplate, SplitTemplateCopyWith<$R>> get templates;
  BillingRatesCopyWith<$R>? get billingRates;
  $R call(
      {Map<String, SplitPot>? pots,
      Map<String, SplitEntry>? entries,
      bool? showBilling,
      List<SplitTemplate>? templates,
      BillingRates? billingRates});
  $R apply(SplitState Function(SplitState) transform);
}

class _SplitStateCopyWithImpl<$R> extends BaseCopyWith<SplitState, $R> implements SplitStateCopyWith<$R> {
  _SplitStateCopyWithImpl(SplitState value, Then<SplitState, $R> then) : super(value, then);

  @override
  MapCopyWith<$R, String, SplitPot, SplitPotCopyWith<$R>> get pots =>
      MapCopyWith($value.pots, (v, t) => SplitPotCopyWith(v, t), (v) => call(pots: v));
  @override
  MapCopyWith<$R, String, SplitEntry, SplitEntryCopyWith<$R>> get entries =>
      MapCopyWith($value.entries, (v, t) => SplitEntryCopyWith(v, t), (v) => call(entries: v));
  @override
  ListCopyWith<$R, SplitTemplate, SplitTemplateCopyWith<$R>> get templates =>
      ListCopyWith($value.templates, (v, t) => SplitTemplateCopyWith(v, t), (v) => call(templates: v));
  @override
  BillingRatesCopyWith<$R>? get billingRates =>
      $value.billingRates != null ? BillingRatesCopyWith($value.billingRates!, (v) => call(billingRates: v)) : null;
  @override
  $R call(
          {Map<String, SplitPot>? pots,
          Map<String, SplitEntry>? entries,
          bool? showBilling,
          List<SplitTemplate>? templates,
          Object? billingRates = $none}) =>
      $then(SplitState(
          pots: pots ?? $value.pots,
          entries: entries ?? $value.entries,
          showBilling: showBilling ?? $value.showBilling,
          templates: templates ?? $value.templates,
          billingRates: or(billingRates, $value.billingRates)));
}

class BillingStatsMapper extends BaseMapper<BillingStats> {
  BillingStatsMapper._();

  @override
  Function get decoder => decode;
  BillingStats decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  BillingStats fromMap(Map<String, dynamic> map) =>
      BillingStats(Mapper.i.$get(map, 'totalSpendings'), Mapper.i.$get(map, 'userSpendings'));

  @override
  Function get encoder => (BillingStats v) => encode(v);
  dynamic encode(BillingStats v) => toMap(v);
  Map<String, dynamic> toMap(BillingStats b) => {
        'totalSpendings': Mapper.i.$enc(b.totalSpendings, 'totalSpendings'),
        'userSpendings': Mapper.i.$enc(b.userSpendings, 'userSpendings')
      };

  @override
  String stringify(BillingStats self) =>
      'BillingStats(totalSpendings: ${Mapper.asString(self.totalSpendings)}, userSpendings: ${Mapper.asString(self.userSpendings)})';
  @override
  int hash(BillingStats self) => Mapper.hash(self.totalSpendings) ^ Mapper.hash(self.userSpendings);
  @override
  bool equals(BillingStats self, BillingStats other) =>
      Mapper.isEqual(self.totalSpendings, other.totalSpendings) &&
      Mapper.isEqual(self.userSpendings, other.userSpendings);

  @override
  Function get typeFactory => (f) => f<BillingStats>();
}

extension BillingStatsMapperExtension on BillingStats {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  BillingStatsCopyWith<BillingStats> get copyWith => BillingStatsCopyWith(this, $identity);
}

abstract class BillingStatsCopyWith<$R> {
  factory BillingStatsCopyWith(BillingStats value, Then<BillingStats, $R> then) = _BillingStatsCopyWithImpl<$R>;
  MapCopyWith<$R, String, SplitSpendings, SplitSpendingsCopyWith<$R>> get userSpendings;
  $R call({SplitBalance? totalSpendings, Map<String, SplitSpendings>? userSpendings});
  $R apply(BillingStats Function(BillingStats) transform);
}

class _BillingStatsCopyWithImpl<$R> extends BaseCopyWith<BillingStats, $R> implements BillingStatsCopyWith<$R> {
  _BillingStatsCopyWithImpl(BillingStats value, Then<BillingStats, $R> then) : super(value, then);

  @override
  MapCopyWith<$R, String, SplitSpendings, SplitSpendingsCopyWith<$R>> get userSpendings =>
      MapCopyWith($value.userSpendings, (v, t) => SplitSpendingsCopyWith(v, t), (v) => call(userSpendings: v));
  @override
  $R call({SplitBalance? totalSpendings, Map<String, SplitSpendings>? userSpendings}) =>
      $then(BillingStats(totalSpendings ?? $value.totalSpendings, userSpendings ?? $value.userSpendings));
}

class SplitSpendingsMapper extends BaseMapper<SplitSpendings> {
  SplitSpendingsMapper._();

  @override
  Function get decoder => decode;
  SplitSpendings decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SplitSpendings fromMap(Map<String, dynamic> map) =>
      SplitSpendings(Mapper.i.$get(map, 'totalAmounts'), Mapper.i.$get(map, 'spendings'));

  @override
  Function get encoder => (SplitSpendings v) => encode(v);
  dynamic encode(SplitSpendings v) => toMap(v);
  Map<String, dynamic> toMap(SplitSpendings s) => {
        'totalAmounts': Mapper.i.$enc(s.totalAmounts, 'totalAmounts'),
        'spendings': Mapper.i.$enc(s.spendings, 'spendings')
      };

  @override
  String stringify(SplitSpendings self) =>
      'SplitSpendings(totalAmounts: ${Mapper.asString(self.totalAmounts)}, spendings: ${Mapper.asString(self.spendings)})';
  @override
  int hash(SplitSpendings self) => Mapper.hash(self.totalAmounts) ^ Mapper.hash(self.spendings);
  @override
  bool equals(SplitSpendings self, SplitSpendings other) =>
      Mapper.isEqual(self.totalAmounts, other.totalAmounts) && Mapper.isEqual(self.spendings, other.spendings);

  @override
  Function get typeFactory => (f) => f<SplitSpendings>();
}

extension SplitSpendingsMapperExtension on SplitSpendings {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SplitSpendingsCopyWith<SplitSpendings> get copyWith => SplitSpendingsCopyWith(this, $identity);
}

abstract class SplitSpendingsCopyWith<$R> {
  factory SplitSpendingsCopyWith(SplitSpendings value, Then<SplitSpendings, $R> then) = _SplitSpendingsCopyWithImpl<$R>;
  ListCopyWith<$R, SplitSpending, SplitSpendingCopyWith<$R>> get spendings;
  $R call({Map<Currency, double>? totalAmounts, List<SplitSpending>? spendings});
  $R apply(SplitSpendings Function(SplitSpendings) transform);
}

class _SplitSpendingsCopyWithImpl<$R> extends BaseCopyWith<SplitSpendings, $R> implements SplitSpendingsCopyWith<$R> {
  _SplitSpendingsCopyWithImpl(SplitSpendings value, Then<SplitSpendings, $R> then) : super(value, then);

  @override
  ListCopyWith<$R, SplitSpending, SplitSpendingCopyWith<$R>> get spendings =>
      ListCopyWith($value.spendings, (v, t) => SplitSpendingCopyWith(v, t), (v) => call(spendings: v));
  @override
  $R call({Map<Currency, double>? totalAmounts, List<SplitSpending>? spendings}) =>
      $then(SplitSpendings(totalAmounts ?? $value.totalAmounts, spendings ?? $value.spendings));
}

class SplitSpendingMapper extends BaseMapper<SplitSpending> {
  SplitSpendingMapper._();

  @override
  Function get decoder => decode;
  SplitSpending decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SplitSpending fromMap(Map<String, dynamic> map) =>
      SplitSpending(Mapper.i.$get(map, 'title'), Mapper.i.$get(map, 'currency'), Mapper.i.$get(map, 'amount'));

  @override
  Function get encoder => (SplitSpending v) => encode(v);
  dynamic encode(SplitSpending v) => toMap(v);
  Map<String, dynamic> toMap(SplitSpending s) => {
        'title': Mapper.i.$enc(s.title, 'title'),
        'currency': Mapper.i.$enc(s.currency, 'currency'),
        'amount': Mapper.i.$enc(s.amount, 'amount')
      };

  @override
  String stringify(SplitSpending self) =>
      'SplitSpending(title: ${Mapper.asString(self.title)}, currency: ${Mapper.asString(self.currency)}, amount: ${Mapper.asString(self.amount)})';
  @override
  int hash(SplitSpending self) => Mapper.hash(self.title) ^ Mapper.hash(self.currency) ^ Mapper.hash(self.amount);
  @override
  bool equals(SplitSpending self, SplitSpending other) =>
      Mapper.isEqual(self.title, other.title) &&
      Mapper.isEqual(self.currency, other.currency) &&
      Mapper.isEqual(self.amount, other.amount);

  @override
  Function get typeFactory => (f) => f<SplitSpending>();
}

extension SplitSpendingMapperExtension on SplitSpending {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SplitSpendingCopyWith<SplitSpending> get copyWith => SplitSpendingCopyWith(this, $identity);
}

abstract class SplitSpendingCopyWith<$R> {
  factory SplitSpendingCopyWith(SplitSpending value, Then<SplitSpending, $R> then) = _SplitSpendingCopyWithImpl<$R>;
  $R call({String? title, Currency? currency, double? amount});
  $R apply(SplitSpending Function(SplitSpending) transform);
}

class _SplitSpendingCopyWithImpl<$R> extends BaseCopyWith<SplitSpending, $R> implements SplitSpendingCopyWith<$R> {
  _SplitSpendingCopyWithImpl(SplitSpending value, Then<SplitSpending, $R> then) : super(value, then);

  @override
  $R call({String? title, Currency? currency, double? amount}) =>
      $then(SplitSpending(title ?? $value.title, currency ?? $value.currency, amount ?? $value.amount));
}

class BillingRatesMapper extends BaseMapper<BillingRates> {
  BillingRatesMapper._();

  @override
  Function get decoder => decode;
  BillingRates decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  BillingRates fromMap(Map<String, dynamic> map) =>
      BillingRates(Mapper.i.$get(map, 'target'), Mapper.i.$get(map, 'rates'));

  @override
  Function get encoder => (BillingRates v) => encode(v);
  dynamic encode(BillingRates v) => toMap(v);
  Map<String, dynamic> toMap(BillingRates b) =>
      {'target': Mapper.i.$enc(b.target, 'target'), 'rates': Mapper.i.$enc(b.rates, 'rates')};

  @override
  String stringify(BillingRates self) =>
      'BillingRates(target: ${Mapper.asString(self.target)}, rates: ${Mapper.asString(self.rates)})';
  @override
  int hash(BillingRates self) => Mapper.hash(self.target) ^ Mapper.hash(self.rates);
  @override
  bool equals(BillingRates self, BillingRates other) =>
      Mapper.isEqual(self.target, other.target) && Mapper.isEqual(self.rates, other.rates);

  @override
  Function get typeFactory => (f) => f<BillingRates>();
}

extension BillingRatesMapperExtension on BillingRates {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  BillingRatesCopyWith<BillingRates> get copyWith => BillingRatesCopyWith(this, $identity);
}

abstract class BillingRatesCopyWith<$R> {
  factory BillingRatesCopyWith(BillingRates value, Then<BillingRates, $R> then) = _BillingRatesCopyWithImpl<$R>;
  $R call({Currency? target, Map<Currency, double>? rates});
  $R apply(BillingRates Function(BillingRates) transform);
}

class _BillingRatesCopyWithImpl<$R> extends BaseCopyWith<BillingRates, $R> implements BillingRatesCopyWith<$R> {
  _BillingRatesCopyWithImpl(BillingRates value, Then<BillingRates, $R> then) : super(value, then);

  @override
  $R call({Currency? target, Map<Currency, double>? rates}) =>
      $then(BillingRates(target ?? $value.target, rates ?? $value.rates));
}

class SplitTemplateMapper extends BaseMapper<SplitTemplate> {
  SplitTemplateMapper._();

  @override
  Function get decoder => decode;
  SplitTemplate decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SplitTemplate fromMap(Map<String, dynamic> map) =>
      SplitTemplate(Mapper.i.$get(map, 'name'), Mapper.i.$get(map, 'target'));

  @override
  Function get encoder => (SplitTemplate v) => encode(v);
  dynamic encode(SplitTemplate v) => toMap(v);
  Map<String, dynamic> toMap(SplitTemplate s) =>
      {'name': Mapper.i.$enc(s.name, 'name'), 'target': Mapper.i.$enc(s.target, 'target')};

  @override
  String stringify(SplitTemplate self) =>
      'SplitTemplate(name: ${Mapper.asString(self.name)}, target: ${Mapper.asString(self.target)})';
  @override
  int hash(SplitTemplate self) => Mapper.hash(self.name) ^ Mapper.hash(self.target);
  @override
  bool equals(SplitTemplate self, SplitTemplate other) =>
      Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.target, other.target);

  @override
  Function get typeFactory => (f) => f<SplitTemplate>();
}

extension SplitTemplateMapperExtension on SplitTemplate {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SplitTemplateCopyWith<SplitTemplate> get copyWith => SplitTemplateCopyWith(this, $identity);
}

abstract class SplitTemplateCopyWith<$R> {
  factory SplitTemplateCopyWith(SplitTemplate value, Then<SplitTemplate, $R> then) = _SplitTemplateCopyWithImpl<$R>;
  ExpenseTargetCopyWith<$R> get target;
  $R call({String? name, ExpenseTarget? target});
  $R apply(SplitTemplate Function(SplitTemplate) transform);
}

class _SplitTemplateCopyWithImpl<$R> extends BaseCopyWith<SplitTemplate, $R> implements SplitTemplateCopyWith<$R> {
  _SplitTemplateCopyWithImpl(SplitTemplate value, Then<SplitTemplate, $R> then) : super(value, then);

  @override
  ExpenseTargetCopyWith<$R> get target => ExpenseTargetCopyWith($value.target, (v) => call(target: v));
  @override
  $R call({String? name, ExpenseTarget? target}) => $then(SplitTemplate(name ?? $value.name, target ?? $value.target));
}

class BalanceEntryMapper extends BaseMapper<BalanceEntry> {
  BalanceEntryMapper._();

  @override
  Function get decoder => decode;
  BalanceEntry decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  BalanceEntry fromMap(Map<String, dynamic> map) =>
      BalanceEntry(Mapper.i.$get(map, 'key'), Mapper.i.$get(map, 'value'));

  @override
  Function get encoder => (BalanceEntry v) => encode(v);
  dynamic encode(BalanceEntry v) => toMap(v);
  Map<String, dynamic> toMap(BalanceEntry b) =>
      {'key': Mapper.i.$enc(b.key, 'key'), 'value': Mapper.i.$enc(b.value, 'value')};

  @override
  String stringify(BalanceEntry self) =>
      'BalanceEntry(key: ${Mapper.asString(self.key)}, value: ${Mapper.asString(self.value)})';
  @override
  int hash(BalanceEntry self) => Mapper.hash(self.key) ^ Mapper.hash(self.value);
  @override
  bool equals(BalanceEntry self, BalanceEntry other) =>
      Mapper.isEqual(self.key, other.key) && Mapper.isEqual(self.value, other.value);

  @override
  Function get typeFactory => (f) => f<BalanceEntry>();
}

extension BalanceEntryMapperExtension on BalanceEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  BalanceEntryCopyWith<BalanceEntry> get copyWith => BalanceEntryCopyWith(this, $identity);
}

abstract class BalanceEntryCopyWith<$R> {
  factory BalanceEntryCopyWith(BalanceEntry value, Then<BalanceEntry, $R> then) = _BalanceEntryCopyWithImpl<$R>;
  SplitSourceCopyWith<$R> get key;
  $R call({SplitSource? key, double? value});
  $R apply(BalanceEntry Function(BalanceEntry) transform);
}

class _BalanceEntryCopyWithImpl<$R> extends BaseCopyWith<BalanceEntry, $R> implements BalanceEntryCopyWith<$R> {
  _BalanceEntryCopyWithImpl(BalanceEntry value, Then<BalanceEntry, $R> then) : super(value, then);

  @override
  SplitSourceCopyWith<$R> get key => SplitSourceCopyWith($value.key, (v) => call(key: v));
  @override
  $R call({SplitSource? key, double? value}) => $then(BalanceEntry(key ?? $value.key, value ?? $value.value));
}

class BillingEntryMapper extends BaseMapper<BillingEntry> {
  BillingEntryMapper._();

  @override
  Function get decoder => decode;
  BillingEntry decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  BillingEntry fromMap(Map<String, dynamic> map) => BillingEntry(Mapper.i.$get(map, 'from'), Mapper.i.$get(map, 'to'),
      Mapper.i.$get(map, 'currency'), Mapper.i.$get(map, 'amount'));

  @override
  Function get encoder => (BillingEntry v) => encode(v);
  dynamic encode(BillingEntry v) => toMap(v);
  Map<String, dynamic> toMap(BillingEntry b) => {
        'from': Mapper.i.$enc(b.from, 'from'),
        'to': Mapper.i.$enc(b.to, 'to'),
        'currency': Mapper.i.$enc(b.currency, 'currency'),
        'amount': Mapper.i.$enc(b.amount, 'amount')
      };

  @override
  String stringify(BillingEntry self) =>
      'BillingEntry(from: ${Mapper.asString(self.from)}, to: ${Mapper.asString(self.to)}, currency: ${Mapper.asString(self.currency)}, amount: ${Mapper.asString(self.amount)})';
  @override
  int hash(BillingEntry self) =>
      Mapper.hash(self.from) ^ Mapper.hash(self.to) ^ Mapper.hash(self.currency) ^ Mapper.hash(self.amount);
  @override
  bool equals(BillingEntry self, BillingEntry other) =>
      Mapper.isEqual(self.from, other.from) &&
      Mapper.isEqual(self.to, other.to) &&
      Mapper.isEqual(self.currency, other.currency) &&
      Mapper.isEqual(self.amount, other.amount);

  @override
  Function get typeFactory => (f) => f<BillingEntry>();
}

extension BillingEntryMapperExtension on BillingEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  BillingEntryCopyWith<BillingEntry> get copyWith => BillingEntryCopyWith(this, $identity);
}

abstract class BillingEntryCopyWith<$R> {
  factory BillingEntryCopyWith(BillingEntry value, Then<BillingEntry, $R> then) = _BillingEntryCopyWithImpl<$R>;
  SplitSourceCopyWith<$R> get from;
  SplitSourceCopyWith<$R> get to;
  $R call({SplitSource? from, SplitSource? to, Currency? currency, double? amount});
  $R apply(BillingEntry Function(BillingEntry) transform);
}

class _BillingEntryCopyWithImpl<$R> extends BaseCopyWith<BillingEntry, $R> implements BillingEntryCopyWith<$R> {
  _BillingEntryCopyWithImpl(BillingEntry value, Then<BillingEntry, $R> then) : super(value, then);

  @override
  SplitSourceCopyWith<$R> get from => SplitSourceCopyWith($value.from, (v) => call(from: v));
  @override
  SplitSourceCopyWith<$R> get to => SplitSourceCopyWith($value.to, (v) => call(to: v));
  @override
  $R call({SplitSource? from, SplitSource? to, Currency? currency, double? amount}) =>
      $then(BillingEntry(from ?? $value.from, to ?? $value.to, currency ?? $value.currency, amount ?? $value.amount));
}

class SplitPotMapper extends BaseMapper<SplitPot> {
  SplitPotMapper._();

  @override
  Function get decoder => decode;
  SplitPot decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  SplitPot fromMap(Map<String, dynamic> map) =>
      SplitPot(name: Mapper.i.$get(map, 'name'), icon: Mapper.i.$getOpt(map, 'icon'));

  @override
  Function get encoder => (SplitPot v) => encode(v);
  dynamic encode(SplitPot v) => toMap(v);
  Map<String, dynamic> toMap(SplitPot s) =>
      {'name': Mapper.i.$enc(s.name, 'name'), 'icon': Mapper.i.$enc(s.icon, 'icon')};

  @override
  String stringify(SplitPot self) =>
      'SplitPot(name: ${Mapper.asString(self.name)}, icon: ${Mapper.asString(self.icon)})';
  @override
  int hash(SplitPot self) => Mapper.hash(self.name) ^ Mapper.hash(self.icon);
  @override
  bool equals(SplitPot self, SplitPot other) =>
      Mapper.isEqual(self.name, other.name) && Mapper.isEqual(self.icon, other.icon);

  @override
  Function get typeFactory => (f) => f<SplitPot>();
}

extension SplitPotMapperExtension on SplitPot {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SplitPotCopyWith<SplitPot> get copyWith => SplitPotCopyWith(this, $identity);
}

abstract class SplitPotCopyWith<$R> {
  factory SplitPotCopyWith(SplitPot value, Then<SplitPot, $R> then) = _SplitPotCopyWithImpl<$R>;
  $R call({String? name, String? icon});
  $R apply(SplitPot Function(SplitPot) transform);
}

class _SplitPotCopyWithImpl<$R> extends BaseCopyWith<SplitPot, $R> implements SplitPotCopyWith<$R> {
  _SplitPotCopyWithImpl(SplitPot value, Then<SplitPot, $R> then) : super(value, then);

  @override
  $R call({String? name, Object? icon = $none}) =>
      $then(SplitPot(name: name ?? $value.name, icon: or(icon, $value.icon)));
}

class SplitEntryMapper extends BaseMapper<SplitEntry> {
  SplitEntryMapper._();

  @override
  Function get decoder => decode;
  SplitEntry decode(dynamic v) => checked(v, (Map<String, dynamic> map) {
        switch (map['type']) {
          case 'exchange':
            return ExchangeEntryMapper._().decode(map);
          case 'expense':
            return ExpenseEntryMapper._().decode(map);
          case 'payment':
            return PaymentEntryMapper._().decode(map);
          default:
            return fromMap(map);
        }
      });
  SplitEntry fromMap(Map<String, dynamic> map) => SplitEntry(
      id: Mapper.i.$get(map, 'id'),
      createdAt: Mapper.i.$get(map, 'createdAt'),
      transactedAt: Mapper.i.$getOpt(map, 'transactedAt'));

  @override
  Function get encoder => (SplitEntry v) => encode(v);
  dynamic encode(SplitEntry v) {
    if (v is ExpenseEntry) {
      return ExpenseEntryMapper._().encode(v);
    } else if (v is PaymentEntry) {
      return PaymentEntryMapper._().encode(v);
    } else if (v is ExchangeEntry) {
      return ExchangeEntryMapper._().encode(v);
    } else {
      return toMap(v);
    }
  }

  Map<String, dynamic> toMap(SplitEntry s) => {
        'id': Mapper.i.$enc(s.id, 'id'),
        'createdAt': Mapper.i.$enc(s.createdAt, 'createdAt'),
        'transactedAt': Mapper.i.$enc(s.transactedAt, 'transactedAt')
      };

  @override
  String stringify(SplitEntry self) =>
      'SplitEntry(id: ${Mapper.asString(self.id)}, createdAt: ${Mapper.asString(self.createdAt)}, transactedAt: ${Mapper.asString(self.transactedAt)})';
  @override
  int hash(SplitEntry self) => Mapper.hash(self.id) ^ Mapper.hash(self.createdAt) ^ Mapper.hash(self.transactedAt);
  @override
  bool equals(SplitEntry self, SplitEntry other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.createdAt, other.createdAt) &&
      Mapper.isEqual(self.transactedAt, other.transactedAt);

  @override
  Function get typeFactory => (f) => f<SplitEntry>();
}

extension SplitEntryMapperExtension on SplitEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SplitEntryCopyWith<SplitEntry> get copyWith => SplitEntryCopyWith(this, $identity);
}

abstract class SplitEntryCopyWith<$R> {
  factory SplitEntryCopyWith(SplitEntry value, Then<SplitEntry, $R> then) = _SplitEntryCopyWithImpl<$R>;
  $R call({String? id, DateTime? createdAt, DateTime? transactedAt});
  $R apply(SplitEntry Function(SplitEntry) transform);
}

class _SplitEntryCopyWithImpl<$R> extends BaseCopyWith<SplitEntry, $R> implements SplitEntryCopyWith<$R> {
  _SplitEntryCopyWithImpl(SplitEntry value, Then<SplitEntry, $R> then) : super(value, then);

  @override
  $R call({String? id, DateTime? createdAt, Object? transactedAt = $none}) => $then(SplitEntry(
      id: id ?? $value.id,
      createdAt: createdAt ?? $value.createdAt,
      transactedAt: or(transactedAt, $value.transactedAt)));
}

class SplitSourceMapper extends BaseMapper<SplitSource> {
  SplitSourceMapper._();

  @override
  Function get decoder => decode;
  SplitSource decode(dynamic v) =>
      const SplitSourceHooks().decode(v, (v) => checked(v, (Map<String, dynamic> map) => fromMap(map)));
  SplitSource fromMap(Map<String, dynamic> map) => SplitSource(Mapper.i.$get(map, 'id'), Mapper.i.$get(map, 'type'));

  @override
  Function get encoder => (SplitSource v) => encode(v);
  dynamic encode(SplitSource v) => const SplitSourceHooks().encode<SplitSource>(v, (v) => toMap(v));
  Map<String, dynamic> toMap(SplitSource s) => {'id': Mapper.i.$enc(s.id, 'id'), 'type': Mapper.i.$enc(s.type, 'type')};

  @override
  String stringify(SplitSource self) =>
      'SplitSource(id: ${Mapper.asString(self.id)}, type: ${Mapper.asString(self.type)})';
  @override
  int hash(SplitSource self) => Mapper.hash(self.id) ^ Mapper.hash(self.type);
  @override
  bool equals(SplitSource self, SplitSource other) =>
      Mapper.isEqual(self.id, other.id) && Mapper.isEqual(self.type, other.type);

  @override
  Function get typeFactory => (f) => f<SplitSource>();
}

extension SplitSourceMapperExtension on SplitSource {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  SplitSourceCopyWith<SplitSource> get copyWith => SplitSourceCopyWith(this, $identity);
}

abstract class SplitSourceCopyWith<$R> {
  factory SplitSourceCopyWith(SplitSource value, Then<SplitSource, $R> then) = _SplitSourceCopyWithImpl<$R>;
  $R call({String? id, SplitSourceType? type});
  $R apply(SplitSource Function(SplitSource) transform);
}

class _SplitSourceCopyWithImpl<$R> extends BaseCopyWith<SplitSource, $R> implements SplitSourceCopyWith<$R> {
  _SplitSourceCopyWithImpl(SplitSource value, Then<SplitSource, $R> then) : super(value, then);

  @override
  $R call({String? id, SplitSourceType? type}) => $then(SplitSource(id ?? $value.id, type ?? $value.type));
}

class ExpenseEntryMapper extends BaseMapper<ExpenseEntry> {
  ExpenseEntryMapper._();

  @override
  Function get decoder => decode;
  ExpenseEntry decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ExpenseEntry fromMap(Map<String, dynamic> map) => ExpenseEntry(
      id: Mapper.i.$get(map, 'id'),
      title: Mapper.i.$get(map, 'title'),
      amount: Mapper.i.$get(map, 'amount'),
      currency: Mapper.i.$getOpt(map, 'currency') ?? Currency.euro,
      source: Mapper.i.$get(map, 'source'),
      target: Mapper.i.$get(map, 'target'),
      photoUrl: Mapper.i.$getOpt(map, 'photoUrl'),
      createdAt: Mapper.i.$get(map, 'createdAt'),
      transactedAt: Mapper.i.$getOpt(map, 'transactedAt'));

  @override
  Function get encoder => (ExpenseEntry v) => encode(v);
  dynamic encode(ExpenseEntry v) => toMap(v);
  Map<String, dynamic> toMap(ExpenseEntry e) => {
        'id': Mapper.i.$enc(e.id, 'id'),
        'title': Mapper.i.$enc(e.title, 'title'),
        'amount': Mapper.i.$enc(e.amount, 'amount'),
        'currency': Mapper.i.$enc(e.currency, 'currency'),
        'source': Mapper.i.$enc(e.source, 'source'),
        'target': Mapper.i.$enc(e.target, 'target'),
        'photoUrl': Mapper.i.$enc(e.photoUrl, 'photoUrl'),
        'createdAt': Mapper.i.$enc(e.createdAt, 'createdAt'),
        'transactedAt': Mapper.i.$enc(e.transactedAt, 'transactedAt'),
        'type': 'expense'
      };

  @override
  String stringify(ExpenseEntry self) =>
      'ExpenseEntry(id: ${Mapper.asString(self.id)}, createdAt: ${Mapper.asString(self.createdAt)}, transactedAt: ${Mapper.asString(self.transactedAt)}, title: ${Mapper.asString(self.title)}, amount: ${Mapper.asString(self.amount)}, currency: ${Mapper.asString(self.currency)}, source: ${Mapper.asString(self.source)}, target: ${Mapper.asString(self.target)}, photoUrl: ${Mapper.asString(self.photoUrl)})';
  @override
  int hash(ExpenseEntry self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.createdAt) ^
      Mapper.hash(self.transactedAt) ^
      Mapper.hash(self.title) ^
      Mapper.hash(self.amount) ^
      Mapper.hash(self.currency) ^
      Mapper.hash(self.source) ^
      Mapper.hash(self.target) ^
      Mapper.hash(self.photoUrl);
  @override
  bool equals(ExpenseEntry self, ExpenseEntry other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.createdAt, other.createdAt) &&
      Mapper.isEqual(self.transactedAt, other.transactedAt) &&
      Mapper.isEqual(self.title, other.title) &&
      Mapper.isEqual(self.amount, other.amount) &&
      Mapper.isEqual(self.currency, other.currency) &&
      Mapper.isEqual(self.source, other.source) &&
      Mapper.isEqual(self.target, other.target) &&
      Mapper.isEqual(self.photoUrl, other.photoUrl);

  @override
  Function get typeFactory => (f) => f<ExpenseEntry>();
}

extension ExpenseEntryMapperExtension on ExpenseEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ExpenseEntryCopyWith<ExpenseEntry> get copyWith => ExpenseEntryCopyWith(this, $identity);
}

abstract class ExpenseEntryCopyWith<$R> {
  factory ExpenseEntryCopyWith(ExpenseEntry value, Then<ExpenseEntry, $R> then) = _ExpenseEntryCopyWithImpl<$R>;
  SplitSourceCopyWith<$R> get source;
  ExpenseTargetCopyWith<$R> get target;
  $R call(
      {String? id,
      String? title,
      double? amount,
      Currency? currency,
      SplitSource? source,
      ExpenseTarget? target,
      String? photoUrl,
      DateTime? createdAt,
      DateTime? transactedAt});
  $R apply(ExpenseEntry Function(ExpenseEntry) transform);
}

class _ExpenseEntryCopyWithImpl<$R> extends BaseCopyWith<ExpenseEntry, $R> implements ExpenseEntryCopyWith<$R> {
  _ExpenseEntryCopyWithImpl(ExpenseEntry value, Then<ExpenseEntry, $R> then) : super(value, then);

  @override
  SplitSourceCopyWith<$R> get source => SplitSourceCopyWith($value.source, (v) => call(source: v));
  @override
  ExpenseTargetCopyWith<$R> get target => ExpenseTargetCopyWith($value.target, (v) => call(target: v));
  @override
  $R call(
          {String? id,
          String? title,
          double? amount,
          Currency? currency,
          SplitSource? source,
          ExpenseTarget? target,
          Object? photoUrl = $none,
          DateTime? createdAt,
          Object? transactedAt = $none}) =>
      $then(ExpenseEntry(
          id: id ?? $value.id,
          title: title ?? $value.title,
          amount: amount ?? $value.amount,
          currency: currency ?? $value.currency,
          source: source ?? $value.source,
          target: target ?? $value.target,
          photoUrl: or(photoUrl, $value.photoUrl),
          createdAt: createdAt ?? $value.createdAt,
          transactedAt: or(transactedAt, $value.transactedAt)));
}

class PaymentEntryMapper extends BaseMapper<PaymentEntry> {
  PaymentEntryMapper._();

  @override
  Function get decoder => decode;
  PaymentEntry decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  PaymentEntry fromMap(Map<String, dynamic> map) => PaymentEntry(
      id: Mapper.i.$get(map, 'id'),
      title: Mapper.i.$get(map, 'title'),
      amount: Mapper.i.$get(map, 'amount'),
      currency: Mapper.i.$getOpt(map, 'currency') ?? Currency.euro,
      source: Mapper.i.$get(map, 'source'),
      target: Mapper.i.$get(map, 'target'),
      createdAt: Mapper.i.$get(map, 'createdAt'),
      transactedAt: Mapper.i.$getOpt(map, 'transactedAt'));

  @override
  Function get encoder => (PaymentEntry v) => encode(v);
  dynamic encode(PaymentEntry v) => toMap(v);
  Map<String, dynamic> toMap(PaymentEntry p) => {
        'id': Mapper.i.$enc(p.id, 'id'),
        'title': Mapper.i.$enc(p.title, 'title'),
        'amount': Mapper.i.$enc(p.amount, 'amount'),
        'currency': Mapper.i.$enc(p.currency, 'currency'),
        'source': Mapper.i.$enc(p.source, 'source'),
        'target': Mapper.i.$enc(p.target, 'target'),
        'createdAt': Mapper.i.$enc(p.createdAt, 'createdAt'),
        'transactedAt': Mapper.i.$enc(p.transactedAt, 'transactedAt'),
        'type': 'payment'
      };

  @override
  String stringify(PaymentEntry self) =>
      'PaymentEntry(id: ${Mapper.asString(self.id)}, createdAt: ${Mapper.asString(self.createdAt)}, transactedAt: ${Mapper.asString(self.transactedAt)}, title: ${Mapper.asString(self.title)}, amount: ${Mapper.asString(self.amount)}, currency: ${Mapper.asString(self.currency)}, source: ${Mapper.asString(self.source)}, target: ${Mapper.asString(self.target)})';
  @override
  int hash(PaymentEntry self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.createdAt) ^
      Mapper.hash(self.transactedAt) ^
      Mapper.hash(self.title) ^
      Mapper.hash(self.amount) ^
      Mapper.hash(self.currency) ^
      Mapper.hash(self.source) ^
      Mapper.hash(self.target);
  @override
  bool equals(PaymentEntry self, PaymentEntry other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.createdAt, other.createdAt) &&
      Mapper.isEqual(self.transactedAt, other.transactedAt) &&
      Mapper.isEqual(self.title, other.title) &&
      Mapper.isEqual(self.amount, other.amount) &&
      Mapper.isEqual(self.currency, other.currency) &&
      Mapper.isEqual(self.source, other.source) &&
      Mapper.isEqual(self.target, other.target);

  @override
  Function get typeFactory => (f) => f<PaymentEntry>();
}

extension PaymentEntryMapperExtension on PaymentEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  PaymentEntryCopyWith<PaymentEntry> get copyWith => PaymentEntryCopyWith(this, $identity);
}

abstract class PaymentEntryCopyWith<$R> {
  factory PaymentEntryCopyWith(PaymentEntry value, Then<PaymentEntry, $R> then) = _PaymentEntryCopyWithImpl<$R>;
  SplitSourceCopyWith<$R> get source;
  SplitSourceCopyWith<$R> get target;
  $R call(
      {String? id,
      String? title,
      double? amount,
      Currency? currency,
      SplitSource? source,
      SplitSource? target,
      DateTime? createdAt,
      DateTime? transactedAt});
  $R apply(PaymentEntry Function(PaymentEntry) transform);
}

class _PaymentEntryCopyWithImpl<$R> extends BaseCopyWith<PaymentEntry, $R> implements PaymentEntryCopyWith<$R> {
  _PaymentEntryCopyWithImpl(PaymentEntry value, Then<PaymentEntry, $R> then) : super(value, then);

  @override
  SplitSourceCopyWith<$R> get source => SplitSourceCopyWith($value.source, (v) => call(source: v));
  @override
  SplitSourceCopyWith<$R> get target => SplitSourceCopyWith($value.target, (v) => call(target: v));
  @override
  $R call(
          {String? id,
          String? title,
          double? amount,
          Currency? currency,
          SplitSource? source,
          SplitSource? target,
          DateTime? createdAt,
          Object? transactedAt = $none}) =>
      $then(PaymentEntry(
          id: id ?? $value.id,
          title: title ?? $value.title,
          amount: amount ?? $value.amount,
          currency: currency ?? $value.currency,
          source: source ?? $value.source,
          target: target ?? $value.target,
          createdAt: createdAt ?? $value.createdAt,
          transactedAt: or(transactedAt, $value.transactedAt)));
}

class ExchangeEntryMapper extends BaseMapper<ExchangeEntry> {
  ExchangeEntryMapper._();

  @override
  Function get decoder => decode;
  ExchangeEntry decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ExchangeEntry fromMap(Map<String, dynamic> map) => ExchangeEntry(
      id: Mapper.i.$get(map, 'id'),
      title: Mapper.i.$get(map, 'title'),
      sourceAmount: Mapper.i.$get(map, 'sourceAmount'),
      sourceCurrency: Mapper.i.$get(map, 'sourceCurrency'),
      targetAmount: Mapper.i.$get(map, 'targetAmount'),
      targetCurrency: Mapper.i.$get(map, 'targetCurrency'),
      potId: Mapper.i.$get(map, 'potId'),
      createdAt: Mapper.i.$get(map, 'createdAt'),
      transactedAt: Mapper.i.$getOpt(map, 'transactedAt'));

  @override
  Function get encoder => (ExchangeEntry v) => encode(v);
  dynamic encode(ExchangeEntry v) => toMap(v);
  Map<String, dynamic> toMap(ExchangeEntry e) => {
        'id': Mapper.i.$enc(e.id, 'id'),
        'title': Mapper.i.$enc(e.title, 'title'),
        'sourceAmount': Mapper.i.$enc(e.sourceAmount, 'sourceAmount'),
        'sourceCurrency': Mapper.i.$enc(e.sourceCurrency, 'sourceCurrency'),
        'targetAmount': Mapper.i.$enc(e.targetAmount, 'targetAmount'),
        'targetCurrency': Mapper.i.$enc(e.targetCurrency, 'targetCurrency'),
        'potId': Mapper.i.$enc(e.potId, 'potId'),
        'createdAt': Mapper.i.$enc(e.createdAt, 'createdAt'),
        'transactedAt': Mapper.i.$enc(e.transactedAt, 'transactedAt'),
        'type': 'exchange'
      };

  @override
  String stringify(ExchangeEntry self) =>
      'ExchangeEntry(id: ${Mapper.asString(self.id)}, createdAt: ${Mapper.asString(self.createdAt)}, transactedAt: ${Mapper.asString(self.transactedAt)}, title: ${Mapper.asString(self.title)}, sourceAmount: ${Mapper.asString(self.sourceAmount)}, sourceCurrency: ${Mapper.asString(self.sourceCurrency)}, targetAmount: ${Mapper.asString(self.targetAmount)}, targetCurrency: ${Mapper.asString(self.targetCurrency)}, potId: ${Mapper.asString(self.potId)})';
  @override
  int hash(ExchangeEntry self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.createdAt) ^
      Mapper.hash(self.transactedAt) ^
      Mapper.hash(self.title) ^
      Mapper.hash(self.sourceAmount) ^
      Mapper.hash(self.sourceCurrency) ^
      Mapper.hash(self.targetAmount) ^
      Mapper.hash(self.targetCurrency) ^
      Mapper.hash(self.potId);
  @override
  bool equals(ExchangeEntry self, ExchangeEntry other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.createdAt, other.createdAt) &&
      Mapper.isEqual(self.transactedAt, other.transactedAt) &&
      Mapper.isEqual(self.title, other.title) &&
      Mapper.isEqual(self.sourceAmount, other.sourceAmount) &&
      Mapper.isEqual(self.sourceCurrency, other.sourceCurrency) &&
      Mapper.isEqual(self.targetAmount, other.targetAmount) &&
      Mapper.isEqual(self.targetCurrency, other.targetCurrency) &&
      Mapper.isEqual(self.potId, other.potId);

  @override
  Function get typeFactory => (f) => f<ExchangeEntry>();
}

extension ExchangeEntryMapperExtension on ExchangeEntry {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ExchangeEntryCopyWith<ExchangeEntry> get copyWith => ExchangeEntryCopyWith(this, $identity);
}

abstract class ExchangeEntryCopyWith<$R> {
  factory ExchangeEntryCopyWith(ExchangeEntry value, Then<ExchangeEntry, $R> then) = _ExchangeEntryCopyWithImpl<$R>;
  $R call(
      {String? id,
      String? title,
      double? sourceAmount,
      Currency? sourceCurrency,
      double? targetAmount,
      Currency? targetCurrency,
      String? potId,
      DateTime? createdAt,
      DateTime? transactedAt});
  $R apply(ExchangeEntry Function(ExchangeEntry) transform);
}

class _ExchangeEntryCopyWithImpl<$R> extends BaseCopyWith<ExchangeEntry, $R> implements ExchangeEntryCopyWith<$R> {
  _ExchangeEntryCopyWithImpl(ExchangeEntry value, Then<ExchangeEntry, $R> then) : super(value, then);

  @override
  $R call(
          {String? id,
          String? title,
          double? sourceAmount,
          Currency? sourceCurrency,
          double? targetAmount,
          Currency? targetCurrency,
          String? potId,
          DateTime? createdAt,
          Object? transactedAt = $none}) =>
      $then(ExchangeEntry(
          id: id ?? $value.id,
          title: title ?? $value.title,
          sourceAmount: sourceAmount ?? $value.sourceAmount,
          sourceCurrency: sourceCurrency ?? $value.sourceCurrency,
          targetAmount: targetAmount ?? $value.targetAmount,
          targetCurrency: targetCurrency ?? $value.targetCurrency,
          potId: potId ?? $value.potId,
          createdAt: createdAt ?? $value.createdAt,
          transactedAt: or(transactedAt, $value.transactedAt)));
}

class ExpenseTargetMapper extends BaseMapper<ExpenseTarget> {
  ExpenseTargetMapper._();

  @override
  Function get decoder => decode;
  ExpenseTarget decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ExpenseTarget fromMap(Map<String, dynamic> map) =>
      ExpenseTarget(amounts: Mapper.i.$getOpt(map, 'amounts') ?? const {}, type: Mapper.i.$get(map, 'type'));

  @override
  Function get encoder => (ExpenseTarget v) => encode(v);
  dynamic encode(ExpenseTarget v) => toMap(v);
  Map<String, dynamic> toMap(ExpenseTarget e) =>
      {'amounts': Mapper.i.$enc(e.amounts, 'amounts'), 'type': Mapper.i.$enc(e.type, 'type')};

  @override
  String stringify(ExpenseTarget self) =>
      'ExpenseTarget(type: ${Mapper.asString(self.type)}, amounts: ${Mapper.asString(self.amounts)})';
  @override
  int hash(ExpenseTarget self) => Mapper.hash(self.type) ^ Mapper.hash(self.amounts);
  @override
  bool equals(ExpenseTarget self, ExpenseTarget other) =>
      Mapper.isEqual(self.type, other.type) && Mapper.isEqual(self.amounts, other.amounts);

  @override
  Function get typeFactory => (f) => f<ExpenseTarget>();
}

extension ExpenseTargetMapperExtension on ExpenseTarget {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ExpenseTargetCopyWith<ExpenseTarget> get copyWith => ExpenseTargetCopyWith(this, $identity);
}

abstract class ExpenseTargetCopyWith<$R> {
  factory ExpenseTargetCopyWith(ExpenseTarget value, Then<ExpenseTarget, $R> then) = _ExpenseTargetCopyWithImpl<$R>;
  $R call({Map<String, double>? amounts, ExpenseTargetType? type});
  $R apply(ExpenseTarget Function(ExpenseTarget) transform);
}

class _ExpenseTargetCopyWithImpl<$R> extends BaseCopyWith<ExpenseTarget, $R> implements ExpenseTargetCopyWith<$R> {
  _ExpenseTargetCopyWithImpl(ExpenseTarget value, Then<ExpenseTarget, $R> then) : super(value, then);

  @override
  $R call({Map<String, double>? amounts, ExpenseTargetType? type}) =>
      $then(ExpenseTarget(amounts: amounts ?? $value.amounts, type: type ?? $value.type));
}

class TheButtonStateMapper extends BaseMapper<TheButtonState> {
  TheButtonStateMapper._();

  @override
  Function get decoder => decode;
  TheButtonState decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  TheButtonState fromMap(Map<String, dynamic> map) => TheButtonState(
      lastReset: Mapper.i.$getOpt(map, 'lastReset'),
      aliveHours: Mapper.i.$get(map, 'aliveHours'),
      leaderboard: Mapper.i.$get(map, 'leaderboard'),
      showInAvatars: Mapper.i.$getOpt(map, 'showInAvatars') ?? false);

  @override
  Function get encoder => (TheButtonState v) => encode(v);
  dynamic encode(TheButtonState v) => toMap(v);
  Map<String, dynamic> toMap(TheButtonState t) => {
        'lastReset': Mapper.i.$enc(t.lastReset, 'lastReset'),
        'aliveHours': Mapper.i.$enc(t.aliveHours, 'aliveHours'),
        'leaderboard': Mapper.i.$enc(t.leaderboard, 'leaderboard'),
        'showInAvatars': Mapper.i.$enc(t.showInAvatars, 'showInAvatars')
      };

  @override
  String stringify(TheButtonState self) =>
      'TheButtonState(lastReset: ${Mapper.asString(self.lastReset)}, aliveHours: ${Mapper.asString(self.aliveHours)}, leaderboard: ${Mapper.asString(self.leaderboard)}, showInAvatars: ${Mapper.asString(self.showInAvatars)})';
  @override
  int hash(TheButtonState self) =>
      Mapper.hash(self.lastReset) ^
      Mapper.hash(self.aliveHours) ^
      Mapper.hash(self.leaderboard) ^
      Mapper.hash(self.showInAvatars);
  @override
  bool equals(TheButtonState self, TheButtonState other) =>
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
  $R call({Object? lastReset = $none, double? aliveHours, Map<String, int>? leaderboard, bool? showInAvatars}) =>
      $then(TheButtonState(
          lastReset: or(lastReset, $value.lastReset),
          aliveHours: aliveHours ?? $value.aliveHours,
          leaderboard: leaderboard ?? $value.leaderboard,
          showInAvatars: showInAvatars ?? $value.showInAvatars));
}

class LaunchUrlParamsMapper extends BaseMapper<LaunchUrlParams> {
  LaunchUrlParamsMapper._();

  @override
  Function get decoder => decode;
  LaunchUrlParams decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  LaunchUrlParams fromMap(Map<String, dynamic> map) => LaunchUrlParams(
      url: Mapper.i.$getOpt(map, 'url'),
      label: Mapper.i.$getOpt(map, 'label'),
      icon: Mapper.i.$getOpt(map, 'icon'),
      imageUrl: Mapper.i.$getOpt(map, 'imageUrl'));

  @override
  Function get encoder => (LaunchUrlParams v) => encode(v);
  dynamic encode(LaunchUrlParams v) => toMap(v);
  Map<String, dynamic> toMap(LaunchUrlParams l) => {
        'url': Mapper.i.$enc(l.url, 'url'),
        'label': Mapper.i.$enc(l.label, 'label'),
        'icon': Mapper.i.$enc(l.icon, 'icon'),
        'imageUrl': Mapper.i.$enc(l.imageUrl, 'imageUrl')
      };

  @override
  String stringify(LaunchUrlParams self) =>
      'LaunchUrlParams(url: ${Mapper.asString(self.url)}, label: ${Mapper.asString(self.label)}, icon: ${Mapper.asString(self.icon)}, imageUrl: ${Mapper.asString(self.imageUrl)})';
  @override
  int hash(LaunchUrlParams self) =>
      Mapper.hash(self.url) ^ Mapper.hash(self.label) ^ Mapper.hash(self.icon) ^ Mapper.hash(self.imageUrl);
  @override
  bool equals(LaunchUrlParams self, LaunchUrlParams other) =>
      Mapper.isEqual(self.url, other.url) &&
      Mapper.isEqual(self.label, other.label) &&
      Mapper.isEqual(self.icon, other.icon) &&
      Mapper.isEqual(self.imageUrl, other.imageUrl);

  @override
  Function get typeFactory => (f) => f<LaunchUrlParams>();
}

extension LaunchUrlParamsMapperExtension on LaunchUrlParams {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  LaunchUrlParamsCopyWith<LaunchUrlParams> get copyWith => LaunchUrlParamsCopyWith(this, $identity);
}

abstract class LaunchUrlParamsCopyWith<$R> {
  factory LaunchUrlParamsCopyWith(LaunchUrlParams value, Then<LaunchUrlParams, $R> then) =
      _LaunchUrlParamsCopyWithImpl<$R>;
  $R call({String? url, String? label, String? icon, String? imageUrl});
  $R apply(LaunchUrlParams Function(LaunchUrlParams) transform);
}

class _LaunchUrlParamsCopyWithImpl<$R> extends BaseCopyWith<LaunchUrlParams, $R>
    implements LaunchUrlParamsCopyWith<$R> {
  _LaunchUrlParamsCopyWithImpl(LaunchUrlParams value, Then<LaunchUrlParams, $R> then) : super(value, then);

  @override
  $R call({Object? url = $none, Object? label = $none, Object? icon = $none, Object? imageUrl = $none}) =>
      $then(LaunchUrlParams(
          url: or(url, $value.url),
          label: or(label, $value.label),
          icon: or(icon, $value.icon),
          imageUrl: or(imageUrl, $value.imageUrl)));
}

class WebPageParamsMapper extends BaseMapper<WebPageParams> {
  WebPageParamsMapper._();

  @override
  Function get decoder => decode;
  WebPageParams decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  WebPageParams fromMap(Map<String, dynamic> map) =>
      WebPageParams(url: Mapper.i.$getOpt(map, 'url'), canNavigate: Mapper.i.$getOpt(map, 'canNavigate') ?? true);

  @override
  Function get encoder => (WebPageParams v) => encode(v);
  dynamic encode(WebPageParams v) => toMap(v);
  Map<String, dynamic> toMap(WebPageParams w) =>
      {'url': Mapper.i.$enc(w.url, 'url'), 'canNavigate': Mapper.i.$enc(w.canNavigate, 'canNavigate')};

  @override
  String stringify(WebPageParams self) =>
      'WebPageParams(url: ${Mapper.asString(self.url)}, canNavigate: ${Mapper.asString(self.canNavigate)})';
  @override
  int hash(WebPageParams self) => Mapper.hash(self.url) ^ Mapper.hash(self.canNavigate);
  @override
  bool equals(WebPageParams self, WebPageParams other) =>
      Mapper.isEqual(self.url, other.url) && Mapper.isEqual(self.canNavigate, other.canNavigate);

  @override
  Function get typeFactory => (f) => f<WebPageParams>();
}

extension WebPageParamsMapperExtension on WebPageParams {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  WebPageParamsCopyWith<WebPageParams> get copyWith => WebPageParamsCopyWith(this, $identity);
}

abstract class WebPageParamsCopyWith<$R> {
  factory WebPageParamsCopyWith(WebPageParams value, Then<WebPageParams, $R> then) = _WebPageParamsCopyWithImpl<$R>;
  $R call({String? url, bool? canNavigate});
  $R apply(WebPageParams Function(WebPageParams) transform);
}

class _WebPageParamsCopyWithImpl<$R> extends BaseCopyWith<WebPageParams, $R> implements WebPageParamsCopyWith<$R> {
  _WebPageParamsCopyWithImpl(WebPageParams value, Then<WebPageParams, $R> then) : super(value, then);

  @override
  $R call({Object? url = $none, bool? canNavigate}) =>
      $then(WebPageParams(url: or(url, $value.url), canNavigate: canNavigate ?? $value.canNavigate));
}

class CounterStateMapper extends BaseMapper<CounterState> {
  CounterStateMapper._();

  @override
  Function get decoder => decode;
  CounterState decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  CounterState fromMap(Map<String, dynamic> map) =>
      CounterState(Mapper.i.$get(map, 'count'), Mapper.i.$get(map, 'label'));

  @override
  Function get encoder => (CounterState v) => encode(v);
  dynamic encode(CounterState v) => toMap(v);
  Map<String, dynamic> toMap(CounterState c) =>
      {'count': Mapper.i.$enc(c.count, 'count'), 'label': Mapper.i.$enc(c.label, 'label')};

  @override
  String stringify(CounterState self) =>
      'CounterState(count: ${Mapper.asString(self.count)}, label: ${Mapper.asString(self.label)})';
  @override
  int hash(CounterState self) => Mapper.hash(self.count) ^ Mapper.hash(self.label);
  @override
  bool equals(CounterState self, CounterState other) =>
      Mapper.isEqual(self.count, other.count) && Mapper.isEqual(self.label, other.label);

  @override
  Function get typeFactory => (f) => f<CounterState>();
}

extension CounterStateMapperExtension on CounterState {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  CounterStateCopyWith<CounterState> get copyWith => CounterStateCopyWith(this, $identity);
}

abstract class CounterStateCopyWith<$R> {
  factory CounterStateCopyWith(CounterState value, Then<CounterState, $R> then) = _CounterStateCopyWithImpl<$R>;
  $R call({int? count, String? label});
  $R apply(CounterState Function(CounterState) transform);
}

class _CounterStateCopyWithImpl<$R> extends BaseCopyWith<CounterState, $R> implements CounterStateCopyWith<$R> {
  _CounterStateCopyWithImpl(CounterState value, Then<CounterState, $R> then) : super(value, then);

  @override
  $R call({int? count, String? label}) => $then(CounterState(count ?? $value.count, label ?? $value.label));
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
  LayoutModel fromMap(Map<String, dynamic> map) =>
      throw MapperException.missingSubclass('LayoutModel', 'type', '${map['type']}');

  @override
  Function get encoder => (LayoutModel v) => encode(v);
  dynamic encode(LayoutModel v) {
    if (v is DropsLayoutModel) {
      return DropsLayoutModelMapper._().encode(v);
    } else if (v is FocusLayoutModel) {
      return FocusLayoutModelMapper._().encode(v);
    } else if (v is FullPageLayoutModel) {
      return FullPageLayoutModelMapper._().encode(v);
    } else if (v is GridLayoutModel) {
      return GridLayoutModelMapper._().encode(v);
    } else {
      return toMap(v);
    }
  }

  Map<String, dynamic> toMap(LayoutModel l) => {};

  @override
  String stringify(LayoutModel self) => 'LayoutModel()';
  @override
  int hash(LayoutModel self) => 0;
  @override
  bool equals(LayoutModel self, LayoutModel other) => true;

  @override
  Function get typeFactory => (f) => f<LayoutModel>();
}

extension LayoutModelMapperExtension on LayoutModel {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
}

class UserDataMapper extends BaseMapper<UserData> {
  UserDataMapper._();

  @override
  Function get decoder => decode;
  UserData decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  UserData fromMap(Map<String, dynamic> map) => UserData(
      Mapper.i.$get(map, 'id'),
      Mapper.i.$getOpt(map, 'displayName'),
      Mapper.i.$getOpt(map, 'email'),
      Mapper.i.$getOpt(map, 'photoUrl'),
      Mapper.i.$getOpt(map, 'phoneNumber'),
      Mapper.i.$getOpt(map, 'emailVerified'),
      Mapper.i.$getOpt(map, 'disabled'),
      Mapper.i.$getOpt(map, 'metadata'),
      Mapper.i.$getOpt(map, 'providerData'),
      Mapper.i.$get(map, 'claims'));

  @override
  Function get encoder => (UserData v) => encode(v);
  dynamic encode(UserData v) => toMap(v);
  Map<String, dynamic> toMap(UserData u) => {
        'id': Mapper.i.$enc(u.id, 'id'),
        'displayName': Mapper.i.$enc(u.displayName, 'displayName'),
        'email': Mapper.i.$enc(u.email, 'email'),
        'photoUrl': Mapper.i.$enc(u.photoUrl, 'photoUrl'),
        'phoneNumber': Mapper.i.$enc(u.phoneNumber, 'phoneNumber'),
        'emailVerified': Mapper.i.$enc(u.emailVerified, 'emailVerified'),
        'disabled': Mapper.i.$enc(u.disabled, 'disabled'),
        'metadata': Mapper.i.$enc(u.metadata, 'metadata'),
        'providerData': Mapper.i.$enc(u.providerData, 'providerData'),
        'claims': Mapper.i.$enc(u.claims, 'claims')
      };

  @override
  String stringify(UserData self) =>
      'UserData(id: ${Mapper.asString(self.id)}, displayName: ${Mapper.asString(self.displayName)}, email: ${Mapper.asString(self.email)}, photoUrl: ${Mapper.asString(self.photoUrl)}, phoneNumber: ${Mapper.asString(self.phoneNumber)}, emailVerified: ${Mapper.asString(self.emailVerified)}, disabled: ${Mapper.asString(self.disabled)}, metadata: ${Mapper.asString(self.metadata)}, providerData: ${Mapper.asString(self.providerData)}, claims: ${Mapper.asString(self.claims)})';
  @override
  int hash(UserData self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.displayName) ^
      Mapper.hash(self.email) ^
      Mapper.hash(self.photoUrl) ^
      Mapper.hash(self.phoneNumber) ^
      Mapper.hash(self.emailVerified) ^
      Mapper.hash(self.disabled) ^
      Mapper.hash(self.metadata) ^
      Mapper.hash(self.providerData) ^
      Mapper.hash(self.claims);
  @override
  bool equals(UserData self, UserData other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.displayName, other.displayName) &&
      Mapper.isEqual(self.email, other.email) &&
      Mapper.isEqual(self.photoUrl, other.photoUrl) &&
      Mapper.isEqual(self.phoneNumber, other.phoneNumber) &&
      Mapper.isEqual(self.emailVerified, other.emailVerified) &&
      Mapper.isEqual(self.disabled, other.disabled) &&
      Mapper.isEqual(self.metadata, other.metadata) &&
      Mapper.isEqual(self.providerData, other.providerData) &&
      Mapper.isEqual(self.claims, other.claims);

  @override
  Function get typeFactory => (f) => f<UserData>();
}

extension UserDataMapperExtension on UserData {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  UserDataCopyWith<UserData> get copyWith => UserDataCopyWith(this, $identity);
}

abstract class UserDataCopyWith<$R> {
  factory UserDataCopyWith(UserData value, Then<UserData, $R> then) = _UserDataCopyWithImpl<$R>;
  UserMetadataCopyWith<$R>? get metadata;
  ListCopyWith<$R, UserInfo, UserInfoCopyWith<$R>>? get providerData;
  UserClaimsCopyWith<$R> get claims;
  $R call(
      {String? id,
      String? displayName,
      String? email,
      String? photoUrl,
      String? phoneNumber,
      bool? emailVerified,
      bool? disabled,
      UserMetadata? metadata,
      List<UserInfo>? providerData,
      UserClaims? claims});
  $R apply(UserData Function(UserData) transform);
}

class _UserDataCopyWithImpl<$R> extends BaseCopyWith<UserData, $R> implements UserDataCopyWith<$R> {
  _UserDataCopyWithImpl(UserData value, Then<UserData, $R> then) : super(value, then);

  @override
  UserMetadataCopyWith<$R>? get metadata =>
      $value.metadata != null ? UserMetadataCopyWith($value.metadata!, (v) => call(metadata: v)) : null;
  @override
  ListCopyWith<$R, UserInfo, UserInfoCopyWith<$R>>? get providerData => $value.providerData != null
      ? ListCopyWith($value.providerData!, (v, t) => UserInfoCopyWith(v, t), (v) => call(providerData: v))
      : null;
  @override
  UserClaimsCopyWith<$R> get claims => UserClaimsCopyWith($value.claims, (v) => call(claims: v));
  @override
  $R call(
          {String? id,
          Object? displayName = $none,
          Object? email = $none,
          Object? photoUrl = $none,
          Object? phoneNumber = $none,
          Object? emailVerified = $none,
          Object? disabled = $none,
          Object? metadata = $none,
          Object? providerData = $none,
          UserClaims? claims}) =>
      $then(UserData(
          id ?? $value.id,
          or(displayName, $value.displayName),
          or(email, $value.email),
          or(photoUrl, $value.photoUrl),
          or(phoneNumber, $value.phoneNumber),
          or(emailVerified, $value.emailVerified),
          or(disabled, $value.disabled),
          or(metadata, $value.metadata),
          or(providerData, $value.providerData),
          claims ?? $value.claims));
}

class UserMetadataMapper extends BaseMapper<UserMetadata> {
  UserMetadataMapper._();

  @override
  Function get decoder => decode;
  UserMetadata decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  UserMetadata fromMap(Map<String, dynamic> map) =>
      UserMetadata(Mapper.i.$getOpt(map, 'creationTime'), Mapper.i.$getOpt(map, 'lastSignInTime'));

  @override
  Function get encoder => (UserMetadata v) => encode(v);
  dynamic encode(UserMetadata v) => toMap(v);
  Map<String, dynamic> toMap(UserMetadata u) => {
        'creationTime': Mapper.i.$enc(u.creationTime, 'creationTime'),
        'lastSignInTime': Mapper.i.$enc(u.lastSignInTime, 'lastSignInTime')
      };

  @override
  String stringify(UserMetadata self) =>
      'UserMetadata(creationTime: ${Mapper.asString(self.creationTime)}, lastSignInTime: ${Mapper.asString(self.lastSignInTime)})';
  @override
  int hash(UserMetadata self) => Mapper.hash(self.creationTime) ^ Mapper.hash(self.lastSignInTime);
  @override
  bool equals(UserMetadata self, UserMetadata other) =>
      Mapper.isEqual(self.creationTime, other.creationTime) &&
      Mapper.isEqual(self.lastSignInTime, other.lastSignInTime);

  @override
  Function get typeFactory => (f) => f<UserMetadata>();
}

extension UserMetadataMapperExtension on UserMetadata {
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

  @override
  $R call({Object? creationTime = $none, Object? lastSignInTime = $none}) =>
      $then(UserMetadata(or(creationTime, $value.creationTime), or(lastSignInTime, $value.lastSignInTime)));
}

class UserInfoMapper extends BaseMapper<UserInfo> {
  UserInfoMapper._();

  @override
  Function get decoder => decode;
  UserInfo decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  UserInfo fromMap(Map<String, dynamic> map) => UserInfo(
      Mapper.i.$get(map, 'uid'),
      Mapper.i.$getOpt(map, 'displayName'),
      Mapper.i.$getOpt(map, 'email'),
      Mapper.i.$getOpt(map, 'photoUrl'),
      Mapper.i.$get(map, 'providerId'),
      Mapper.i.$getOpt(map, 'phoneNumber'));

  @override
  Function get encoder => (UserInfo v) => encode(v);
  dynamic encode(UserInfo v) => toMap(v);
  Map<String, dynamic> toMap(UserInfo u) => {
        'uid': Mapper.i.$enc(u.uid, 'uid'),
        'displayName': Mapper.i.$enc(u.displayName, 'displayName'),
        'email': Mapper.i.$enc(u.email, 'email'),
        'photoUrl': Mapper.i.$enc(u.photoUrl, 'photoUrl'),
        'providerId': Mapper.i.$enc(u.providerId, 'providerId'),
        'phoneNumber': Mapper.i.$enc(u.phoneNumber, 'phoneNumber')
      };

  @override
  String stringify(UserInfo self) =>
      'UserInfo(uid: ${Mapper.asString(self.uid)}, displayName: ${Mapper.asString(self.displayName)}, email: ${Mapper.asString(self.email)}, photoUrl: ${Mapper.asString(self.photoUrl)}, providerId: ${Mapper.asString(self.providerId)}, phoneNumber: ${Mapper.asString(self.phoneNumber)})';
  @override
  int hash(UserInfo self) =>
      Mapper.hash(self.uid) ^
      Mapper.hash(self.displayName) ^
      Mapper.hash(self.email) ^
      Mapper.hash(self.photoUrl) ^
      Mapper.hash(self.providerId) ^
      Mapper.hash(self.phoneNumber);
  @override
  bool equals(UserInfo self, UserInfo other) =>
      Mapper.isEqual(self.uid, other.uid) &&
      Mapper.isEqual(self.displayName, other.displayName) &&
      Mapper.isEqual(self.email, other.email) &&
      Mapper.isEqual(self.photoUrl, other.photoUrl) &&
      Mapper.isEqual(self.providerId, other.providerId) &&
      Mapper.isEqual(self.phoneNumber, other.phoneNumber);

  @override
  Function get typeFactory => (f) => f<UserInfo>();
}

extension UserInfoMapperExtension on UserInfo {
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

  @override
  $R call(
          {String? uid,
          Object? displayName = $none,
          Object? email = $none,
          Object? photoUrl = $none,
          String? providerId,
          Object? phoneNumber = $none}) =>
      $then(UserInfo(uid ?? $value.uid, or(displayName, $value.displayName), or(email, $value.email),
          or(photoUrl, $value.photoUrl), providerId ?? $value.providerId, or(phoneNumber, $value.phoneNumber)));
}

class UserClaimsMapper extends BaseMapper<UserClaims> {
  UserClaimsMapper._();

  @override
  Function get decoder => decode;
  UserClaims decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  UserClaims fromMap(Map<String, dynamic> map) => UserClaims(
      isGroupCreator: Mapper.i.$getOpt(map, 'isGroupCreator') ?? false,
      isAdmin: Mapper.i.$getOpt(map, 'isAdmin') ?? false);

  @override
  Function get encoder => (UserClaims v) => encode(v);
  dynamic encode(UserClaims v) => toMap(v);
  Map<String, dynamic> toMap(UserClaims u) => {
        'isGroupCreator': Mapper.i.$enc(u.isGroupCreator, 'isGroupCreator'),
        'isAdmin': Mapper.i.$enc(u.isAdmin, 'isAdmin')
      };

  @override
  String stringify(UserClaims self) =>
      'UserClaims(isGroupCreator: ${Mapper.asString(self.isGroupCreator)}, isAdmin: ${Mapper.asString(self.isAdmin)})';
  @override
  int hash(UserClaims self) => Mapper.hash(self.isGroupCreator) ^ Mapper.hash(self.isAdmin);
  @override
  bool equals(UserClaims self, UserClaims other) =>
      Mapper.isEqual(self.isGroupCreator, other.isGroupCreator) && Mapper.isEqual(self.isAdmin, other.isAdmin);

  @override
  Function get typeFactory => (f) => f<UserClaims>();
}

extension UserClaimsMapperExtension on UserClaims {
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

  @override
  $R call({bool? isGroupCreator, bool? isAdmin}) =>
      $then(UserClaims(isGroupCreator: isGroupCreator ?? $value.isGroupCreator, isAdmin: isAdmin ?? $value.isAdmin));
}

class AnnouncementNotificationMapper extends BaseMapper<AnnouncementNotification> {
  AnnouncementNotificationMapper._();

  @override
  Function get decoder => decode;
  AnnouncementNotification decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  AnnouncementNotification fromMap(Map<String, dynamic> map) => AnnouncementNotification(
      Mapper.i.$get(map, 'groupId'),
      Mapper.i.$get(map, 'groupName'),
      Mapper.i.$getOpt(map, 'groupPicture'),
      Mapper.i.$get(map, 'id'),
      Mapper.i.$get(map, 'title'),
      Mapper.i.$get(map, 'message'),
      Mapper.i.$getOpt(map, 'color'));

  @override
  Function get encoder => (AnnouncementNotification v) => encode(v);
  dynamic encode(AnnouncementNotification v) => toMap(v);
  Map<String, dynamic> toMap(AnnouncementNotification a) => {
        'groupId': Mapper.i.$enc(a.groupId, 'groupId'),
        'groupName': Mapper.i.$enc(a.groupName, 'groupName'),
        'groupPicture': Mapper.i.$enc(a.groupPicture, 'groupPicture'),
        'id': Mapper.i.$enc(a.id, 'id'),
        'title': Mapper.i.$enc(a.title, 'title'),
        'message': Mapper.i.$enc(a.message, 'message'),
        'color': Mapper.i.$enc(a.color, 'color')
      };

  @override
  String stringify(AnnouncementNotification self) =>
      'AnnouncementNotification(groupId: ${Mapper.asString(self.groupId)}, groupName: ${Mapper.asString(self.groupName)}, groupPicture: ${Mapper.asString(self.groupPicture)}, id: ${Mapper.asString(self.id)}, title: ${Mapper.asString(self.title)}, message: ${Mapper.asString(self.message)}, color: ${Mapper.asString(self.color)})';
  @override
  int hash(AnnouncementNotification self) =>
      Mapper.hash(self.groupId) ^
      Mapper.hash(self.groupName) ^
      Mapper.hash(self.groupPicture) ^
      Mapper.hash(self.id) ^
      Mapper.hash(self.title) ^
      Mapper.hash(self.message) ^
      Mapper.hash(self.color);
  @override
  bool equals(AnnouncementNotification self, AnnouncementNotification other) =>
      Mapper.isEqual(self.groupId, other.groupId) &&
      Mapper.isEqual(self.groupName, other.groupName) &&
      Mapper.isEqual(self.groupPicture, other.groupPicture) &&
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.title, other.title) &&
      Mapper.isEqual(self.message, other.message) &&
      Mapper.isEqual(self.color, other.color);

  @override
  Function get typeFactory => (f) => f<AnnouncementNotification>();
}

extension AnnouncementNotificationMapperExtension on AnnouncementNotification {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  AnnouncementNotificationCopyWith<AnnouncementNotification> get copyWith =>
      AnnouncementNotificationCopyWith(this, $identity);
}

abstract class AnnouncementNotificationCopyWith<$R> {
  factory AnnouncementNotificationCopyWith(AnnouncementNotification value, Then<AnnouncementNotification, $R> then) =
      _AnnouncementNotificationCopyWithImpl<$R>;
  $R call(
      {String? groupId,
      String? groupName,
      String? groupPicture,
      String? id,
      String? title,
      String? message,
      String? color});
  $R apply(AnnouncementNotification Function(AnnouncementNotification) transform);
}

class _AnnouncementNotificationCopyWithImpl<$R> extends BaseCopyWith<AnnouncementNotification, $R>
    implements AnnouncementNotificationCopyWith<$R> {
  _AnnouncementNotificationCopyWithImpl(AnnouncementNotification value, Then<AnnouncementNotification, $R> then)
      : super(value, then);

  @override
  $R call(
          {String? groupId,
          String? groupName,
          Object? groupPicture = $none,
          String? id,
          String? title,
          String? message,
          Object? color = $none}) =>
      $then(AnnouncementNotification(
          groupId ?? $value.groupId,
          groupName ?? $value.groupName,
          or(groupPicture, $value.groupPicture),
          id ?? $value.id,
          title ?? $value.title,
          message ?? $value.message,
          or(color, $value.color)));
}

class ChatNotificationMapper extends BaseMapper<ChatNotification> {
  ChatNotificationMapper._();

  @override
  Function get decoder => decode;
  ChatNotification decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  ChatNotification fromMap(Map<String, dynamic> map) => ChatNotification(
      Mapper.i.$get(map, 'id'),
      Mapper.i.$get(map, 'groupId'),
      Mapper.i.$get(map, 'groupName'),
      Mapper.i.$get(map, 'color'),
      Mapper.i.$get(map, 'channelId'),
      Mapper.i.$get(map, 'channelName'),
      Mapper.i.$get(map, 'userId'),
      Mapper.i.$get(map, 'userName'),
      Mapper.i.$getOpt(map, 'pictureUrl'),
      Mapper.i.$get(map, 'text'));

  @override
  Function get encoder => (ChatNotification v) => encode(v);
  dynamic encode(ChatNotification v) => toMap(v);
  Map<String, dynamic> toMap(ChatNotification c) => {
        'id': Mapper.i.$enc(c.id, 'id'),
        'groupId': Mapper.i.$enc(c.groupId, 'groupId'),
        'groupName': Mapper.i.$enc(c.groupName, 'groupName'),
        'color': Mapper.i.$enc(c.color, 'color'),
        'channelId': Mapper.i.$enc(c.channelId, 'channelId'),
        'channelName': Mapper.i.$enc(c.channelName, 'channelName'),
        'userId': Mapper.i.$enc(c.userId, 'userId'),
        'userName': Mapper.i.$enc(c.userName, 'userName'),
        'pictureUrl': Mapper.i.$enc(c.pictureUrl, 'pictureUrl'),
        'text': Mapper.i.$enc(c.text, 'text')
      };

  @override
  String stringify(ChatNotification self) =>
      'ChatNotification(id: ${Mapper.asString(self.id)}, groupId: ${Mapper.asString(self.groupId)}, groupName: ${Mapper.asString(self.groupName)}, color: ${Mapper.asString(self.color)}, channelId: ${Mapper.asString(self.channelId)}, channelName: ${Mapper.asString(self.channelName)}, userId: ${Mapper.asString(self.userId)}, userName: ${Mapper.asString(self.userName)}, pictureUrl: ${Mapper.asString(self.pictureUrl)}, text: ${Mapper.asString(self.text)})';
  @override
  int hash(ChatNotification self) =>
      Mapper.hash(self.id) ^
      Mapper.hash(self.groupId) ^
      Mapper.hash(self.groupName) ^
      Mapper.hash(self.color) ^
      Mapper.hash(self.channelId) ^
      Mapper.hash(self.channelName) ^
      Mapper.hash(self.userId) ^
      Mapper.hash(self.userName) ^
      Mapper.hash(self.pictureUrl) ^
      Mapper.hash(self.text);
  @override
  bool equals(ChatNotification self, ChatNotification other) =>
      Mapper.isEqual(self.id, other.id) &&
      Mapper.isEqual(self.groupId, other.groupId) &&
      Mapper.isEqual(self.groupName, other.groupName) &&
      Mapper.isEqual(self.color, other.color) &&
      Mapper.isEqual(self.channelId, other.channelId) &&
      Mapper.isEqual(self.channelName, other.channelName) &&
      Mapper.isEqual(self.userId, other.userId) &&
      Mapper.isEqual(self.userName, other.userName) &&
      Mapper.isEqual(self.pictureUrl, other.pictureUrl) &&
      Mapper.isEqual(self.text, other.text);

  @override
  Function get typeFactory => (f) => f<ChatNotification>();
}

extension ChatNotificationMapperExtension on ChatNotification {
  String toJson() => Mapper.toJson(this);
  Map<String, dynamic> toMap() => Mapper.toMap(this);
  ChatNotificationCopyWith<ChatNotification> get copyWith => ChatNotificationCopyWith(this, $identity);
}

abstract class ChatNotificationCopyWith<$R> {
  factory ChatNotificationCopyWith(ChatNotification value, Then<ChatNotification, $R> then) =
      _ChatNotificationCopyWithImpl<$R>;
  $R call(
      {String? id,
      String? groupId,
      String? groupName,
      String? color,
      String? channelId,
      String? channelName,
      String? userId,
      String? userName,
      String? pictureUrl,
      String? text});
  $R apply(ChatNotification Function(ChatNotification) transform);
}

class _ChatNotificationCopyWithImpl<$R> extends BaseCopyWith<ChatNotification, $R>
    implements ChatNotificationCopyWith<$R> {
  _ChatNotificationCopyWithImpl(ChatNotification value, Then<ChatNotification, $R> then) : super(value, then);

  @override
  $R call(
          {String? id,
          String? groupId,
          String? groupName,
          String? color,
          String? channelId,
          String? channelName,
          String? userId,
          String? userName,
          Object? pictureUrl = $none,
          String? text}) =>
      $then(ChatNotification(
          id ?? $value.id,
          groupId ?? $value.groupId,
          groupName ?? $value.groupName,
          color ?? $value.color,
          channelId ?? $value.channelId,
          channelName ?? $value.channelName,
          userId ?? $value.userId,
          userName ?? $value.userName,
          or(pictureUrl, $value.pictureUrl),
          text ?? $value.text));
}

class GroupFilterMapper extends BaseMapper<GroupFilter> {
  GroupFilterMapper._();
}

extension GroupFilterMapperExtension on GroupFilter {
  GroupFilterCopyWith<GroupFilter> get copyWith => GroupFilterCopyWith(this, $identity);
}

abstract class GroupFilterCopyWith<$R> {
  factory GroupFilterCopyWith(GroupFilter value, Then<GroupFilter, $R> then) = _GroupFilterCopyWithImpl<$R>;
  $R call({String? hasUser, String? hasOrganizer});
  $R apply(GroupFilter Function(GroupFilter) transform);
}

class _GroupFilterCopyWithImpl<$R> extends BaseCopyWith<GroupFilter, $R> implements GroupFilterCopyWith<$R> {
  _GroupFilterCopyWithImpl(GroupFilter value, Then<GroupFilter, $R> then) : super(value, then);

  @override
  $R call({Object? hasUser = $none, Object? hasOrganizer = $none}) =>
      $then(GroupFilter(hasUser: or(hasUser, $value.hasUser), hasOrganizer: or(hasOrganizer, $value.hasOrganizer)));
}

class UserFilterMapper extends BaseMapper<UserFilter> {
  UserFilterMapper._();
}

extension UserFilterMapperExtension on UserFilter {
  UserFilterCopyWith<UserFilter> get copyWith => UserFilterCopyWith(this, $identity);
}

abstract class UserFilterCopyWith<$R> {
  factory UserFilterCopyWith(UserFilter value, Then<UserFilter, $R> then) = _UserFilterCopyWithImpl<$R>;
  $R call({bool? isAdmin, bool? isGroupCreator, String? isInGroup, String? isOrganizerOfGroup});
  $R apply(UserFilter Function(UserFilter) transform);
}

class _UserFilterCopyWithImpl<$R> extends BaseCopyWith<UserFilter, $R> implements UserFilterCopyWith<$R> {
  _UserFilterCopyWithImpl(UserFilter value, Then<UserFilter, $R> then) : super(value, then);

  @override
  $R call(
          {Object? isAdmin = $none,
          Object? isGroupCreator = $none,
          Object? isInGroup = $none,
          Object? isOrganizerOfGroup = $none}) =>
      $then(UserFilter(
          isAdmin: or(isAdmin, $value.isAdmin),
          isGroupCreator: or(isGroupCreator, $value.isGroupCreator),
          isInGroup: or(isInGroup, $value.isInGroup),
          isOrganizerOfGroup: or(isOrganizerOfGroup, $value.isOrganizerOfGroup)));
}

class DropModelMapper extends BaseMapper<DropModel> {
  DropModelMapper._();

  @override
  Function get decoder => decode;
  DropModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  DropModel fromMap(Map<String, dynamic> map) => DropModel(
      id: Mapper.i.$get(map, 'id'),
      label: Mapper.i.$getOpt(map, 'label'),
      isHidden: Mapper.i.$getOpt(map, 'isHidden') ?? false);

  @override
  Function get encoder => (DropModel v) => encode(v);
  dynamic encode(DropModel v) => toMap(v);
  Map<String, dynamic> toMap(DropModel d) => {
        'id': Mapper.i.$enc(d.id, 'id'),
        'label': Mapper.i.$enc(d.label, 'label'),
        'isHidden': Mapper.i.$enc(d.isHidden, 'isHidden')
      };

  @override
  String stringify(DropModel self) =>
      'DropModel(id: ${Mapper.asString(self.id)}, label: ${Mapper.asString(self.label)}, isHidden: ${Mapper.asString(self.isHidden)})';
  @override
  int hash(DropModel self) => Mapper.hash(self.id) ^ Mapper.hash(self.label) ^ Mapper.hash(self.isHidden);
  @override
  bool equals(DropModel self, DropModel other) =>
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
  DropsLayoutModel fromMap(Map<String, dynamic> map) => DropsLayoutModel(
      drops: Mapper.i.$getOpt(map, 'drops') ?? const [],
      wideFocus: Mapper.i.$getOpt(map, 'wideFocus') ?? true,
      coverUrl: Mapper.i.$getOpt(map, 'coverUrl'));

  @override
  Function get encoder => (DropsLayoutModel v) => encode(v);
  dynamic encode(DropsLayoutModel v) => toMap(v);
  Map<String, dynamic> toMap(DropsLayoutModel d) => {
        'drops': Mapper.i.$enc(d.drops, 'drops'),
        'wideFocus': Mapper.i.$enc(d.wideFocus, 'wideFocus'),
        'coverUrl': Mapper.i.$enc(d.coverUrl, 'coverUrl'),
        'type': 'drops'
      };

  @override
  String stringify(DropsLayoutModel self) =>
      'DropsLayoutModel(drops: ${Mapper.asString(self.drops)}, wideFocus: ${Mapper.asString(self.wideFocus)}, coverUrl: ${Mapper.asString(self.coverUrl)})';
  @override
  int hash(DropsLayoutModel self) => Mapper.hash(self.drops) ^ Mapper.hash(self.wideFocus) ^ Mapper.hash(self.coverUrl);
  @override
  bool equals(DropsLayoutModel self, DropsLayoutModel other) =>
      Mapper.isEqual(self.drops, other.drops) &&
      Mapper.isEqual(self.wideFocus, other.wideFocus) &&
      Mapper.isEqual(self.coverUrl, other.coverUrl);

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
  $R call({List<DropModel>? drops, bool? wideFocus, String? coverUrl});
  $R apply(DropsLayoutModel Function(DropsLayoutModel) transform);
}

class _DropsLayoutModelCopyWithImpl<$R> extends BaseCopyWith<DropsLayoutModel, $R>
    implements DropsLayoutModelCopyWith<$R> {
  _DropsLayoutModelCopyWithImpl(DropsLayoutModel value, Then<DropsLayoutModel, $R> then) : super(value, then);

  @override
  ListCopyWith<$R, DropModel, DropModelCopyWith<$R>> get drops =>
      ListCopyWith($value.drops, (v, t) => DropModelCopyWith(v, t), (v) => call(drops: v));
  @override
  $R call({List<DropModel>? drops, bool? wideFocus, Object? coverUrl = $none}) => $then(DropsLayoutModel(
      drops: drops ?? $value.drops, wideFocus: wideFocus ?? $value.wideFocus, coverUrl: or(coverUrl, $value.coverUrl)));
}

class FocusLayoutModelMapper extends BaseMapper<FocusLayoutModel> {
  FocusLayoutModelMapper._();

  @override
  Function get decoder => decode;
  FocusLayoutModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  FocusLayoutModel fromMap(Map<String, dynamic> map) => FocusLayoutModel(
      showActions: Mapper.i.$getOpt(map, 'showActions') ?? true,
      showInfo: Mapper.i.$getOpt(map, 'showInfo') ?? true,
      coverUrl: Mapper.i.$getOpt(map, 'coverUrl'),
      invertHeader: Mapper.i.$getOpt(map, 'invertHeader') ?? false);

  @override
  Function get encoder => (FocusLayoutModel v) => encode(v);
  dynamic encode(FocusLayoutModel v) => toMap(v);
  Map<String, dynamic> toMap(FocusLayoutModel f) => {
        'showActions': Mapper.i.$enc(f.showActions, 'showActions'),
        'showInfo': Mapper.i.$enc(f.showInfo, 'showInfo'),
        'coverUrl': Mapper.i.$enc(f.coverUrl, 'coverUrl'),
        'invertHeader': Mapper.i.$enc(f.invertHeader, 'invertHeader'),
        'type': 'focus'
      };

  @override
  String stringify(FocusLayoutModel self) =>
      'FocusLayoutModel(showActions: ${Mapper.asString(self.showActions)}, showInfo: ${Mapper.asString(self.showInfo)}, coverUrl: ${Mapper.asString(self.coverUrl)}, invertHeader: ${Mapper.asString(self.invertHeader)})';
  @override
  int hash(FocusLayoutModel self) =>
      Mapper.hash(self.showActions) ^
      Mapper.hash(self.showInfo) ^
      Mapper.hash(self.coverUrl) ^
      Mapper.hash(self.invertHeader);
  @override
  bool equals(FocusLayoutModel self, FocusLayoutModel other) =>
      Mapper.isEqual(self.showActions, other.showActions) &&
      Mapper.isEqual(self.showInfo, other.showInfo) &&
      Mapper.isEqual(self.coverUrl, other.coverUrl) &&
      Mapper.isEqual(self.invertHeader, other.invertHeader);

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
  $R call({bool? showActions, bool? showInfo, String? coverUrl, bool? invertHeader});
  $R apply(FocusLayoutModel Function(FocusLayoutModel) transform);
}

class _FocusLayoutModelCopyWithImpl<$R> extends BaseCopyWith<FocusLayoutModel, $R>
    implements FocusLayoutModelCopyWith<$R> {
  _FocusLayoutModelCopyWithImpl(FocusLayoutModel value, Then<FocusLayoutModel, $R> then) : super(value, then);

  @override
  $R call({bool? showActions, bool? showInfo, Object? coverUrl = $none, bool? invertHeader}) => $then(FocusLayoutModel(
      showActions: showActions ?? $value.showActions,
      showInfo: showInfo ?? $value.showInfo,
      coverUrl: or(coverUrl, $value.coverUrl),
      invertHeader: invertHeader ?? $value.invertHeader));
}

class FullPageLayoutModelMapper extends BaseMapper<FullPageLayoutModel> {
  FullPageLayoutModelMapper._();

  @override
  Function get decoder => decode;
  FullPageLayoutModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  FullPageLayoutModel fromMap(Map<String, dynamic> map) =>
      FullPageLayoutModel(backgroundPrimary: Mapper.i.$getOpt(map, 'backgroundPrimary') ?? false);

  @override
  Function get encoder => (FullPageLayoutModel v) => encode(v);
  dynamic encode(FullPageLayoutModel v) => toMap(v);
  Map<String, dynamic> toMap(FullPageLayoutModel f) =>
      {'backgroundPrimary': Mapper.i.$enc(f.backgroundPrimary, 'backgroundPrimary'), 'type': 'page'};

  @override
  String stringify(FullPageLayoutModel self) =>
      'FullPageLayoutModel(backgroundPrimary: ${Mapper.asString(self.backgroundPrimary)})';
  @override
  int hash(FullPageLayoutModel self) => Mapper.hash(self.backgroundPrimary);
  @override
  bool equals(FullPageLayoutModel self, FullPageLayoutModel other) =>
      Mapper.isEqual(self.backgroundPrimary, other.backgroundPrimary);

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
  $R call({bool? backgroundPrimary});
  $R apply(FullPageLayoutModel Function(FullPageLayoutModel) transform);
}

class _FullPageLayoutModelCopyWithImpl<$R> extends BaseCopyWith<FullPageLayoutModel, $R>
    implements FullPageLayoutModelCopyWith<$R> {
  _FullPageLayoutModelCopyWithImpl(FullPageLayoutModel value, Then<FullPageLayoutModel, $R> then) : super(value, then);

  @override
  $R call({bool? backgroundPrimary}) =>
      $then(FullPageLayoutModel(backgroundPrimary: backgroundPrimary ?? $value.backgroundPrimary));
}

class GridLayoutModelMapper extends BaseMapper<GridLayoutModel> {
  GridLayoutModelMapper._();

  @override
  Function get decoder => decode;
  GridLayoutModel decode(dynamic v) => checked(v, (Map<String, dynamic> map) => fromMap(map));
  GridLayoutModel fromMap(Map<String, dynamic> map) => GridLayoutModel();

  @override
  Function get encoder => (GridLayoutModel v) => encode(v);
  dynamic encode(GridLayoutModel v) => toMap(v);
  Map<String, dynamic> toMap(GridLayoutModel g) => {'type': 'grid'};

  @override
  String stringify(GridLayoutModel self) => 'GridLayoutModel()';
  @override
  int hash(GridLayoutModel self) => 0;
  @override
  bool equals(GridLayoutModel self, GridLayoutModel other) => true;

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
  $R call();
  $R apply(GridLayoutModel Function(GridLayoutModel) transform);
}

class _GridLayoutModelCopyWithImpl<$R> extends BaseCopyWith<GridLayoutModel, $R>
    implements GridLayoutModelCopyWith<$R> {
  _GridLayoutModelCopyWithImpl(GridLayoutModel value, Then<GridLayoutModel, $R> then) : super(value, then);

  @override
  $R call() => $then(GridLayoutModel());
}

// === GENERATED ENUM MAPPERS AND EXTENSIONS ===

class LabelColorMapper extends EnumMapper<LabelColor> {
  LabelColorMapper._();

  @override
  LabelColor decode(dynamic value) {
    switch (value) {
      case 'text':
        return LabelColor.text;
      case 'primary':
        return LabelColor.primary;
      case 'secondary':
        return LabelColor.secondary;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(LabelColor value) {
    switch (value) {
      case LabelColor.text:
        return 'text';
      case LabelColor.primary:
        return 'primary';
      case LabelColor.secondary:
        return 'secondary';
    }
  }
}

extension LabelColorMapperExtension on LabelColor {
  dynamic toValue() => Mapper.toValue(this);
  @Deprecated('Use \'toValue\' instead')
  String toStringValue() => Mapper.toValue(this) as String;
}

class CurrencyMapper extends EnumMapper<Currency> {
  CurrencyMapper._();

  @override
  Currency decode(dynamic value) {
    switch (value) {
      case 'euro':
        return Currency.euro;
      case 'dollar':
        return Currency.dollar;
      case 'kuna':
        return Currency.kuna;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(Currency value) {
    switch (value) {
      case Currency.euro:
        return 'euro';
      case Currency.dollar:
        return 'dollar';
      case Currency.kuna:
        return 'kuna';
    }
  }
}

extension CurrencyMapperExtension on Currency {
  dynamic toValue() => Mapper.toValue(this);
  @Deprecated('Use \'toValue\' instead')
  String toStringValue() => Mapper.toValue(this) as String;
}

class SplitSourceTypeMapper extends EnumMapper<SplitSourceType> {
  SplitSourceTypeMapper._();

  @override
  SplitSourceType decode(dynamic value) {
    switch (value) {
      case 'user':
        return SplitSourceType.user;
      case 'pot':
        return SplitSourceType.pot;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SplitSourceType value) {
    switch (value) {
      case SplitSourceType.user:
        return 'user';
      case SplitSourceType.pot:
        return 'pot';
    }
  }
}

extension SplitSourceTypeMapperExtension on SplitSourceType {
  dynamic toValue() => Mapper.toValue(this);
  @Deprecated('Use \'toValue\' instead')
  String toStringValue() => Mapper.toValue(this) as String;
}

class ExpenseTargetTypeMapper extends EnumMapper<ExpenseTargetType> {
  ExpenseTargetTypeMapper._();

  @override
  ExpenseTargetType decode(dynamic value) {
    switch (value) {
      case 'percent':
        return ExpenseTargetType.percent;
      case 'shares':
        return ExpenseTargetType.shares;
      case 'amount':
        return ExpenseTargetType.amount;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ExpenseTargetType value) {
    switch (value) {
      case ExpenseTargetType.percent:
        return 'percent';
      case ExpenseTargetType.shares:
        return 'shares';
      case ExpenseTargetType.amount:
        return 'amount';
    }
  }
}

extension ExpenseTargetTypeMapperExtension on ExpenseTargetType {
  dynamic toValue() => Mapper.toValue(this);
  @Deprecated('Use \'toValue\' instead')
  String toStringValue() => Mapper.toValue(this) as String;
}

class UserStatusMapper extends EnumMapper<UserStatus> {
  UserStatusMapper._();

  @override
  UserStatus decode(dynamic value) {
    switch (value) {
      case 'active':
        return UserStatus.active;
      case 'disabled':
        return UserStatus.disabled;
      case 'invited':
        return UserStatus.invited;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UserStatus value) {
    switch (value) {
      case UserStatus.active:
        return 'active';
      case UserStatus.disabled:
        return 'disabled';
      case UserStatus.invited:
        return 'invited';
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
        (runtimeType == other.runtimeType && _guard(() => Mapper.isEqual(this, other), () => super == other));
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
