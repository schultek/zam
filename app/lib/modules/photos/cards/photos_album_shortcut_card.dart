import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/core.dart';
import '../providers/photos_provider.dart';

class PhotosAlbumShortcutCard extends StatelessWidget {
  final AlbumShortcut album;
  const PhotosAlbumShortcutCard(this.album, {Key? key}) : super(key: key);

  static Future<ContentSegment> segment(ModuleContext context) async {
    var album = await context.context.read(albumShortcutProvider(context.elementId!).future);

    return ContentSegment(
      context: context,
      builder: (context) => PhotosAlbumShortcutCard(album),
      onTap: () {
        launch(album.albumUrl);
      },
      whenRemoved: (context) {
        context.read(photosLogicProvider).removeAlbumShortcut(album.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(album.coverUrl! + '=w256-h256-c'),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                  '${album.itemsCount} Elemente',
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
