import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/simple_card.dart';
import 'notes_provider.dart';
import 'pages/edit_note_page.dart';
import 'pages/notes_page.dart';
import 'pages/select_note_page.dart';
import 'widgets/note_preview.dart';

class NotesModule extends ModuleBuilder<ContentSegment> {
  NotesModule() : super('notes');

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'notes': buildNotes,
        'note': buildNote,
        'notes_action': buildNotesAction,
        'add_note_action': buildAddNoteAction,
        'notes_grid': buildNotesGrid,
      };

  FutureOr<ContentSegment?> buildNotes(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => SimpleCard(title: context.tr.notes, icon: Icons.sticky_note_2),
      onNavigate: (context) => const NotesPage(),
    );
  }

  FutureOr<QuickAction?> buildNotesAction(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.sticky_note_2,
      text: context.context.tr.notes,
      onNavigate: (context) => const NotesPage(),
    );
  }

  FutureOr<QuickAction?> buildAddNoteAction(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.sticky_note_2,
      text: context.context.tr.new_note,
      onNavigate: (BuildContext context) {
        var note = context.read(notesLogicProvider).createEmptyNote();
        return EditNotePage(note);
      },
    );
  }

  FutureOr<ContentSegment?> buildNote(ModuleContext context) {
    return context.when(withId: (id) {
      return ContentSegment(
        context: context,
        builder: (context) => Consumer(
          builder: (context, ref, _) {
            if (id.startsWith('%')) {
              return FolderCard(
                folder: id.substring(1),
                needsSurface: true,
              );
            }

            var note = ref.watch(noteProvider(id));
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
                      child: EditNotePage(data),
                    ));
                  },
                  child: AbsorbPointer(child: NotePreview(note: data)),
                );
              },
              loading: () => const LoadingShimmer(),
              error: (e, st) => Center(child: Text('${context.tr.error} $e')),
            );
          },
        ),
      );
    }, withoutId: () {
      if (context.context.read(isOrganizerProvider)) {
        var idProvider = IdProvider();
        return ContentSegment(
          context: context,
          idProvider: idProvider,
          builder: (context) => SimpleCard(title: context.tr.add_note, icon: Icons.add),
          onNavigate: (context) {
            return SelectNotePage(
              onSelect: (id) => idProvider.provide(context, id),
            );
          },
        );
      } else {
        return null;
      }
    });
  }

  FutureOr<ContentSegment?> buildNotesGrid(ModuleContext context) async {
    var notes = await context.context.read(notesProvider.future);

    if (notes.isNotEmpty) {
      return ContentSegment.grid(
        context: context,
        builder: NotesPage.cardsBuilder,
        spacing: 20,
      );
    }
  }
}
