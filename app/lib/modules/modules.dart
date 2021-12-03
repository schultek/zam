library modules;

import '../core/core.dart';
import 'announcement/announcement_module.dart';
import 'chat/chat_module.dart';
import 'elimination/elimination_module.dart';
import 'music/music_module.dart';
import 'notes/notes_module.dart';
import 'photos/photos_module.dart';
import 'profile/profile_module.dart';
import 'thebutton/thebutton_module.dart';
import 'users/users_module.dart';

final registry = ModuleRegistry({
  'chat': ChatModule(),
  'music': MusicModule(),
  'notes': NotesModule(),
  'note': NoteModule(),
  'addnote': AddNoteActionModule(),
  'notes2': NotesActionModule(),
  'users': UsersModule(),
  'users2': UsersActionModule(),
  'thebutton': TheButtonModule(),
  'announcement': AnnouncementModule(),
  'elimination': EliminationGameModule(),
  'elimination_games': EliminationGamesModule(),
  'profile': ProfileModule(),
  'profile2': ProfileActionModule(),
  'photos': PhotosModule(),
});
