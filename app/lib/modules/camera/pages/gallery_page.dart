import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api_client/photoslibrary.dart';
import '../../../core/themes/themes.dart';
import '../../../providers/photos/google_account_provider.dart';
import '../../../providers/photos/photos_logic_provider.dart';
import '../../../providers/photos/photos_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../files_provider.dart';
import '../widgets/selectable_image.dart';
import 'file_view_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const GalleryPage());
  }
}

class _GalleryPageState extends State<GalleryPage> {
  bool selectForUpload = false;
  bool loadingUploadMode = false;
  Set<PhotoItem> selectedFiles = {};

  Future<void> uploadFiles() async {
    if (selectedFiles.isNotEmpty) {
      await context.read(photosLogicProvider).uploadPhotos(selectedFiles.toList());
    }
  }

  Future<bool> showSignInWithGooglePrompt() async {
    var didSignIn = await showPrompt<bool>(
      title: 'SignIn with Google',
      body: 'In order to use the shared photos album, you have to sign in with your google account.',
      onContinue: () => context.read(googleAccountProvider.notifier).signIn(),
    );
    return didSignIn ?? false;
  }

  Future<bool> showCreateSharedAlbumPrompt() async {
    var album = await showPrompt<Album?>(
      title: 'Create shared album',
      body: 'There exists currently no shared album for this trip. Continue to create a shared album in Google Photos.',
      onContinue: () => context.read(photosLogicProvider).createSharedAlbum(context.read(selectedTripProvider)!.name),
    );
    return album != null;
  }

  Future<void> showMissingSharedAlbumPrompt() async {
    await showPrompt(
        title: 'No shared album',
        body: 'There exists currently no shared album for this trip. Ask your organizer to create one.',
        onContinue: () {});
  }

  Future<bool> showJoinSharedAlbumPrompt() async {
    var album = await showPrompt<Album?>(
      title: 'Join shared album',
      body: 'You have not yet joined the shared album for this trip. Continue to join the shared album.',
      onContinue: () => context.read(photosLogicProvider).joinSharedAlbum(),
    );
    return album != null;
  }

  Future<T?> showPrompt<T>({required String title, String? body, required FutureOr<T> Function() onContinue}) async {
    var result = await showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: body != null ? Text(body) : null,
        actions: [
          TextButton(
            onPressed: () async {
              var result = await onContinue();
              Navigator.of(context).pop(result);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result;
  }

  Future<void> toggleUploadMode() async {
    var isSignedIn = await context.read(isSignedInWithGoogleProvider.future);
    if (!isSignedIn) {
      isSignedIn = await showSignInWithGooglePrompt();
      if (!isSignedIn) return;
    }

    var hasAlbum = await context.read(hasSharedAlbumProvider.future);
    if (!hasAlbum) {
      if (context.read(isOrganizerProvider)) {
        hasAlbum = await showCreateSharedAlbumPrompt();
        if (!hasAlbum) return;
      } else {
        await showMissingSharedAlbumPrompt();
        return;
      }
    }

    var didJoinAlbum = await context.read(didJoinSharedAlbumProvider.future);
    if (!didJoinAlbum) {
      didJoinAlbum = await showJoinSharedAlbumPrompt();
      if (!didJoinAlbum) return;
    }

    setState(() {
      selectForUpload = !selectForUpload;
    });
    if (!selectForUpload) {
      uploadFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          Consumer(builder: (context, watch, _) {
            var config = watch(photosConfigProvider).data?.value;
            if (config?.albumUrl != null) {
              return IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () {
                  launch(config!.albumUrl!);
                },
              );
            } else {
              return Container();
            }
          }),
          IconButton(
            icon: loadingUploadMode
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(context.getTextColor()),
                  )
                : Icon(selectForUpload ? Icons.check : Icons.cloud_upload),
            onPressed: () async {
              if (!selectForUpload) {
                setState(() {
                  loadingUploadMode = true;
                });
              }
              await toggleUploadMode();
              setState(() {
                loadingUploadMode = false;
              });
            },
          )
        ],
      ),
      body: Consumer(
        builder: (context, watch, _) {
          var files = watch(orderedFilesProvider);
          var fileStatus = watch(fileStatusProvider);
          return GridView.count(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            crossAxisCount: 3,
            children: [
              for (var file in files)
                if (selectForUpload)
                  SelectableImage(
                    file: file,
                    selected: selectedFiles.contains(file),
                    status: fileStatus[Uri.parse(file.filePath).pathSegments.last],
                    onSelect: (selected) {
                      setState(() {
                        if (selected) {
                          selectedFiles.add(file);
                        } else {
                          selectedFiles.remove(file);
                        }
                      });
                    },
                  )
                else
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(FileViewPage.route(files.indexOf(file)));
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.memory(
                            file.thumbData,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 5,
                          child: iconForFileStatus(fileStatus[Uri.parse(file.filePath).pathSegments.last]),
                        ),
                      ],
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }

  Widget iconForFileStatus(FileUploadStatus? status) {
    switch (status) {
      case FileUploadStatus.completed:
        return const Icon(Icons.cloud_done);
      case FileUploadStatus.uploading:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 2,
          ),
        );
      case FileUploadStatus.failed:
        return const Icon(Icons.error);
      default:
        return Container();
    }
  }
}
