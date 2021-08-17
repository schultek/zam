import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../api_client/photoslibrary.dart';
import '../../../providers/photos/google_account_provider.dart';
import '../../../providers/photos/photos_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../widgets/selectable_image.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const GalleryPage());
  }
}

class _GalleryPageState extends State<GalleryPage> {
  List<File> files = [];
  bool selectForUpload = false;
  Map<String, bool> selectedFiles = {};

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    var dir = await getTemporaryDirectory();
    var files = await dir.list().where((e) => e.path.endsWith('.jpg')).asyncMap((e) => File(e.path)).toList()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    setState(() {
      this.files = files;
    });
    context.read(itemsInAlbumProvider.notifier).reload();
  }

  Future<void> uploadFiles() async {
    var filesToUpload = files.where((f) => selectedFiles[f.path] ?? false);
    if (filesToUpload.isNotEmpty) {
      await context.read(photosLogicProvider).uploadPhotos(filesToUpload.toList());
    }
  }

  Future<bool> showSignInWithGooglePrompt() async {
    var didSignIn = await showPrompt<bool>(
      title: 'SignIn with Google',
      body: 'In order to use the shared photos album, you have to sign in with your google account.',
      onContinue: () => context.read(googleAccountProvider.notifier).signInWithGoogle(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            icon: Icon(selectForUpload ? Icons.check : Icons.cloud_upload),
            onPressed: () async {
              var isSignedIn = context.read(isSignedInWithGoogleProvider);
              if (!isSignedIn) {
                isSignedIn = await showSignInWithGooglePrompt();
                if (!isSignedIn) return;
              }

              var hasAlbum = context.read(hasSharedAlbumProvider);
              if (!hasAlbum) {
                if (context.read(isOrganizerProvider)) {
                  hasAlbum = await showCreateSharedAlbumPrompt();
                  if (!hasAlbum) return;
                } else {
                  await showMissingSharedAlbumPrompt();
                  return;
                }
              }

              var didJoinAlbum = context.read(didJoinSharedAlbumProvider).data?.value ?? false;
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
            },
          )
        ],
      ),
      body: Consumer(
        builder: (context, watch, _) {
          var fileStatus = watch(fileStatusProvider);
          print('FILE STATUS $fileStatus');
          return GridView.count(
            crossAxisCount: 3,
            children: [
              for (var file in files)
                if (selectForUpload)
                  SelectableImage(
                    file: file,
                    selected: selectedFiles[file.path] ?? false,
                    status: fileStatus[file.uri.pathSegments.last],
                    onSelect: (selected) {
                      setState(() {
                        selectedFiles[file.path] = selected;
                      });
                    },
                  )
                else
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(
                          file,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        left: 5,
                        child: iconForFileStatus(fileStatus[file.uri.pathSegments.last]),
                      ),
                    ],
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
