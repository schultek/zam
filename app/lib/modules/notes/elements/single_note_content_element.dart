part of notes_module;

class SingleNoteContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    if (module.hasParams) {
      var noteOrFolder = module.getParams<String>();
      var isFolder = noteOrFolder.startsWith('%');
      return ContentElement(
        module: module,
        builder: (context) => Consumer(
          builder: (context, ref, _) {
            if (isFolder) {
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
          Builder(builder: (context) {
            String noteName;
            if (isFolder) {
              noteName = noteOrFolder.substring(1);
              context.prime();
            } else {
              noteName = context.watch(noteProvider(noteOrFolder)).value?.title ?? context.tr.untitled_note;
            }
            return ListTile(
              title: Text(context.tr.select_note_or_folder),
              subtitle: Text(noteName),
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
            );
          }),
        ],
      );
    } else {
      if (module.context.read(isOrganizerProvider)) {
        return ContentElement(
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
}
