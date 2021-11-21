import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/core.dart';

extension DocumentMap on DocumentSnapshot<Map<String, dynamic>> {
  Map<String, dynamic> toMap() {
    return (data() ?? {})..addAll({'id': id});
  }
}

extension MapperDocumentReference on DocumentReference {
  DocumentReference<T> mapped<T>() {
    return withConverter<T>(
      fromFirestore: (snapshot, _) {
        var map = snapshot.toMap();
        print('GOT MAP $map for $T');
        return Mapper.fromValue(map);
      },
      toFirestore: (model, _) => Mapper.toMap(model),
    );
  }

  Future<T> getMapped<T>([GetOptions? options]) {
    return mapped<T>().get(options).then((snapshot) => snapshot.data() as T);
  }

  Stream<T> snapshotsMapped<T>({bool includeMetadataChanges = false}) {
    return mapped<T>().snapshots(includeMetadataChanges: includeMetadataChanges).map((snapshot) {
      print('SNAP ${snapshot.exists} ${snapshot.runtimeType}');
      return snapshot.data() as T;
    });
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
