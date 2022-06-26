library modules;

import 'announcement/announcement.module.dart';
import 'chat/chat.module.dart';
import 'elimination/elimination.module.dart';
import 'labels/labels.module.dart';
import 'music/music.module.dart';
import 'notes/notes.module.dart';
import 'polls/polls.module.dart';
import 'profile/profile.module.dart';
import 'split/split.module.dart';
import 'thebutton/thebutton.module.dart';
import 'users/users_module.dart';
import 'web/web_module.dart';
import 'counter/counter_module.dart';

final registry = ModuleRegistry([
  ProfileModule.new,
  UsersModule.new,
  NotesModule.new,
  AnnouncementModule.new,
  LabelModule.new,
  ChatModule.new,
  SplitModule.new,
  WebModule.new,
  MusicModule.new,
  PollsModule.new,
  CounterModule.new,
  TheButtonModule.new,
  EliminationGameModule.new,
]);
