import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/route/route.dart';
import '../music_providers.dart';
import '../widgets/track_tile.dart';
import 'search_track_page.dart';

class ManagePlaylistPage extends StatelessWidget {
  const ManagePlaylistPage({Key? key}) : super(key: key);

  static Route route(BuildContext context) {
    return ModulePageRoute(context, child: const ManagePlaylistPage());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var playlist = watch(playlistProvider);
        var musicLogic = context.read(musicLogicProvider);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Playlist'),
            actions: [
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
                      context.read(musicLogicProvider).createSharedPlaylist();
                    },
                    child: const Text('Create Playlist'),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    for (var track in playlist.tracks)
                      TrackTile(
                        track: track,
                        onTap: () {
                          context
                              .read(musicLogicProvider)
                              .play(null, context: playlist.uri, offset: {'uri': track.uri});
                          Navigator.of(context).pop();
                        },
                        onAction: (action) {
                          if (action == TrackAction.play) {
                            context
                                .read(musicLogicProvider)
                                .play(null, context: playlist.uri, offset: {'uri': track.uri});
                            Navigator.of(context).pop();
                          } else if (action == TrackAction.queue) {
                            context.read(musicLogicProvider).addToQueue(track.uri);
                          } else {
                            context.read(musicLogicProvider).removeFromPlaylist(track.uri, playlist.id);
                          }
                        },
                        actions: const {TrackAction.play, TrackAction.queue, TrackAction.delete_playlist},
                      ),
                  ],
                ),
        );
      },
    );
  }
}