import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../providers/firebase/doc_provider.dart';

export '../../main.mapper.g.dart' show AnnouncementMapperExtension;

final announcementProvider = FutureProvider.family<Announcement, String>((ref, id) => ref
    .read(moduleDocProvider('announcements'))
    .collection('announcements')
    .doc(id)
    .get()
    .then((d) => d.decode<Announcement>()));

final announcementLogicProvider = Provider((ref) => AnnouncementLogic(ref));

class AnnouncementLogic {
  final ProviderReference ref;
  AnnouncementLogic(this.ref);

  Future<String> createAnnouncement(Announcement announcement) async {
    var doc = await ref.read(moduleDocProvider('announcements')).collection('announcements').add(announcement.toMap());
    return doc.id;
  }
}

@MappableClass()
class Announcement {
  final String message;

  Announcement(this.message);
}
