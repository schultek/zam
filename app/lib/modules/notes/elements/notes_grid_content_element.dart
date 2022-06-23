part of notes_module;

class NotesGridContentElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.notes_grid;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.notes_grid_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.notes_grid_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    var notes = await module.context.read(notesProvider.future);
    var params = module.hasParams ? module.getParams<NotesListParams>() : NotesListParams();

    if (notes.isNotEmpty) {
      return ContentElement.grid(
        module: module,
        spacing: 20,
        builder: NotesCardsBuilder(false, params),
        settings: NotesSettingsBuilder(module, params),
      );
    }
    return null;
  }
}
