import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../providers/google_account_provider.dart';
import '../providers/photos_provider.dart';

class PhotosAlbumShortcutCard extends StatelessWidget {
  final AlbumShortcut album;
  const PhotosAlbumShortcutCard(this.album, {Key? key}) : super(key: key);

  static Future<ContentSegment> segment(ModuleContext module) async {
    var albumId = module.getParams<String>();
    var album = await module.context.read(albumShortcutProvider(albumId).future);

    return ContentSegment(
      module: module,
      builder: (context) => PhotosAlbumShortcutCard(album),
      onTap: (context) {
        launch(album.albumUrl);
      },
      whenRemoved: (context) {
        context.read(googleAccountProvider.notifier).signOut();
        context.read(photosLogicProvider).removeAlbumShortcut(album.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(album.coverUrl),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: context.theme.primaryColor.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    album.title!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                  Text(
                    '${album.itemsCount} ${context.tr.elements}',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
