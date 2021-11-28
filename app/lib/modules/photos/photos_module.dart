import 'dart:async';

import '../../core/core.dart';
import 'cards/photos_album_shortcut_card.dart';
import 'cards/select_photos_album_card.dart';

class PhotosModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return context.when(
      withId: (id) => PhotosAlbumShortcutCard.segment(context),
      withoutId: () => SelectPhotosAlbumCard.segment(context),
    );
  }
}
