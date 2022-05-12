import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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
        try {
          return Mapper.fromValue(map);
        } catch (e, st) {
          FirebaseCrashlytics.instance.recordError(e, st);
          rethrow;
        }
      },
      toFirestore: (model, _) {
        Mapper.use(TimestampMapper());
        var encoded = Mapper.toMap(model)..remove('id');
        Mapper.unuse<Timestamp>();
        return encoded;
      },
    );
  }

  Future<T> getMapped<T>([GetOptions? options]) {
    return mapped<T>().get(options).then((snapshot) => snapshot.data() as T);
  }

  Stream<T> snapshotsMapped<T>({bool includeMetadataChanges = false}) {
    return mapped<T>().snapshots(includeMetadataChanges: includeMetadataChanges).map((snapshot) {
      return snapshot.data() as T;
    });
  }
}

class TimestampMapper extends SimpleMapper<Timestamp> {
  @override
  Timestamp decode(value) => value as Timestamp;

  @override
  encode(Timestamp self) => self;
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
