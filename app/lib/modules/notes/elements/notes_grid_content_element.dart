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
    module.context.listen(notesProvider, (_, __) {
      module.reload();
    });

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

    if (module.context.read(isOrganizerProvider)) {
      return ContentElement.grid(
        module: module,
        spacing: 20,
        builder: (context) => [
          NeedsSetupCard(child: NoteMockCard(params)),
          NeedsSetupCard(child: NoteMockCard(params)),
          NeedsSetupCard(child: NoteMockCard(params)),
          if (params.showAdd)
            Opacity(
              opacity: 0.4,
              child: NoteCard(
                needsSurface: false,
                child: Center(
                  child: Builder(builder: (context) {
                    return Icon(
                      Icons.add,
                      size: 60,
                      color: context.onSurfaceHighlightColor,
                    );
                  }),
                ),
                onTap: () {
                  var note = context.read(notesLogicProvider).createEmptyNote(folder: params.folder);
                  Navigator.of(context).push(EditNotePage.route(note));
                },
              ),
            ),
        ],
        settings: NotesSettingsBuilder(module, params),
      );
    }

    return null;
  }
}

class NoteMockCard extends StatelessWidget {
  const NoteMockCard(this.params, {Key? key}) : super(key: key);

  final NotesListParams params;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var note = context.read(notesLogicProvider).createEmptyNote(folder: params.folder);
        Navigator.of(context).push(EditNotePage.route(note));
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 20,
                color: context.onSurfaceColor.withOpacity(0.2),
              ),
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 12,
                color: context.onSurfaceColor.withOpacity(0.2),
              ),
              const SizedBox(height: 4),
              Container(
                width: 120,
                height: 12,
                color: context.onSurfaceColor.withOpacity(0.2),
              ),
              const SizedBox(height: 4),
              Container(
                width: 110,
                height: 12,
                color: context.onSurfaceColor.withOpacity(0.2),
              ),
              const SizedBox(height: 4),
              Container(
                width: 90,
                height: 12,
                color: context.onSurfaceColor.withOpacity(0.2),
              ),
              const SizedBox(height: 4),
              Container(
                width: 100,
                height: 12,
                color: context.onSurfaceColor.withOpacity(0.2),
              ),
              const SizedBox(height: 4),
              Container(
                width: 130,
                height: 12,
                color: context.onSurfaceColor.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
