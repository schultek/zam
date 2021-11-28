import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../helpers/extensions.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../game_provider.dart';
import 'create_game_page.dart';
import 'elimination_list_page.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var games = context.watch(gamesProvider).value ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elimination Games'),
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
      body: ListView(
        children: [
          for (var game in games)
            ListTile(
              title: Text(game.name),
              subtitle: Text('Started ${game.startedAt.toDateString()}'),
              onTap: () {
                Navigator.of(context).push(EliminationListPage.route(game.id));
              },
            )
        ],
      ),
    );
  }
}
