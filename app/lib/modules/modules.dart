library modules;

import 'announcement/announcement.module.dart';
import 'chat/chat.module.dart';
import 'elimination/elimination.module.dart';
import 'labels/labels.module.dart';
import 'music/music.module.dart';
import 'notes/notes.module.dart';
import 'photos/photos.module.dart';
import 'polls/polls.module.dart';
import 'profile/profile.module.dart';
import 'split/split.module.dart';
import 'thebutton/thebutton.module.dart';
import 'users/users_module.dart';
import 'web/web_module.dart';

final registry = ModuleRegistry([
  ChatModule.new,
  MusicModule.new,
  NotesModule.new,
  UsersModule.new,
  TheButtonModule.new,
  AnnouncementModule.new,
  EliminationGameModule.new,
  ProfileModule.new,
  PhotosModule.new,
  LabelModule.new,
  PollsModule.new,
  SplitModule.new,
  WebModule.new,
]);
