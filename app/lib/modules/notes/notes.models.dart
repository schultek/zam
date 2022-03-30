part of notes_module;

@MappableClass()
class NotesListParams {
  final bool showAdd;
  final String? folder;
  final bool showFolders;

  NotesListParams({this.showAdd = true, this.folder, this.showFolders = true});
}

@MappableClass()
class Note {
  final String id;
  final String? title;
  final List<dynamic> content;
  final String? folder;
  final bool isArchived;
  final String author;
  final List<String> editors;

  Note(
    this.id,
    this.title,
    this.content, {
    this.folder,
    this.isArchived = false,
    required this.author,
    this.editors = const [],
  });
}
