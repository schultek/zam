import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../music.module.dart';
import '../pages/manage_playlist_page.dart';
import 'select_device_dialog.dart';

class SpotifyPlayerCard extends StatelessWidget {
  const SpotifyPlayerCard({this.showPlayerControls = true, this.showPlaylistControls = true, Key? key})
      : super(key: key);

  final bool showPlayerControls;
  final bool showPlaylistControls;

  @override
  Widget build(BuildContext context) {
    var _ = context.watch(spotifySyncProvider);
    var player = context.watch(playerProvider);

    var isOrganizer = context.watch(isOrganizerProvider);

    var trackName = player?.track.name;
    var artistName = player?.track.artists.map((a) => a.name).join(', ');
    var albumUrl = player?.track.album.images.firstOrNull?.url;

    return Container(
      decoration: BoxDecoration(
        image: albumUrl != null
            ? DecorationImage(
                colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.multiply),
                image: NetworkImage(albumUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          if (player != null)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OverflowScrollText(
                    trackName!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  OverflowScrollText(artistName!),
                ],
              ),
            ),
          if (showPlayerControls || isOrganizer)
            Positioned.fill(
              child: Opacity(
                opacity: showPlayerControls ? 1 : 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 25,
                      icon: Icon(
                        Icons.skip_previous,
                        color: context.onSurfaceColor.withOpacity(player != null ? 1 : 0.5),
                      ),
                      onPressed: player != null
                          ? () {
                              context.read(musicLogicProvider).skipPrevious();
                            }
                          : null,
                    ),
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                        player?.isPlaying ?? true ? Icons.pause : Icons.play_arrow,
                        color: context.onSurfaceColor.withOpacity(player != null ? 1 : 0.5),
                      ),
                      onPressed: player != null
                          ? () {
                              if (player.isPlaying) {
                                context.read(musicLogicProvider).pause();
                              } else {
                                context.read(musicLogicProvider).resume();
                              }
                            }
                          : null,
                    ),
                    IconButton(
                      iconSize: 25,
                      icon: Icon(
                        Icons.skip_next,
                        color: context.onSurfaceColor.withOpacity(player != null ? 1 : 0.5),
                      ),
                      onPressed: player != null
                          ? () {
                              context.read(musicLogicProvider).skipNext();
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          if (player == null)
            if (showPlayerControls || isOrganizer)
              Positioned(
                right: 5,
                bottom: 5,
                child: Opacity(
                  opacity: showPlayerControls ? 1 : 0.5,
                  child: IconButton(
                    iconSize: 22,
                    icon: Icon(
                      Icons.devices,
                      color: context.onSurfaceColor,
                    ),
                    onPressed: () async {
                      await SelectDeviceDialog.show(context);
                    },
                  ),
                ),
              ),
          if (player != null)
            if (showPlaylistControls || isOrganizer)
              Positioned(
                right: 5,
                bottom: 5,
                child: Opacity(
                  opacity: showPlaylistControls ? 1 : 0.5,
                  child: IconButton(
                    iconSize: 22,
                    icon: Icon(
                      Icons.playlist_play,
                      color: context.onSurfaceColor,
                    ),
                    onPressed: () async {
                      context.read(musicLogicProvider).getDevices();
                      Navigator.of(context).push(ManagePlaylistPage.route(context));
                    },
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class OverflowScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  const OverflowScrollText(this.text, {this.style, Key? key}) : super(key: key);

  @override
  _OverflowScrollTextState createState() => _OverflowScrollTextState();
}

class _OverflowScrollTextState extends State<OverflowScrollText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: widget.style,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}
