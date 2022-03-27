part of 'notes_module.dart';

mixin NotesActionsModule on ModuleBuilder {
  Map<String, ElementBuilder<ModuleElement>> get actions => {
        'notes_action': buildNotesAction,
        'add_note_action': buildAddNoteAction,
      };

  FutureOr<QuickAction?> buildNotesAction(ModuleContext module) {
    return QuickAction(
      module: module,
      icon: Icons.sticky_note_2,
      text: module.context.tr.notes,
      onNavigate: (context) => const NotesPage(),
    );
  }

  FutureOr<QuickAction?> buildAddNoteAction(ModuleContext module) {
    return QuickAction(
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
