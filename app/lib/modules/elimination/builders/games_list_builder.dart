import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../elimination.module.dart';
import '../widgets/game_tile.dart';

class GamesListBuilder {
  GamesListBuilder([this.needsSurface = false]);

  final bool needsSurface;

  List<Widget> call(BuildContext context, [void Function(EliminationGame game)? onTap]) {
    var games = context.watch(gamesProvider).value ?? [];
    games.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return [
      for (var game in games)
        GameTile(game, onTap: onTap != null ? () => onTap(game) : null, needsSurface: needsSurface)
    ];
  }
}
