part of notes_module;

class AddNoteActionElement with ElementBuilder<ActionElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.add_note_action;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.add_note_action_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.add_note_action_text);
  }

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
