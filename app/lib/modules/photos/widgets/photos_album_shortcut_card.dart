import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../photos.module.dart';

class PhotosAlbumShortcutCard extends StatelessWidget {
  final AlbumShortcut album;
  const PhotosAlbumShortcutCard(this.album, {Key? key}) : super(key: key);

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
