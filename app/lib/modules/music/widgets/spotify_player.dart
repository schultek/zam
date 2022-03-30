import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../music.module.dart';
import '../pages/manage_playlist_page.dart';
import 'select_device_dialog.dart';

class SpotifyPlayerCard extends StatelessWidget {
  const SpotifyPlayerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var _ = ref.watch(spotifySyncProvider);
        var player = ref.watch(playerProvider);

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
              Positioned.fill(
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
                              ref.read(musicLogicProvider).skipPrevious();
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
                                ref.read(musicLogicProvider).pause();
                              } else {
                                ref.read(musicLogicProvider).resume();
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
                              ref.read(musicLogicProvider).skipNext();
                            }
                          : null,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: player != null
                    ? IconButton(
                        iconSize: 22,
                        icon: Icon(
                          Icons.playlist_play,
                          color: context.onSurfaceColor,
                        ),
                        onPressed: () async {
                          ref.read(musicLogicProvider).getDevices();
                          Navigator.of(context).push(ManagePlaylistPage.route(context));
                        },
                      )
                    : IconButton(
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
            ],
          ),
        );
      },
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
