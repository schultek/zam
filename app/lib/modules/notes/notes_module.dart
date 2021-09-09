import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/areas/areas.dart';
import '../../core/module/module.dart';
import '../../core/route/route.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../../widgets/loading_shimmer.dart';
import 'notes_provider.dart';
import 'pages/edit_note_page.dart';
import 'pages/notes_page.dart';
import 'pages/select_note_page.dart';
import 'widgets/note_preview.dart';

@Module('notes')
class NotesModule {
  @ModuleItem('notes')
  ContentSegment getNotes() {
    return ContentSegment(
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sticky_note_2,
                color: context.getTextColor(),
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.headline6!.copyWith(color: context.getTextColor()),
              ),
            ],
          ),
        ),
      ),
      onNavigate: (context) => const NotesPage(),
    );
  }

  @ModuleItem('note')
  ContentSegment? getNote(BuildContext context, String? id) {
    if (id == null) {
      if (context.read(isOrganizerProvider)) {
        var idProvider = IdProvider();
        return ContentSegment(
          idProvider: idProvider,
          builder: (context) => Padding(
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
                  'Add Note\n(Tap to select)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          onNavigate: (context) {
            return SelectNotePage(
              onSelect: (id) => idProvider.provide(context, id),
            );
          },
        );
      } else {
        return null;
      }
    }

    return ContentSegment(
      builder: (context) => Consumer(
        builder: (context, watch, _) {
          var note = watch(noteProvider(id));
          return note.when(
            data: (data) {
              if (data == null) {
                return const Center(
                  child: Icon(Icons.note),
                );
              }
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(ModulePageRoute(
                    context,
                    child: EditNotePage(data, area: WidgetArea.of<ContentSegment>(context)),
                  ));
                },
                child: AbsorbPointer(child: NotePreview(note: data)),
              );
            },
            loading: () => const LoadingShimmer(),
            error: (e, st) => Center(child: Text('Error $e')),
          );
        },
      ),
    );
  }
}
