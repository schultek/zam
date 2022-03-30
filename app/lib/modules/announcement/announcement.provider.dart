part of announcement_module;

final announcementProvider = FutureProvider.family<Announcement, String>((ref, id) =>
    ref.read(moduleDocProvider('announcements')).collection('announcements').doc(id).getMapped<Announcement>());

final dismissedAnnouncementsBoxProvider = hiveBoxProvider<String>('dismissed_announcements');

final dismissedAnnouncementsProvider = dismissedAnnouncementsBoxProvider.valuesProvider();

final isDismissedProvider = FutureProvider.family((ref, String id) async {
  var dismissed = await ref.watch(dismissedAnnouncementsProvider.future);
  return dismissed.contains(id);
});

final announcementLogicProvider = Provider((ref) => AnnouncementLogic(ref));

class AnnouncementLogic {
  final Ref ref;
  AnnouncementLogic(this.ref);

  Future<String> createAnnouncement(Announcement announcement) async {
    var doc = await ref.read(moduleDocProvider('announcements')).collection('announcements').add(announcement.toMap());
    return doc.id;
  }

  Future<void> removeAnnouncement(String id) async {
    await ref.read(moduleDocProvider('announcements')).collection('announcements').doc(id).delete();
  }

  Future<void> dismiss(String id) async {
    var box = await ref.read(dismissedAnnouncementsBoxProvider.future);
    await box.add(id);
  }
}
