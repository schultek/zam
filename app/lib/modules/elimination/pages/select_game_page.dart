import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../builders/games_list_builder.dart';
import 'create_game_page.dart';

class SelectGamePage extends StatefulWidget {
  const SelectGamePage({Key? key}) : super(key: key);

  @override
  _SelectGamePageState createState() => _SelectGamePageState();

  static Route<String> route() {
    return MaterialPageRoute(builder: (context) => const SelectGamePage());
  }
}

class _SelectGamePageState extends State<SelectGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.select_game),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: <Widget>[
          ThemedSurface(
            builder: (context, color) => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Text(context.tr.new_game),
              leading: const Icon(Icons.casino),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              tileColor: color,
              onTap: () async {
                var gameId = await Navigator.of(context).push(CreateGamePage.route());
                if (gameId != null) {
                  Navigator.of(context).pop(gameId);
                }
              },
            ),
          ),
          ...GamesListBuilder(true)(context, (game) {
            Navigator.of(context).pop(game.id);
          }),
        ].intersperse(const SizedBox(height: 10)).toList(),
      ),
    );
  }
}
