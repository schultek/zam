library models;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/templates/templates.dart';
import '../main.mapper.g.dart';

export '../main.mapper.g.dart';

part 'trip.dart';

extension DocumentMap on DocumentSnapshot {
  Map<String, dynamic> toMap() {
    return (data() ?? {})..addAll({"id": id});
  }
}

T decodeDocument<T>(DocumentSnapshot doc) {
  return Mapper.fromMap<T>(doc.toMap());
}

extension QueryDecoder on QuerySnapshot {
  List<T> toList<T>() {
    return docs.map<T>(decodeDocument).toList();
  }
}
