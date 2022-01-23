import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import 'cards/elimination_game_card.dart';
import 'cards/games_card.dart';
import 'cards/new_game_card.dart';
import 'game_provider.dart';
import 'pages/create_game_page.dart';
import 'pages/games_page.dart';
import 'widgets/games_list.dart';

class EliminationGameModule extends ModuleBuilder<ContentSegment> {
  EliminationGameModule() : super('elimination');

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'game': buildGame,
        'new_game': buildNewGameAction,
        'games_action': buildGamesAction,
        'games': buildGames,
        'games_list': buildGamesList,
      };

  FutureOr<ContentSegment?> buildGame(ModuleContext context) {
    return context.when(withId: (id) {
      return EliminationGameCard.segment(context, id);
    }, withoutId: () {
      return NewGameCard.segment(context);
    });
  }

  FutureOr<QuickAction?> buildNewGameAction(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.add,
      text: context.context.tr.new_game,
      onNavigate: (context) => const CreateGamePage(),
    );
  }

  FutureOr<QuickAction?> buildGamesAction(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.list,
      text: context.context.tr.elimination_games,
      onNavigate: (context) => const GamesPage(),
    );
  }

  FutureOr<ContentSegment?> buildGames(ModuleContext context) {
    return GamesCard.segment(context);
  }

  FutureOr<ContentSegment?> buildGamesList(ModuleContext context) async {
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
