library models;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'trip.dart';

extension DocumentMap on DocumentSnapshot {
  Map<String, dynamic> toMap() {
    return (data() ?? {})..addAll({"id": id});
  }
}

String? encodeModel<T>(T? data) {
  return data != null ? JsonMapper.serialize(data) : null;
}

T decodeModel<T>(String data) {
  var decoded = JsonMapper.deserialize<T>(data);
  if (decoded == null) {
    throw Error();
  }
  return decoded;
}

T decodeMap<T>(Map<String, dynamic> data) {
  var decoded = JsonMapper.fromMap<T>(data);
  if (decoded == null) {
    throw Error();
  }
  return decoded;
}

Map<String, dynamic> encodeMap(Object object) {
  return JsonMapper.toMap(object)!;
}

T decodeDocument<T>(DocumentSnapshot doc) {
  var decoded = JsonMapper.fromMap<T>(doc.toMap());
  if (decoded == null) {
    throw Error();
  }
  return decoded;
}

extension QueryDecoder on QuerySnapshot {
  List<T> toList<T>() {
    return docs.map<T>(decodeDocument).toList();
  }
}
