import 'dart:async';

import '../../core/core.dart';
import 'widgets/photos_album_shortcut_widget.dart';
import 'widgets/select_photos_album_widget.dart';

class PhotosModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return context.when(
      withId: (id) => PhotosAlbumShortcutWidget.segment(context),
      withoutId: () => SelectPhotosAlbumWidget.segment(context),
    );
  }
}
