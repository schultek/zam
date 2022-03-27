part of 'notes_module.dart';

mixin NotesSegmentsModule on ModuleBuilder {
  Map<String, ElementBuilder<ModuleElement>> get segments => {
        'notes': buildNotes,
        'note': buildNote,
        'notes_grid': buildNotesGrid,
        'notes_list': buildNotesList,
      };

  FutureOr<ContentSegment?> buildNotes(ModuleContext module) {
    return ContentSegment(
      module: module,
      builder: (context) => SimpleCard(title: context.tr.notes, icon: Icons.sticky_note_2),
      onNavigate: (context) => const NotesPage(),
    );
  }

  FutureOr<ContentSegment?> buildNote(ModuleContext module) {
    if (module.hasParams) {
      var noteOrFolder = module.getParams<String>();
      return ContentSegment(
        module: module,
        builder: (context) => Consumer(
          builder: (context, ref, _) {
            if (noteOrFolder.startsWith('%')) {
              return FolderCard(
                folder: noteOrFolder.substring(1),
                needsSurface: true,
              );
            }

            var note = ref.watch(noteProvider(noteOrFolder));
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
        settings: (context) => [
          ListTile(
            title: Text(context.tr.select_note_or_folder),
            subtitle: Text(noteOrFolder),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SelectNotePage(
                    onSelect: (id) {
                      module.updateParams(id);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      if (module.context.read(isOrganizerProvider)) {
        return ContentSegment(
          module: module,
          builder: (context) => SimpleCard(title: context.tr.single_note_tap_settings, icon: Icons.add),
          settings: (context) => [
            ListTile(
              title: Text(context.tr.select_note_or_folder),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectNotePage(
                      onSelect: (id) {
                        module.updateParams(id);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      } else {
        return null;
      }
    }
  }

  FutureOr<ContentSegment?> buildNotesGrid(ModuleContext module) async {
    var notes = await module.context.read(notesProvider.future);
    var params = module.hasParams ? module.getParams<NotesListParams>() : NotesListParams();

    if (notes.isNotEmpty) {
      return ContentSegment.grid(
        module: module,
        spacing: 20,
        builder: (context) => NotesPage.cardsBuilder(context, false, params),
        settings: (context) => NotesPage.settingsBuilder(context, module, params),
      );
    }
    return null;
  }

  FutureOr<ContentSegment?> buildNotesList(ModuleContext module) async {
    var notes = await module.context.read(notesProvider.future);
    var params = module.hasParams ? module.getParams<NotesListParams>() : NotesListParams();

    if (notes.isNotEmpty) {
      return ContentSegment(
        module: module,
        size: SegmentSize.wide,
        builder: (context) => NotesList(params: params),
        settings: (context) => NotesPage.settingsBuilder(context, module, params),
      );
    }
    return null;
  }
}

@MappableClass()
class NotesListParams {
  final bool showAdd;
  final String? folder;
  final bool showFolders;

  NotesListParams({this.showAdd = true, this.folder, this.showFolders = true});
}
