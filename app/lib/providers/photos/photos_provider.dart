import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api_client/photoslibrary.dart';
import '../firebase/doc_provider.dart';
import 'photos_api_provider.dart';

export '../../main.mapper.g.dart' show PhotosConfigMapperExtension;

final photosConfigProvider =
    StreamProvider<PhotosConfig>((ref) => ref.watch(moduleDocProvider('photos')).snapshotsMapped<PhotosConfig>());

@MappableClass()
class PhotosConfig {
  String? albumId;
  String? shareToken;
  String? albumUrl;

  PhotosConfig(this.albumId, this.shareToken, this.albumUrl);
}

final photosConfigFutureProvider = FutureProvider<PhotosConfig>((ref) {
  var config = ref.watch(photosConfigProvider);
  return config.when(
    data: (config) => Future.value(config),
    loading: () => ref.read(photosConfigProvider.stream).first,
    error: (e, st) => Future.error(e, st),
  );
});

final hasSharedAlbumProvider =
    FutureProvider((ref) => ref.watch(photosConfigFutureProvider.future).then((config) => config.albumId != null));

final sharedAlbumProvider = FutureProvider<Album?>((ref) {
  var configFuture = ref.watch(photosConfigFutureProvider.future);

  return configFuture.then((config) {
    if (config.shareToken == null) return Future.value(null);

    var api = ref.watch(photosApiProvider);
    if (api == null) return Future.value(null);

    return api.sharedAlbums.get(config.shareToken!);
  });
});

final didJoinSharedAlbumProvider =
    FutureProvider((ref) => ref.watch(sharedAlbumProvider.future).then((a) => a != null));

StateNotifierProvider<RefreshablePhotosApiNotifier, PhotosLibraryApi?> get itemsApiProvider =>
    refreshablePhotosApiProvider('items');

final itemsInAlbumProvider = FutureProvider<List<MediaItem>?>((ref) {
  var configFuture = ref.watch(photosConfigFutureProvider.future);

  return configFuture.then((config) async {
    if (config.shareToken == null) return Future.value(null);

    var api = ref.watch(itemsApiProvider);
    if (api == null) return Future.value(null);

    var items = <MediaItem>[];
    String? pageToken;

    do {
      var response = await api.mediaItems.search(SearchMediaItemsRequest()
        ..albumId = config.albumId
        ..pageSize = 100);
      items += response.mediaItems ?? [];
      pageToken = response.nextPageToken;
      print('ITEMS ${response.mediaItems}');
    } while (pageToken != null);

    return items;
  });
});

enum FileUploadStatus { completed, uploading, failed }

final fileUploadingStatusProvider = StateProvider<Map<String, FileUploadStatus>>((ref) => {});

final fileStatusProvider = Provider<Map<String?, FileUploadStatus>>((ref) {
  var items = ref.watch(itemsInAlbumProvider).asData?.value ?? [];
  var filesUploading = ref.watch(fileUploadingStatusProvider);
  return {for (var item in items) item.filename: FileUploadStatus.completed, ...filesUploading};
});
