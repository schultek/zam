import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/models.dart';

final hiveProvider = FutureProvider((ref) => Hive.initFlutter());

FutureProvider<Box<T>> hiveBoxProvider<T>(String box) {
  return FutureProvider((ref) => ref.watch(hiveProvider.future).then((_) {
        Hive.registerAdapter(MapperAdapter<T>());
        return Hive.openBox<T>(box);
      }));
}

extension BoxProvider<T> on FutureProvider<Box<T>> {
  Provider<Iterable<T>?> valuesProvider() {
    var notifier = ChangeNotifierProvider((ref) => ValueListener<Box<T>, Iterable<T>>(
          ref.watch(this).asData?.value.listenable(),
          get: (box) => box?.values,
        ));
    return Provider((ref) => ref.watch(notifier).value);
  }
}

class MapperAdapter<T> extends TypeAdapter<T> {
  @override
  final typeId = T.toString().hashCode % 223;

  @override
  T read(BinaryReader reader) {
    return Mapper.fromMap<T>(reader.readMap().map((k, v) => MapEntry(k.toString(), v)));
  }

  @override
  void write(BinaryWriter writer, T obj) {
    writer.writeMap(Mapper.toMap(obj));
  }
}

class ValueListener<T, U> extends ChangeNotifier implements ValueListenable<U?> {
  ValueListener(this._valueListenable, {required this.get}) {
    _valueListenable?.addListener(notifyListeners);
  }

  final ValueListenable<T>? _valueListenable;
  final U? Function(T? value) get;

  @override
  U? get value => get(_valueListenable?.value);

  @override
  void dispose() {
    _valueListenable?.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  String toString() => 'ValueListener($value)';
}
