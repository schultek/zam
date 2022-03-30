part of photos_module;

@MappableClass()
class AlbumShortcut {
  String id;
  String? title;
  String albumUrl;
  String coverUrl;
  String? itemsCount;

  AlbumShortcut(this.id, this.title, this.albumUrl, this.coverUrl, this.itemsCount);
}
