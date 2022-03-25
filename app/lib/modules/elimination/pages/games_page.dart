import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../helpers/extensions.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../widgets/games_list.dart';
import 'create_game_page.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.elimination),
        actions: [
          if (context.read(isOrganizerProvider))
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, CreateGamePage.route());
              },
            )
        ],
      ),
      body: const GamesList(),
    );
  }
}
