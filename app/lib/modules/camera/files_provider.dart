import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image/image.dart' as img;

import '../../models/models.dart';

final hiveProvider = FutureProvider((ref) => Hive.initFlutter().then<void>((_) {
      Hive.registerAdapter(MapperAdapter<PhotoItem>());
    }));

final filesBoxProvider =
    FutureProvider((ref) => ref.watch(hiveProvider.future).then((_) => Hive.openBox<PhotoItem>('photos3')));

final filesProvider =
    ChangeNotifierProvider((ref) => ValueListener(ref.watch(filesBoxProvider).data?.value.listenable()));

final orderedFilesProvider = Provider((ref) =>
    (ref.watch(filesProvider).value?.values ?? []).toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt) * -1));

final lastPictureProvider = Provider<PhotoItem?>((ref) => ref.watch(orderedFilesProvider).firstOrNull);

final filesLogicProvider = Provider((ref) => FilesLogic(ref));

class FilesLogic {
  final ProviderReference ref;

  FilesLogic(this.ref);

  Future<void> addPicture(XFile file) async {
    var box = await ref.read(filesBoxProvider.future);
    var image = img.decodeImage(await file.readAsBytes())!;
    img.Image thumbnail = img.copyResizeCropSquare(image, 256);

    await box.put(file.path, PhotoItem.raw(file.path, Uint8List.fromList(img.encodeJpg(thumbnail)), DateTime.now()));
  }

  Future<void> deleteFile(PhotoItem file) async {
    var box = await ref.read(filesBoxProvider.future);
    await File(file.filePath).delete();
    await box.delete(file.filePath);
  }
}

@MappableClass()
class PhotoItem {
  String filePath;
  Uint8List thumbData;
  DateTime createdAt;

  PhotoItem(this.filePath, String encodedThumbData, this.createdAt) : thumbData = base64.decode(encodedThumbData);

  String get encodedThumbData => base64.encode(thumbData);

  PhotoItem.raw(this.filePath, this.thumbData, this.createdAt);
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

class ValueListener<T> extends ChangeNotifier implements ValueListenable<T?> {
  ValueListener(this._valueListenable) {
    _valueListenable?.addListener(notifyListeners);
  }

  final ValueListenable<T>? _valueListenable;

  @override
  T? get value => _valueListenable?.value;

  @override
  void dispose() {
    _valueListenable?.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  String toString() => 'ValueListener($value)';
}
