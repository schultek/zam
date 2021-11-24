import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../providers/photos_provider.dart';

class SelectPhotosAlbumPage extends StatefulWidget {
  final List<Album> albums;
  const SelectPhotosAlbumPage(this.albums, {Key? key}) : super(key: key);

  @override
  _SelectPhotosAlbumPageState createState() => _SelectPhotosAlbumPageState();

  static Route<Album> route(List<Album> albums) {
    return MaterialPageRoute(builder: (context) => SelectPhotosAlbumPage(albums));
  }
}

class _SelectPhotosAlbumPageState extends State<SelectPhotosAlbumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Album'),
      ),
      body: ListView(
        children: [
          for (var album in widget.albums)
            ListTile(
              title: Text(album.title ?? ''),
              subtitle: Text('${album.mediaItemsCount} Elemente'),
              leading: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(imageUrl: '${album.coverPhotoBaseUrl}=w256-h256-c'),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(album);
              },
            ),
        ],
      ),
    );
  }
}
