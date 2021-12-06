import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import 'cards/elimination_game_card.dart';
import 'cards/games_card.dart';
import 'cards/new_game_card.dart';
import 'game_provider.dart';
import 'pages/create_game_page.dart';
import 'widgets/games_list.dart';

class EliminationGameModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return context.when(withId: (id) {
      return EliminationGameCard.segment(context, id);
    }, withoutId: () {
      return NewGameCard.segment(context);
    });
  }
}

class EliminationNewGameActionModule extends ModuleBuilder<QuickAction> {
  @override
  FutureOr<QuickAction?> build(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.add,
      text: 'New Game',
      onNavigate: (context) => const CreateGamePage(),
    );
  }
}

class EliminationGamesModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return GamesCard.segment(context);
  }
}

class EliminationGamesListModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) async {
    var games = await context.context.read(gamesProvider.future);
    if (games.isNotEmpty) {
      return ContentSegment.list(
        context: context,
        builder: GamesList.tilesBuilder,
        spacing: 10,
      );
    }
  }
}
