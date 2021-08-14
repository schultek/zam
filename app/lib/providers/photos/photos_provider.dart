import 'dart:io';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api_client/photoslibrary.dart';
import '../../models/models.dart';
import '../firebase/doc_provider.dart';
import 'photos_api_provider.dart';

final photosConfigProvider =
    StreamProvider((ref) => ref.watch(moduleDocProvider('photos')).snapshots().map((d) => d.decode<PhotosConfig>()));

@MappableClass()
class PhotosConfig {
  String? albumId;
  String? shareToken;

  PhotosConfig(this.albumId, this.shareToken);
}

final hasSharedAlbumProvider = Provider((ref) => ref.watch(photosConfigProvider).data?.value.albumId != null);

final didJoinSharedAlbumProvider = FutureProvider((ref) => ref.watch(photosLogicProvider).didJoinSharedAlbum());

final itemsInAlbumProvider = StateNotifierProvider<ItemsNotifier, List<MediaItem>?>((ref) => ItemsNotifier(ref));

class ItemsNotifier extends StateNotifier<List<MediaItem>?> {
  final ProviderReference ref;
  ItemsNotifier(this.ref) : super(null) {
    reload();
  }

  void reload() {
    ref.watch(photosLogicProvider).getItemsInAlbum().then((items) {
      state = items;
    });
  }
}

enum FileUploadStatus { completed, uploading, failed }

final fileUploadingStatusProvider = StateProvider<Map<String, FileUploadStatus>>((ref) => {});

final fileStatusProvider = Provider<Map<String?, FileUploadStatus>>((ref) {
  var items = ref.watch(itemsInAlbumProvider) ?? [];
  var filesUploading = ref.watch(fileUploadingStatusProvider).state;
  return {for (var item in items) item.filename: FileUploadStatus.completed, ...filesUploading};
});

final photosLogicProvider = Provider((ref) => PhotosLogic(ref));

class PhotosLogic {
  final ProviderReference ref;
  PhotosLogic(this.ref) {
    ref.watch(photosConfigProvider);
    ref.watch(photosApiProvider);
    ref.watch(photosApiClientProvider);
  }

  Future<List<MediaItem>?> getItemsInAlbum() async {
    var config = ref.read(photosConfigProvider).data?.value;
    if (config == null || config.albumId == null) return null;

    var api = ref.read(photosApiProvider);
    if (api == null) return null;

    var items = <MediaItem>[];
    String? pageToken;

    do {
      var response = await api.mediaItems.search(SearchMediaItemsRequest()
        ..albumId = config.albumId
        ..pageSize = 100);
      items += response.mediaItems ?? [];
      pageToken = response.nextPageToken;
      print("ITEMS ${response.mediaItems}");
    } while (pageToken != null);

    return items;
  }

  Future<bool> didJoinSharedAlbum() async {
    var config = ref.read(photosConfigProvider).data?.value;
    if (config == null || config.albumId == null) return false;

    var api = ref.read(photosApiProvider);
    if (api == null) return false;

    try {
      await api.albums.get(config.albumId!);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Album?> createSharedAlbum(String title) async {
    var api = ref.read(photosApiProvider);
    if (api == null) return null;
    var album = await api.albums.create(CreateAlbumRequest()..album = (Album()..title = title));
    var shareResponse = await api.albums
        .share(ShareAlbumRequest()..sharedAlbumOptions = (SharedAlbumOptions()..isCollaborative = true), album.id!);
    album.shareInfo = shareResponse.shareInfo;
    await ref.read(moduleDocProvider('photos')).set(PhotosConfig(album.id, album.shareInfo!.shareToken).toMap());
    return album;
  }

  Future<Album?> joinSharedAlbum() async {
    var api = ref.read(photosApiProvider);
    if (api == null) return null;
    var config = ref.read(photosConfigProvider).data?.value;
    if (config == null || config.shareToken == null) return null;
    try {
      var response = await api.sharedAlbums.join(JoinSharedAlbumRequest()..shareToken = config.shareToken);
      return response.album;
    } on DetailedApiRequestError catch (e) {
      print(e.jsonResponse);
    }
  }

  Future<void> uploadPhotos(List<File> files) async {
    var client = ref.read(photosApiClientProvider);
    var api = ref.read(photosApiProvider);
    if (api == null || client == null) return;

    var config = ref.read(photosConfigProvider).data?.value;
    if (config == null || config.albumId == null) return;

    print("Upload files: $files");

    ref.read(fileUploadingStatusProvider).state = {
      ...ref.read(fileUploadingStatusProvider).state,
      for (var file in files) file.uri.pathSegments.last: FileUploadStatus.uploading,
    };

    var responses = await Future.wait([
      for (var file in files)
        file
            .readAsBytes()
            .then((bytes) => client.post(
                  Uri.parse("https://photoslibrary.googleapis.com/v1/uploads"),
                  headers: {
                    "Content-type": "application/octet-stream",
                    "X-Goog-Upload-Content-Type": "image/jpeg",
                    "X-Goog-Upload-Protocol": "raw",
                  },
                  body: bytes,
                ))
            .then<String?>((r) {
          if (r.statusCode == 200) {
            ref.read(fileUploadingStatusProvider).state = {
              ...ref.read(fileUploadingStatusProvider).state,
              file.uri.pathSegments.last: FileUploadStatus.completed,
            };
            return r.body;
          } else {
            throw Future.error(0);
          }
        }).catchError((_) {
          ref.read(fileUploadingStatusProvider).state = {
            ...ref.read(fileUploadingStatusProvider).state,
            file.uri.pathSegments.last: FileUploadStatus.failed,
          };
          return null;
        }),
    ]);

    var uploadTokens = responses.whereType<String>();
    print("Upload Tokens: $uploadTokens");

    var i = 0;
    var createResponse = await api.mediaItems.batchCreate(BatchCreateMediaItemsRequest()
      ..albumId = config.albumId
      ..newMediaItems = [
        for (var uploadToken in uploadTokens)
          NewMediaItem()
            ..simpleMediaItem = (SimpleMediaItem()
              ..fileName = files[i++].uri.pathSegments.last
              ..uploadToken = uploadToken)
      ]);

    await api.albums.batchAddMediaItems(
        BatchAddMediaItemsToAlbumRequest()
          ..mediaItemIds = [...createResponse.newMediaItemResults!.map((m) => m.mediaItem!.id!)],
        config.albumId!);
  }
}
