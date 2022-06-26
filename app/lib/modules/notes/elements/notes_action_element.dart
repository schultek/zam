part of notes_module;

class NotesActionElement with ElementBuilder<ActionElement> {
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
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.sticky_note_2,
      text: module.context.tr.notes,
      onNavigate: (context) => const NotesPage(),
    );
  }
}
