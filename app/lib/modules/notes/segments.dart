part of 'notes_module.dart';

mixin NotesSegmentsModule on ModuleBuilder {
  Map<String, ElementBuilder<ModuleElement>> get segments => {
        'notes': buildNotes,
        'note': buildNote,
        'notes_grid': buildNotesGrid,
        'notes_list': buildNotesList,
      };

  FutureOr<ContentSegment?> buildNotes(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => SimpleCard(title: context.tr.notes, icon: Icons.sticky_note_2),
      onNavigate: (context) => const NotesPage(),
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
    return null;
  }

  FutureOr<ContentSegment?> buildNotesList(ModuleContext context) async {
    var notes = await context.context.read(notesProvider.future);

    if (notes.isNotEmpty) {
      return ContentSegment(
        context: context,
        size: SegmentSize.wide,
        builder: (context) => const NotesList(),
      );
    }
    return null;
  }
}
