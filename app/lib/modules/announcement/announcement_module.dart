import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/elements/elements.dart';
import '../../core/module/module.dart';
import '../../providers/firebase/doc_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'announcement_create_page.dart';

final announcementProvider = FutureProvider.family((ref, String id) =>
    ref.read(moduleDocProvider("announcements")).collection("announcements").doc(id).get().then((d) => d.data()));

@Module()
class AnnouncementModule {
  @ModuleItem(id: "announcement")
  ContentSegment? getAnnouncement(BuildContext context, String? id) {
    if (id == null) {
      if (context.read(isOrganizerProvider)) {
        var idProvider = IdProvider();
        return ContentSegment(
          size: SegmentSize.Wide,
          idProvider: idProvider,
          builder: (context) => AspectRatio(
            aspectRatio: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: context.getTextColor(),
                    size: 50,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "New Announcement\n(Tap to create)",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          onNavigate: (context) {
            return AnnouncementPage(
              onCreate: (id) => idProvider.provide(context, id),
            );
          },
        );
      } else {
        return null;
      }
    }
    return ContentSegment(
      size: SegmentSize.Wide,
      whenRemoved: (context) {
        removeAnnouncement(context, id);
      },
      builder: (context) => AspectRatio(
        aspectRatio: 2,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Consumer(
              builder: (context, watch, _) {
                var announcement = watch(announcementProvider(id));
                return announcement.when(
                  data: (data) => AutoSizeText(
                    (data?["message"] as String?) ?? "No Message",
                    style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                    maxLines: 5,
                    stepGranularity: 10,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text("Error $e"),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> loadAnnouncement(BuildContext context, String id) async {
    var doc = await context.read(moduleDocProvider("announcements")).collection("announcements").doc(id).get();
    return doc.data();
  }

  Future<void> removeAnnouncement(BuildContext context, String id) async {
    await context.read(moduleDocProvider("announcements")).collection("announcements").doc(id).delete();
  }
}
