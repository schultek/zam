part of notes_module;

class AddNoteActionElement with ElementBuilderMixin<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.sticky_note_2,
      text: module.context.tr.new_note,
      onNavigate: (BuildContext context) {
        var note = context.read(notesLogicProvider).createEmptyNote();
        return EditNotePage(note);
      },
    );
  }
}
