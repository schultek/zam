import 'module.super.dart';
import 'module.dart';

final registry = ModuleRegistry({
  'TheButtonModule': ModuleInstance<TheButtonModule>(TheButtonModule(), {
    'getButtonCard': ModuleFactory<TheButtonModule, ContentSegment>(
        (c, m, id) => m.getButtonCard())
  }),
  'ProfileModule': ModuleInstance<ProfileModule>(ProfileModule(), {
    'getProfileCard': ModuleFactory<ProfileModule, ContentSegment>(
        (c, m, id) => m.getProfileCard())
  }),
  'ChatModule': ModuleInstance<ChatModule>(ChatModule(), {
    'getChatPage':
        ModuleFactory<ChatModule, PageSegment>((c, m, id) => m.getChatPage())
  }),
  'WelcomeModule': ModuleInstance<WelcomeModule>(WelcomeModule(), {
    'getAction1':
        ModuleFactory<WelcomeModule, QuickAction>((c, m, id) => m.getAction1()),
    'getWelcomeBanner': ModuleFactory<WelcomeModule, ContentSegment>(
        (c, m, id) => m.getWelcomeBanner(id))
  }),
  'AnnouncementModule':
      ModuleInstance<AnnouncementModule>(AnnouncementModule(), {
    'getAnnouncement': ModuleFactory<AnnouncementModule, ContentSegment>(
        (c, m, id) => m.getAnnouncement(c, id))
  }),
  'NotesModule': ModuleInstance<NotesModule>(NotesModule(), {
    'getNotes':
        ModuleFactory<NotesModule, ContentSegment>((c, m, id) => m.getNotes()),
    'getNote': ModuleFactory<NotesModule, ContentSegment>(
        (c, m, id) => m.getNote(c, id))
  }),
  'UsersModule': ModuleInstance<UsersModule>(UsersModule(), {
    'getUsers':
        ModuleFactory<UsersModule, ContentSegment>((c, m, id) => m.getUsers())
  })
});
