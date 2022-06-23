part of notes_module;

class NotesContentElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.notes;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.notes_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.notes_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => SimpleCard(title: context.tr.notes, icon: Icons.sticky_note_2),
      onNavigate: (context) => const NotesPage(),
    );
  }
}
