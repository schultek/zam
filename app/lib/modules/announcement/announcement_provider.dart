import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../providers/firebase/doc_provider.dart';
import '../../providers/hive/hive_provider.dart';

export '../../main.mapper.g.dart' show AnnouncementMapperExtension;

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
    print('DISMISS $id');
    await box.add(id);
  }
}

@MappableClass()
class Announcement {
  final String? title;
  final String message;
  final Color? textColor;
  final Color? backgroundColor;
  final bool isDismissible;

  Announcement({this.title, required this.message, this.textColor, this.backgroundColor, this.isDismissible = false});
}

@CustomMapper()
class ColorMapper extends SimpleMapper<Color> {
  @override
  Color decode(dynamic value) {
    return Color(int.parse('ff${value.substring(1)}', radix: 16));
  }

  @override
  dynamic encode(Color self) {
    return "#${(self.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}";
  }
}
