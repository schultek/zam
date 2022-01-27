import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/simple_card.dart';
import '../pages/select_photos_album_page.dart';
import '../providers/google_account_provider.dart';
import '../providers/photos_provider.dart';

class SelectPhotosAlbumCard extends StatefulWidget {
  final IdProvider idProvider;
  const SelectPhotosAlbumCard(this.idProvider, {Key? key}) : super(key: key);

  static FutureOr<ContentSegment?> segment(ModuleContext context) {
    if (!context.context.read(isOrganizerProvider)) {
      return null;
    }
    var idProvider = IdProvider();
    return ContentSegment(
      context: context,
      idProvider: idProvider,
      builder: (context) => SelectPhotosAlbumCard(idProvider),
    );
  }

  @override
  State<SelectPhotosAlbumCard> createState() => _SelectPhotosAlbumCardState();
}

class _SelectPhotosAlbumCardState extends State<SelectPhotosAlbumCard> {
  Future<bool> showSignInWithGooglePrompt(BuildContext context) async {
    var didSignIn = await showPrompt<bool>(
      context,
      title: context.tr.sign_in_google,
      body: context.tr.sign_in_google_desc,
      onContinue: () => context.read(googleAccountProvider.notifier).signIn(),
    );
    return didSignIn ?? false;
  }

  Future<T?> showPrompt<T>(BuildContext context,
      {required String title, String? body, required FutureOr<T> Function() onContinue}) async {
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
            child: Text(context.tr.continuee),
          ),
        ],
      ),
    );
    return result;
  }

  void selectAlbum(BuildContext context) async {
    var isSignedIn = await context.read(isSignedInWithGoogleProvider.future);
    if (!isSignedIn) {
      isSignedIn = await showSignInWithGooglePrompt(context);
      if (!isSignedIn) return;
    }

    var albums = await context.read(photosLogicProvider).getAlbums();

    var selectedAlbum = await Navigator.of(context).push(SelectPhotosAlbumPage.route(albums));

    if (selectedAlbum != null) {
      var docId = await context.read(photosLogicProvider).createAlbumShortcut(selectedAlbum);
      widget.idProvider.provide(context, docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectAlbum(context);
      },
      child: SimpleCard(title: context.tr.select_album, icon: Icons.image),
    );
  }
}
