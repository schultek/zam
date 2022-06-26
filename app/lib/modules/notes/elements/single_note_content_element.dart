part of notes_module;

class SingleNoteContentElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.note;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.note_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.note_text);
  }

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
        settings: ActionElementSettings(action: (context) async {
          var id = await Navigator.of(context).push<String>(
            MaterialPageRoute(builder: (context) => const SelectNotePage()),
          );
          if (id != null) {
            module.updateParams(id);
          }
        }),
      );
    } else {
      if (module.context.read(isOrganizerProvider)) {
        return ContentElement(
          module: module,
          builder: (context) => SimpleCard(
            title: context.tr.single_note,
            icon: Icons.note_add,
          ),
          settings: SetupActionElementSettings(
              hint: module.context.tr.select_a_note,
              action: (context) async {
                var id = await Navigator.of(context).push<String>(
                  MaterialPageRoute(builder: (context) => const SelectNotePage()),
                );
                if (id != null) {
                  module.updateParams(id);
                }
              }),
        );
      } else {
        return null;
      }
    }
  }
}
