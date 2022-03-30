part of notes_module;

class NotesContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    return ContentElement(
      module: module,
      builder: (context) => SimpleCard(title: context.tr.notes, icon: Icons.sticky_note_2),
      onNavigate: (context) => const NotesPage(),
    );
  }
}
