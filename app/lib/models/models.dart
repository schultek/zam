library models;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../core/templates/templates.dart';
import '../main.mapper.g.dart';

export '../main.mapper.g.dart';

part 'trip.dart';

extension DocumentMap on DocumentSnapshot {
  Map<String, dynamic> toMap() {
    return (data() ?? {})..addAll({"id": id});
  }

  T decode<T>() => Mapper.fromMap<T>(toMap());
}

extension QueryDecoder on QuerySnapshot {
  List<T> toList<T>() {
    return docs.map((d) => d.decode<T>()).toList();
  }
}
