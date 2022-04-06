part of announcement_module;

final announcementProvider = FutureProvider.family<Announcement, String>((ref, id) =>
    ref.read(moduleDocProvider('announcements')).collection('announcements').doc(id).getMapped<Announcement>());

final dismissedAnnouncementsBoxProvider = hiveBoxProvider<String>('dismissed_announcements');

final dismissedAnnouncementsProvider = dismissedAnnouncementsBoxProvider.valuesProvider();

final isDismissedProvider = FutureProvider.family((ref, String id) async {
  var dismissed = await ref.watch(dismissedAnnouncementsProvider.future);
  return dismissed.contains(id);
});

final announcementApiProvider = Provider((ref) => ref.watch(apiProvider).announcement);
final announcementLogicProvider = Provider((ref) => AnnouncementLogic(ref));

class AnnouncementLogic {
  final Ref ref;
  AnnouncementLogic(this.ref);

  Future<String> createAnnouncement(Announcement announcement) async {
    var doc = await ref.read(moduleDocProvider('announcements')).collection('announcements').add(announcement.toMap());
    await sendNotification(doc.id, announcement);
    return doc.id;
  }

  Future<void> resendNotification(String id) async {
    var announcement = await ref.read(announcementProvider(id).future);
    await sendNotification(id, announcement);
  }

  Future<void> sendNotification(String id, Announcement announcement) async {
    await ref.read(announcementApiProvider).sendNotification(
        AnnouncementNotification(ref.read(selectedGroupIdProvider)!, id, announcement.title, announcement.message));
  }

  Future<void> removeAnnouncement(String id) async {
    await ref.read(moduleDocProvider('announcements')).collection('announcements').doc(id).delete();
  }

  Future<void> dismiss(String id) async {
    var box = await ref.read(dismissedAnnouncementsBoxProvider.future);
    await box.add(id);
  }
}
