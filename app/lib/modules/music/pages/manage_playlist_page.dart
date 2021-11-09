import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/route/route.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../music_providers.dart';
import '../widgets/track_tile.dart';
import 'search_track_page.dart';
import 'select_playlist_page.dart';

class ManagePlaylistPage extends StatelessWidget {
  const ManagePlaylistPage({Key? key}) : super(key: key);

  static Route route(BuildContext context) {
    return ModulePageRoute(context, child: const ManagePlaylistPage());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var playlist = ref.watch(playlistProvider);
        var musicLogic = ref.read(musicLogicProvider);

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                if (playlist?.images.lastOrNull != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      playlist!.images.last.url,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    playlist?.name ?? 'Playlist',
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            actions: [
              if (ref.read(isOrganizerProvider))
                IconButton(
                  icon: const Icon(Icons.playlist_add_check),
                  onPressed: () async {
                    var logic = ref.read(spotifySyncProvider);
                    var playlist = await Navigator.of(context).push(SelectPlaylistPage.route());
                    if (playlist != null) {
                      logic.syncPlaylist(playlist.id);
                    }
                  },
                ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  var nav = Navigator.of(context);
                  var result = await nav.push(SearchTrackPage.route());
                  if (result != null) {
                    if (result.action == TrackAction.play) {
                      musicLogic.play(result.track.uri);
                      nav.pop();
                    } else if (result.action == TrackAction.queue) {
                      musicLogic.addToQueue(result.track.uri);
                    } else if (playlist != null) {
                      musicLogic.addToPlaylist(result.track.uri, playlist.id);
                    }
                  }
                },
              ),
              if (playlist != null)
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () {
                    launch(playlist.spotifyUrl);
                  },
                )
            ],
          ),
          body: playlist == null
              ? Center(
                  child: TextButton(
                    onPressed: () {
                      ref.read(musicLogicProvider).createSharedPlaylist();
                    },
                    child: const Text('Create Shared Playlist'),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    for (var track in playlist.tracks)
                      TrackTile(
                        track: track,
                        onTap: () {
                          ref.read(musicLogicProvider).play(null, context: playlist.uri, offset: {'uri': track.uri});
                          Navigator.of(context).pop();
                        },
                        onAction: (action) {
                          if (action == TrackAction.play) {
                            ref.read(musicLogicProvider).play(null, context: playlist.uri, offset: {'uri': track.uri});
                            Navigator.of(context).pop();
                          } else if (action == TrackAction.queue) {
                            ref.read(musicLogicProvider).addToQueue(track.uri);
                          } else {
                            ref.read(musicLogicProvider).removeFromPlaylist(track.uri, playlist.id);
                          }
                        },
                        actions: const {TrackAction.play, TrackAction.queue, TrackAction.deletePlaylist},
                      ),
                  ],
                ),
        );
      },
    );
  }
}
