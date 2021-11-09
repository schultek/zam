import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/areas/areas.dart';
import '../../core/elements/elements.dart';
import '../../core/module/module.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'announcement_create_page.dart';
import 'announcement_provider.dart';
import 'widgets/announcement_card.dart';

@Module('announcement')
class AnnouncementModule {
  @ModuleItem('announcement')
  ContentSegment? getAnnouncement(BuildContext context, String? id) {
    if (id == null) {
      if (context.read(isOrganizerProvider)) {
        var idProvider = IdProvider();
        return ContentSegment(
          size: SegmentSize.wide,
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
                    'New Announcement\n(Tap to create)',
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

    if (context.read(isDismissedProvider(id)) ?? false) {
      return null;
    }

    return ContentSegment(
      size: SegmentSize.wide,
      whenRemoved: (context) {
        context.read(announcementLogicProvider).removeAnnouncement(id);
      },
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          var announcement = ref.watch(announcementProvider(id));
          var isDismissed = ref.watch(isDismissedProvider(id));

          if (isDismissed ?? true) {
            if (isDismissed != null) {
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                WidgetArea.of<ContentSegment>(context)?.reload();
              });
            }
            return Container();
          }

          return AnnouncementCard(
            announcement: announcement,
            onDismissed: !context.read(isOrganizerProvider)
                ? () {
                    context.read(announcementLogicProvider).dismiss(id);
                    WidgetArea.of<ContentSegment>(context)?.reload();
                  }
                : null,
          );
        },
      ),
    );
  }
}
