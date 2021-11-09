import 'module.dart';
import 'module.dart';

final registry = ModuleRegistry({
  'notes': ModuleInstance<NotesModule>(NotesModule(), {
    'notes': ModuleFactory<NotesModule, ContentSegment>((c, m, id) => m.getNotes()),
    'note': ModuleFactory<NotesModule, ContentSegment>((c, m, id) => m.getNote(c, id))
  }),
  'thebutton': ModuleInstance<TheButtonModule>(TheButtonModule(),
      {'thebutton': ModuleFactory<TheButtonModule, ContentSegment>((c, m, id) => m.getButtonCard())}),
  'announcement': ModuleInstance<AnnouncementModule>(AnnouncementModule(),
      {'announcement': ModuleFactory<AnnouncementModule, ContentSegment>((c, m, id) => m.getAnnouncement(c, id))}),
  'music': ModuleInstance<MusicModule>(
      MusicModule(), {'player': ModuleFactory<MusicModule, ContentSegment>((c, m, id) => m.getPlayer(c, id))}),
  'users': ModuleInstance<UsersModule>(
      UsersModule(), {'users': ModuleFactory<UsersModule, ContentSegment>((c, m, id) => m.getUsers())}),
  'camera': ModuleInstance<CameraModule>(
      CameraModule(), {'camera': ModuleFactory<CameraModule, PageSegment>((c, m, id) => m.getCameraPage())}),
  'chat': ModuleInstance<ChatModule>(
      ChatModule(), {'chat': ModuleFactory<ChatModule, PageSegment>((c, m, id) => m.getChatPage(c))}),
  'profile': ModuleInstance<ProfileModule>(
      ProfileModule(), {'profile': ModuleFactory<ProfileModule, ContentSegment>((c, m, id) => m.getProfileCard())}),
  'elimination': ModuleInstance<EliminationModule>(
      EliminationModule(), {'game': ModuleFactory<EliminationModule, ContentSegment>((c, m, id) => m.getGame(c, id))})
});
