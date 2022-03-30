part of notes_module;

class NotesActionElement with ElementBuilderMixin<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.sticky_note_2,
      text: module.context.tr.notes,
      onNavigate: (context) => const NotesPage(),
    );
  }
}
