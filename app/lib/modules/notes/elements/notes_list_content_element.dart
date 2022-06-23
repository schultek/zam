part of notes_module;

class NotesListContentElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.notes_list;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.notes_list_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.notes_list_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    var notes = await module.context.read(notesProvider.future);
    var params = module.hasParams ? module.getParams<NotesListParams>() : NotesListParams();

    if (notes.isNotEmpty) {
      return ContentElement(
        module: module,
        size: ElementSize.wide,
        builder: (context) => NotesList(params: params),
        settings: NotesSettingsBuilder(module, params),
      );
    }
    return null;
  }
}
