import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:spotify/spotify.dart' show PlaylistSimple;

import '../../../widgets/loading_shimmer.dart';
import '../music_models.dart';
import '../music_providers.dart';
import '../widgets/track_tile.dart';

class SelectPlaylistPage extends StatefulWidget {
  const SelectPlaylistPage({Key? key}) : super(key: key);

  @override
  _SelectPlaylistPageState createState() => _SelectPlaylistPageState();

  static Route<PlaylistSimple> route() {
    return MaterialPageRoute(builder: (context) => const SelectPlaylistPage());
  }
}

class _SelectPlaylistPageState extends State<SelectPlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Playlist'),
      ),
      body: FutureBuilder<Iterable<PlaylistSimple>>(
        future: context.read(musicLogicProvider).myPlaylists(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                for (var playlist in snapshot.data!)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          playlist.images?.lastOrNull?.url ?? '',
                          height: 56,
                          frameBuilder: (context, child, frame, didLoad) {
                            if (frame == null) {
                              return const LoadingShimmer();
                            }
                            return child;
                          },
                          errorBuilder: (context, e, st) => Container(
                            color: Colors.grey,
                            child: const Icon(Icons.music_note),
                          ),
                        ),
                      ),
                    ),
                    title: Text(playlist.name!),
                    onTap: () {
                      Navigator.of(context).pop(playlist);
                    },
                  ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class TrackResult {
  final SpotifyTrack track;
  final TrackAction action;

  TrackResult(this.track, this.action);
}
