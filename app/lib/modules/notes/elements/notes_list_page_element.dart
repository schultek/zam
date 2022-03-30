part of notes_module;

class NotesListPageElement with ElementBuilderMixin<PageElement> {
  @override
  FutureOr<PageElement?> build(ModuleContext module) async {
    var notes = await module.context.read(notesProvider.future);
    var params = module.hasParams ? module.getParams<NotesListParams>() : NotesListParams();

    if (notes.isNotEmpty) {
      return PageElement(
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
        settings: NotesSettingsBuilder(module, params),
      );
    }
    return null;
  }
}
