import 'module.super.dart';
import 'module.dart';

final registry = ModuleRegistry({
  'TheButtonModule': ModuleInstance<TheButtonModule>(TheButtonModule(),
      {'thebutton': ModuleFactory<TheButtonModule, ContentSegment>((c, m, id) => m.getButtonCard())}),
  'ProfileModule': ModuleInstance<ProfileModule>(
      ProfileModule(), {'profile': ModuleFactory<ProfileModule, ContentSegment>((c, m, id) => m.getProfileCard())}),
  'ChatModule': ModuleInstance<ChatModule>(
      ChatModule(), {'chat': ModuleFactory<ChatModule, PageSegment>((c, m, id) => m.getChatPage())}),
  'CameraModule': ModuleInstance<CameraModule>(
      CameraModule(), {'camera': ModuleFactory<CameraModule, PageSegment>((c, m, id) => m.getCameraPage())}),
  'EliminationModule': ModuleInstance<EliminationModule>(
      EliminationModule(), {'game': ModuleFactory<EliminationModule, ContentSegment>((c, m, id) => m.getGame(c, id))}),
  'PollsModule': ModuleInstance<PollsModule>(
      PollsModule(), {'poll': ModuleFactory<PollsModule, ContentSegment>((c, m, id) => m.getPoll(c, id))}),
  'WelcomeModule': ModuleInstance<WelcomeModule>(WelcomeModule(), {
    'action1': ModuleFactory<WelcomeModule, QuickAction>((c, m, id) => m.getAction1()),
    'welcome': ModuleFactory<WelcomeModule, ContentSegment>((c, m, id) => m.getWelcomeBanner(id))
  }),
  'AnnouncementModule': ModuleInstance<AnnouncementModule>(AnnouncementModule(),
      {'announcement': ModuleFactory<AnnouncementModule, ContentSegment>((c, m, id) => m.getAnnouncement(c, id))}),
  'UsersModule': ModuleInstance<UsersModule>(
      UsersModule(), {'users': ModuleFactory<UsersModule, ContentSegment>((c, m, id) => m.getUsers())}),
  'MusicModule': ModuleInstance<MusicModule>(
      MusicModule(), {'player': ModuleFactory<MusicModule, ContentSegment>((c, m, id) => m.getPlayer(c, id))}),
  'NotesModule': ModuleInstance<NotesModule>(NotesModule(), {
    'notes': ModuleFactory<NotesModule, ContentSegment>((c, m, id) => m.getNotes()),
    'note': ModuleFactory<NotesModule, ContentSegment>((c, m, id) => m.getNote(c, id))
  })
});
