import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jufa/providers/auth/user_provider.dart';

import '../../models/models.dart';
import '../../providers/firebase/doc_provider.dart';

export '../../main.mapper.g.dart' show NoteMapperExtension;

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

final notesProvider = StreamProvider(
    (ref) => ref.watch(moduleDocProvider('notes')).collection("notes").snapshots().map((s) => s.toList<Note>()));

final noteProvider = Provider.family(
    (ref, String id) => ref.watch(notesProvider).whenData((value) => value.where((n) => n.id == id).firstOrNull));

final foldersProvider = Provider((ref) =>
    ref
        .watch(notesProvider)
        .data
        ?.value
        .fold<Set<String>>({}, (folders, note) => {...folders, if (note.folder != null) note.folder!}).toList() ??
    []);

final notesLogicProvider = Provider((ref) => NotesLogic(ref));

class NotesLogic {
  final ProviderReference ref;
  final DocumentReference doc;
  NotesLogic(this.ref) : doc = ref.watch(moduleDocProvider('notes'));

  Future<Note> createEmptyNote() async {
    var note = doc.collection("notes").doc();
    var author = ref.read(userIdProvider)!;
    return Note(note.id, null, [], author: author, editors: [author]);
  }

  Future<void> updateNote(String id, Note note) async {
    await doc.collection("notes").doc(id).set(note.toMap(), SetOptions(merge: true));
  }

  Future<void> setEditors(String id, List<String> editors) async {
    await doc.collection("notes").doc(id).update({
      "editors": editors,
    });
  }

  Future<void> deleteNote(String id) {
    return doc.collection("notes").doc(id).delete();
  }

  Future<void> changeFolder(String id, String? folder) async {
    await doc.collection("notes").doc(id).update({
      "folder": folder,
    });
  }
}
