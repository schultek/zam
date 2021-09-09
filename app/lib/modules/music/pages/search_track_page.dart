import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart' show Track;

import '../../../core/themes/themes.dart';
import '../music_models.dart';
import '../music_providers.dart';
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
      appBar: AppBar(
        title: const Text('Search Track'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              hintText: 'Suche nach Liedern',
              hintStyle: TextStyle(color: context.getFillColor()),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.black12,
            ),
            focusNode: searchFocusNode,
            style: DefaultTextStyle.of(context).style.copyWith(
                  fontStyle: FontStyle.italic,
                  color: context.getFillColor(),
                ),
            onChanged: (text) async {
              var results = await context.read(musicLogicProvider).search(text);
              setState(() {
                suggestions = results;
              });
            },
          ),
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
                    actions: const {TrackAction.play, TrackAction.queue, TrackAction.add_playlist},
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrackResult {
  final SpotifyTrack track;
  final TrackAction action;

  TrackResult(this.track, this.action);
}
