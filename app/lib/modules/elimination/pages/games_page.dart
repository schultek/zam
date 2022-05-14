import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../builders/games_list_builder.dart';
import '../elimination.module.dart';
import 'create_game_page.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (context) => const GamesPage());
  }

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
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: GamesListBuilder(true)(context) //
            .intersperse(const SizedBox(height: 10))
            .toList(),
      ),
    );
  }
}
