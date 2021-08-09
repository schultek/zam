import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../providers/firebase/doc_provider.dart';

@MappableClass()
class Note {
  String id;
  String title;
  String content;

  Note(this.id, this.title, this.content);
}

final notesProvider = StreamProvider(
    (ref) => ref.watch(moduleDocProvider('notes')).collection("notes").snapshots().map((s) => s.toList<Note>()));

final noteProvider = Provider.family((ref, String id) => ref.watch(notesProvider).when(
      data: (data) => data.where((n) => n.id == id).firstOrNull,
      loading: () => null,
      error: (_, __) => null,
    ));

final notesLogicProvider = Provider((ref) => NotesLogic(ref));

class NotesLogic {
  final ProviderReference ref;
  final DocumentReference doc;
  NotesLogic(this.ref) : doc = ref.watch(moduleDocProvider('notes'));

  Future<Note> createEmptyNote() async {
    var note = await doc.collection("notes").add({"content": "", "title": ""});
    return Note(note.id, "", "");
  }

  Future<void> updateNote(String id, {required String title, required String content}) async {
    await doc.collection("notes").doc(id).update({
      "title": title,
      "content": content,
    });
  }
}
