import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import '../../providers/general/hive_provider.dart';

final filesBoxProvider = hiveBoxProvider<PhotoItem>('photos3');

final filesProvider = filesBoxProvider.valuesProvider();

final orderedFilesProvider = FutureProvider((ref) async {
  var files = await ref.watch(filesProvider.future);
  return files.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt) * -1);
});

final lastPictureProvider = FutureProvider<PhotoItem?>((ref) async {
  var files = await ref.watch(orderedFilesProvider.future);
  return files.firstOrNull;
});

final filesLogicProvider = Provider((ref) => FilesLogic(ref));

class FilesLogic {
  final Ref ref;

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
