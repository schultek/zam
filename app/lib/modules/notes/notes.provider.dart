part of notes_module;

final notesProvider =
    StreamProvider((ref) => ref.watch(moduleDocProvider('notes')).collection('notes').snapshotsMapped<Note>());

final noteProvider = Provider.family(
    (ref, String id) => ref.watch(notesProvider).whenData((value) => value.where((n) => n.id == id).firstOrNull));

final foldersProvider = Provider((ref) =>
    ref
        .watch(notesProvider)
        .asData
        ?.value
        .fold<Set<String?>>({null}, (folders, note) => {...folders, note.folder}).toList() ??
    []);

final notesLogicProvider = Provider((ref) => NotesLogic(ref));

class NotesLogic {
  final Ref ref;
  final DocumentReference doc;
  NotesLogic(this.ref) : doc = ref.watch(moduleDocProvider('notes'));

  Note createEmptyNote({String? folder}) {
    var note = doc.collection('notes').doc();
    var author = ref.read(userIdProvider)!;
    return Note(note.id, null, [], folder: folder, author: author, editors: [author]);
  }

  Future<void> updateNote(String id, Note note) async {
    await doc.collection('notes').doc(id).set(note.toMap(), SetOptions(merge: true));
  }

  Future<void> setEditors(String id, List<String> editors) async {
    await doc.collection('notes').doc(id).update({
      'editors': editors,
    });
  }

  Future<void> deleteNote(String id) {
    return doc.collection('notes').doc(id).delete();
  }

  Future<void> changeFolder(String id, String? folder) async {
    await doc.collection('notes').doc(id).update({
      'folder': folder,
    });
  }

  Future<String?> uploadFile(String noteId, File file) async {
    var fileName = Uri.parse(file.path).pathSegments.last;
    return ref
        .read(groupsLogicProvider) //
        .uploadFile('notes/$noteId/$fileName', await file.readAsBytes());
  }
}
