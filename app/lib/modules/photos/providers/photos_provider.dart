import 'package:dart_mappable/dart_mappable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../api_client/photoslibrary.dart';
import '../../../providers/firebase/doc_provider.dart';
import 'photos_api_provider.dart';
import 'photos_provider.dart';

export '../../../api_client/photoslibrary.dart' show Album;

final photosLogicProvider = Provider((ref) => PhotosLogic(ref));

class PhotosLogic {
  final Ref ref;
  PhotosLogic(this.ref) {
    ref.watch(photosApiProvider);
  }

  Future<List<Album>> getAlbums() async {
    var api = ref.read(photosApiProvider);
    if (api == null) return [];

    var sAlbums = await api.sharedAlbums.list(pageSize: 50);
    var albums = await api.albums.list(pageSize: 50);
    return [...sAlbums.sharedAlbums ?? [], ...albums.albums ?? []];
  }

  Future<String> createAlbumShortcut(Album album) async {
    var response = await http.get(Uri.parse(album.coverPhotoBaseUrl! + '=w256-h256-c'));

    var coverRef = FirebaseStorage.instance.ref('albums/${album.id}/coverPhoto.png');
    await coverRef.putData(response.bodyBytes);
    var coverLink = await coverRef.getDownloadURL();

    await ref
        .read(moduleDocProvider('photos'))
        .collection('albums')
        .mapped<AlbumShortcut>()
        .doc(album.id)
        .set(AlbumShortcut(album.id!, album.title, album.productUrl!, coverLink, album.mediaItemsCount));

    return album.id!;
  }

  Future<void> removeAlbumShortcut(String id) async {
    await Future.wait([
      FirebaseStorage.instance.ref('albums/$id/coverPhoto.png').delete(),
      ref.read(moduleDocProvider('photos')).collection('albums').doc(id).delete(),
    ]);
  }
}

final albumShortcutProvider = StreamProvider.family<AlbumShortcut, String>((ref, id) => ref
    .watch(moduleDocProvider('photos'))
    .collection('albums')
    .doc(id)
    .snapshotsMapped<AlbumShortcut?>()
    .where((a) => a != null)
    .cast());

@MappableClass()
class AlbumShortcut {
  String id;
  String? title;
  String albumUrl;
  String? coverUrl;
  String? itemsCount;

  AlbumShortcut(this.id, this.title, this.albumUrl, this.coverUrl, this.itemsCount);
}
