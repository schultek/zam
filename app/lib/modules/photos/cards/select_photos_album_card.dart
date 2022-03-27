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

class SelectPhotosAlbumCard extends StatelessWidget {
  const SelectPhotosAlbumCard({Key? key}) : super(key: key);

  static FutureOr<ContentSegment?> segment(ModuleContext module) {
    if (!module.context.read(isOrganizerProvider)) {
      return null;
    }

    return ContentSegment(
      module: module,
      builder: (_) => const SelectPhotosAlbumCard(),
      settings: (context) => [
        ListTile(
          title: Text(context.tr.select_album),
          onTap: () {
            selectAlbum(context, module);
          },
        ),
      ],
    );
  }

  static Future<bool> showSignInWithGooglePrompt(BuildContext context) async {
    var didSignIn = await showPrompt<bool>(
      context,
      title: context.tr.sign_in_google,
      body: context.tr.sign_in_google_desc,
      onContinue: () => context.read(googleAccountProvider.notifier).signIn(),
    );
    return didSignIn ?? false;
  }

  static Future<T?> showPrompt<T>(BuildContext context,
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

  static void selectAlbum(BuildContext context, ModuleContext module) async {
    var isSignedIn = await context.read(isSignedInWithGoogleProvider.future);
    if (!isSignedIn) {
      isSignedIn = await showSignInWithGooglePrompt(context);
      if (!isSignedIn) return;
    }

    var albums = await context.read(photosLogicProvider).getAlbums();

    var selectedAlbum = await Navigator.of(context).push(SelectPhotosAlbumPage.route(albums));

    if (selectedAlbum != null) {
      var docId = await context.read(photosLogicProvider).createAlbumShortcut(selectedAlbum);
      module.updateParams(docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleCard(title: context.tr.select_album, icon: Icons.image);
  }
}
