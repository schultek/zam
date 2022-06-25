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
    module.context.listen(notesProvider, (_, __) {
      module.reload();
    });

    var notes = await module.context.read(notesProvider.future);
    var params = module.hasParams ? module.getParams<NotesListParams>() : NotesListParams();

    if (notes.isNotEmpty) {
      return ContentElement(
        module: module,
        size: ElementSize.wide,
        builder: (context) => NotesList(params: params),
        settings: DialogElementSettings(builder: NotesSettingsBuilder(module, params)),
      );
    }

    if (module.context.read(isOrganizerProvider)) {
      return ContentElement(
        module: module,
        size: ElementSize.wide,
        builder: (context) => ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 20),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              const NoteMockTile(titleWidth: 100, subtitleWidth: 200),
              const NoteMockTile(titleWidth: 80, subtitleWidth: 210),
              const NoteMockTile(titleWidth: 110, subtitleWidth: 190),
              if (params.showAdd)
                ListTile(
                  title: Text(context.tr.add),
                  leading: Icon(Icons.add, color: context.onSurfaceHighlightColor),
                  minLeadingWidth: 20,
                  onTap: () {
                    var note = context.read(notesLogicProvider).createEmptyNote(folder: params.folder);
                    Navigator.of(context).push(EditNotePage.route(note));
                  },
                ),
            ].intersperse(const Divider(height: 0)).toList(),
          ),
        ),
        settings: SetupActionElementSettings(
          hint: 'Create a first note',
          action: (context) {
            var note = context.read(notesLogicProvider).createEmptyNote(folder: params.folder);
            Navigator.of(context).push(EditNotePage.route(note));
          },
        ),
      );
    }

    return null;
  }
}

class NoteMockTile extends StatelessWidget {
  const NoteMockTile({required this.titleWidth, required this.subtitleWidth, Key? key}) : super(key: key);

  final double titleWidth;
  final double subtitleWidth;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: titleWidth,
          height: 14,
          color: context.onSurfaceColor.withOpacity(0.2),
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: subtitleWidth,
          height: 12,
          color: context.onSurfaceColor.withOpacity(0.2),
        ),
      ),
      leading: Icon(Icons.sticky_note_2_outlined, color: context.onSurfaceHighlightColor),
      minLeadingWidth: 20,
    );
  }
}
