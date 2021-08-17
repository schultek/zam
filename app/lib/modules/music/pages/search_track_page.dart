import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:spotify/spotify.dart' as sp;

import '../music_providers.dart';

class SearchTrackPage extends StatefulWidget {
  const SearchTrackPage({Key? key}) : super(key: key);

  @override
  _SearchTrackPageState createState() => _SearchTrackPageState();

  static Route<sp.Track> route() {
    return MaterialPageRoute(builder: (context) => const SearchTrackPage());
  }
}

class _SearchTrackPageState extends State<SearchTrackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TypeAheadField<sp.Track>(
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              style: DefaultTextStyle.of(context).style.copyWith(fontStyle: FontStyle.italic),
              decoration: const InputDecoration(border: OutlineInputBorder())),
          suggestionsCallback: (pattern) async {
            var suggestions = await context.read(musicLogicProvider).search(pattern);
            return suggestions;
          },
          itemBuilder: (context, track) {
            return ListTile(
              leading: Image.network(track.album?.images?.last.url ?? ''),
              title: Text(track.name ?? '__'),
              subtitle: Text(track.artists?.map((a) => a.name).join(', ') ?? ''),
            );
          },
          onSuggestionSelected: (suggestion) {
            Navigator.of(context).pop(suggestion);
          },
        ),
      ),
    );
  }
}
