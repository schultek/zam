import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import 'cards/photos_album_shortcut_card.dart';
import 'cards/select_photos_album_card.dart';

class PhotosModule extends ModuleBuilder {
  PhotosModule() : super('photos');

  @override
  String getName(BuildContext context) => context.tr.photos;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'album': buildAlbum,
      };

  FutureOr<ContentSegment?> buildAlbum(ModuleContext context) {
    return context.when(
      withId: (id) => PhotosAlbumShortcutCard.segment(context),
      withoutId: () => SelectPhotosAlbumCard.segment(context),
    );
  }
}
