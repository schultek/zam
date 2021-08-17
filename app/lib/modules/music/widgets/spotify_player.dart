import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';

import '../../../core/themes/themes.dart';
import '../music_providers.dart';
import '../pages/search_track_page.dart';

class SpotifyPlayer extends StatelessWidget {
  const SpotifyPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var isPaused = watch(spotifyIsPausedProvider);

        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 50,
                icon: Icon(
                  isPaused ? Icons.play_arrow : Icons.pause,
                  color: context.getTextColor(),
                ),
                onPressed: () {
                  if (isPaused) {
                    context.read(musicLogicProvider).resume();
                  } else {
                    context.read(musicLogicProvider).pause();
                  }
                },
              ),
              IconButton(
                iconSize: 20,
                icon: const Icon(Icons.search),
                onPressed: () async {
                  var track = await Navigator.of(context).push<Track>(SearchTrackPage.route());
                  if (track != null) {
                    context.read(musicLogicProvider).play(track.uri!);
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
