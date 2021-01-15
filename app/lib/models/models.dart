library models;

import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../service/auth_service.dart';

part 'trip.dart';

extension MapModel<K, V> on Map<K, V> {
  T get<T>(K key) {
    if (this[key] == null) {
      print("Model map does not have key $key: $this at");
      print(StackTrace.current.toString().split("\n").sublist(1, 3).join("\n"));
    }
    return remove(key)! as T;
  }

  T? getOpt<T, U>(K key, {T Function(U v)? map}) {
    V? v = remove(key);
    return v != null && map != null ? map(v as U) : v as T?;
  }

  Map<T, U> getMap<T, U, W>(K key, {U Function(W v)? map, Map<T, U> or = const {}}) {
    Map? v = remove(key) as Map?;
    return v?.map((key, value) => MapEntry(key as T, map != null ? map(value as W) : value as U)) ?? or;
  }

  List<T> getList<T, U>(K key, {T Function(U v)? map, List<T> or = const []}) {
    List? v = remove(key) as List?;
    return v?.map((e) => map != null ? map(e as U) : e as T).toList() ?? or;
  }

  T? getEnum<T extends Object>(K key, List<T> values) {
    String? v = this[key] is String ? remove(key) as String : null;
    int index = values.indexWhere((e) => describeEnum(e).toLowerCase() == v?.toLowerCase());
    if (index == -1) {
      print("Enum does not contain value $v for key $key. Available values are: $values");
      print(StackTrace.current.toString().split("\n").sublist(1, 3).join("\n"));
    }
    return index >= 0 ? values[index] : null;
  }

  bool assertEmpty({int max = 0}) {
    if (length > max) {
      print("Model map contains fields after constructor: $this at");
      print(StackTrace.current.toString().split("\n").sublist(1, 3).join("\n"));
    }
    return true;
  }

  bool ignore(K key) {
    remove(key);
    return true;
  }

  String encodeJson() {
    return jsonEncode(this);
  }
}

extension DocumentMap on DocumentSnapshot {
  Map<String, dynamic> toMap() {
    return data()..addAll({"id": id});
  }
}
