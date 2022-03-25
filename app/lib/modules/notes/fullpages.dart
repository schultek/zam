part of 'notes_module.dart';

mixin NotesFullPagesModule on ModuleBuilder {
  Map<String, ElementBuilder<ModuleElement>> get fullpages => {
        'notes_list_page': buildNotesListPage,
      };

  FutureOr<PageSegment?> buildNotesListPage(ModuleContext context) async {
    var notes = await context.context.read(notesProvider.future);

    if (notes.isNotEmpty) {
      return PageSegment(
        context: context,
        builder: (context) {
          if (WidgetSelector.existsIn(context)) {
            return ThemedSurface(
              builder: (context, color) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: color,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.notes, size: MediaQuery.of(context).size.width / 2),
              ),
            );
          }
          return const NotesList(showTitle: true);
        },
      );
    }
    return null;
  }
}
