library models;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../core/templates/templates.dart';
import '../main.mapper.g.dart';

export '../main.mapper.g.dart';

part 'trip.dart';

extension DocumentMap on DocumentSnapshot<Map<String, dynamic>> {
  Map<String, dynamic> toMap() {
    return (data() ?? {})..addAll({'id': id});
  }
}

extension MapperDocumentReference on DocumentReference {
  DocumentReference<T> mapped<T>() {
    return withConverter<T>(
      fromFirestore: (snapshot, _) => Mapper.fromValue(snapshot.toMap()),
      toFirestore: (model, _) => Mapper.toMap(model),
    );
  }

  Future<T> getMapped<T>([GetOptions? options]) {
    return mapped<T>().get(options).then((snapshot) => snapshot.data() as T);
  }

  Stream<T> snapshotsMapped<T>({bool includeMetadataChanges = false}) {
    return mapped<T>()
        .snapshots(includeMetadataChanges: includeMetadataChanges)
        .map((snapshot) => snapshot.data() as T);
  }
}

extension MapperCollectionRef on CollectionReference {
  CollectionReference<T> mapped<T>() {
    return withConverter<T>(
      fromFirestore: (snapshot, _) => Mapper.fromValue(snapshot.toMap()),
      toFirestore: (model, _) => Mapper.toMap(model),
    );
  }

  Stream<List<T>> snapshotsMapped<T>({bool includeMetadataChanges = false}) {
    return mapped<T>()
        .snapshots(includeMetadataChanges: includeMetadataChanges)
        .map((snapshot) => snapshot.docs.map((s) => s.data()).toList());
  }
}

extension MapperQuery on Query {
  Query<T> mapped<T>() {
    return withConverter<T>(
      fromFirestore: (snapshot, _) => Mapper.fromValue(snapshot.toMap()),
      toFirestore: (model, _) => Mapper.toMap(model),
    );
  }

  Stream<List<T>> snapshotsMapped<T>({bool includeMetadataChanges = false}) {
    return mapped<T>()
        .snapshots(includeMetadataChanges: includeMetadataChanges)
        .map((snapshot) => snapshot.docs.map((s) => s.data()).toList());
  }
}
