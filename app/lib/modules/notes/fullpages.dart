part of 'notes_module.dart';

mixin NotesFullPagesModule on ModuleBuilder {
  Map<String, ElementBuilder<ModuleElement>> get fullpages => {
        'notes_list_page': buildNotesListPage,
      };

  FutureOr<PageSegment?> buildNotesListPage(ModuleContext module) async {
    var notes = await module.context.read(notesProvider.future);
    var params = module.hasParams ? module.getParams<NotesListParams>() : NotesListParams();

    if (notes.isNotEmpty) {
      return PageSegment(
        module: module,
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
          return NotesList(showTitle: true, params: params);
        },
        settings: (context) => NotesPage.settingsBuilder(context, module, params),
      );
    }
    return null;
  }
}
