import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'announcement_create_page.dart';
import 'announcement_provider.dart';
import 'widgets/announcement_card.dart';

class AnnouncementModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return context.when(withId: (id) async {
      if (await context.context.read(isDismissedProvider(id).future)) {
        return null;
      }

      return ContentSegment(
        context: context,
        size: SegmentSize.wide,
        whenRemoved: (context) {
          context.read(announcementLogicProvider).removeAnnouncement(id);
        },
        builder: (context) => Consumer(
          builder: (context, ref, _) {
            var announcement = ref.watch(announcementProvider(id));

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
    }, withoutId: () {
      if (context.context.read(isOrganizerProvider)) {
        var idProvider = IdProvider();
        return ContentSegment(
          context: context,
          size: SegmentSize.wide,
          idProvider: idProvider,
          builder: (context) => AspectRatio(
            aspectRatio: 2.1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: context.onSurfaceHighlightColor,
                    size: 50,
                  ),
                  const SizedBox(height: 5),
                  Text('New Announcement\n(Tap to create)',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.bodyText1!.apply(color: context.onSurfaceColor)),
                ],
              ),
            ),
          ),
          onNavigate: (context) {
            return AnnouncementPage(
              parentArea: WidgetArea.of<ContentSegment>(context)!,
              onCreate: (id) => idProvider.provide(context, id),
            );
          },
        );
      } else {
        return null;
      }
    });
  }
}
