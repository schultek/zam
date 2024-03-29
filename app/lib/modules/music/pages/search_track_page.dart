import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:spotify/spotify.dart' show Track;

import '../music.module.dart';
import '../widgets/track_tile.dart';

class SearchTrackPage extends StatefulWidget {
  const SearchTrackPage({Key? key}) : super(key: key);

  @override
  _SearchTrackPageState createState() => _SearchTrackPageState();

  static Route<TrackResult> route() {
    return MaterialPageRoute(builder: (context) => const SearchTrackPage());
  }
}

class _SearchTrackPageState extends State<SearchTrackPage> {
  List<Track> suggestions = [];

  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text(context.tr.search_track),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Builder(builder: (context) {
              return TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                  hintText: context.tr.search_for_songs,
                  hintStyle: TextStyle(color: context.onSurfaceColor),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.black12,
                ),
                focusNode: searchFocusNode,
                style: DefaultTextStyle.of(context).style.copyWith(
                      fontStyle: FontStyle.italic,
                      color: context.onSurfaceColor,
                    ),
                onChanged: (text) async {
                  var results = await context.read(musicLogicProvider).search(text);
                  setState(() {
                    suggestions = results;
                  });
                },
              );
            }),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  for (var track in suggestions)
                    TrackTile(
                      track: track.toSpotifyTrack(),
                      onTap: () {
                        Navigator.of(context).pop(TrackResult(track.toSpotifyTrack(), TrackAction.play));
                      },
                      onAction: (action) {
                        Navigator.of(context).pop(TrackResult(track.toSpotifyTrack(), action));
                      },
                      actions: const {TrackAction.play, TrackAction.queue, TrackAction.addPlaylist},
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackResult {
  final SpotifyTrack track;
  final TrackAction action;

  TrackResult(this.track, this.action);
}
