library modules;

import '../core/core.dart';
import 'announcement/announcement_module.dart';
import 'chat/chat_module.dart';
import 'elimination/elimination_module.dart';
import 'labels/labels_module.dart';
import 'music/music_module.dart';
import 'notes/notes_module.dart';
import 'photos/photos_module.dart';
import 'polls/polls_module.dart';
import 'profile/profile_module.dart';
import 'thebutton/thebutton_module.dart';
import 'users/users_module.dart';

final registry = ModuleRegistry([
  ChatModule(),
  MusicModule(),
  NotesModule(),
  UsersModule(),
  TheButtonModule(),
  AnnouncementModule(),
  EliminationGameModule(),
  ProfileModule(),
  PhotosModule(),
  LabelModule(),
  PollsModule(),
]);
