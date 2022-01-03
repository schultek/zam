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

final registry = ModuleRegistry({
  'chat': ChatModule(),
  'chat2': ChatActionModule(),
  'music': MusicModule(),
  'notes': NotesModule(),
  'note': NoteModule(),
  'addnote': AddNoteActionModule(),
  'notes2': NotesActionModule(),
  'notes_grid': NotesGridModule(),
  'users': UsersModule(),
  'users2': UsersActionModule(),
  'thebutton': TheButtonModule(),
  'announcement': AnnouncementModule(),
  'elimination': EliminationGameModule(),
  'elimination_games': EliminationGamesModule(),
  'elimination_games_list': EliminationGamesListModule(),
  'elimination_new_game': EliminationNewGameActionModule(),
  'elimination_games_action': EliminationGamesActionModule(),
  'profile': ProfileModule(),
  'profile2': ProfileActionModule(),
  'profile3': ProfileImageModule(),
  'photos': PhotosModule(),
  'label': LabelModule(),
  'poll': PollModule(),
  'polls': PollsModule(),
  'new_poll': NewPollActionModule(),
  'polls_list': PollsListModule(),
});
