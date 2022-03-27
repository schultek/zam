import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../../widgets/simple_card.dart';
import 'cards/elimination_game_card.dart';
import 'cards/games_card.dart';
import 'game_provider.dart';
import 'pages/create_game_page.dart';
import 'pages/games_page.dart';
import 'widgets/games_list.dart';

class EliminationGameModule extends ModuleBuilder {
  EliminationGameModule() : super('elimination');

  @override
  String getName(BuildContext context) => context.tr.elimination;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'game': buildGame,
        'new_game': buildNewGameAction,
        'games_action': buildGamesAction,
        'games': buildGames,
        'games_list': buildGamesList,
      };

  FutureOr<ContentSegment?> buildGame(ModuleContext module) {
    if (module.hasParams) {
      var gameId = module.getParams<String>();
      return EliminationGameCard.segment(module, gameId);
    } else {
      if (!module.context.read(isOrganizerProvider)) {
        return null;
      }
      return ContentSegment(
        module: module,
        builder: (context) => SimpleCard(title: context.tr.new_game_setup, icon: Icons.add),
        settings: (context) => [
          ListTile(
            title: Text(context.tr.new_game),
            onTap: () async {
              var gameId = await Navigator.of(context).push(CreateGamePage.route());
              if (gameId != null) {
                module.updateParams(gameId);
              }
            },
          ),
        ],
      );
    }
  }

  FutureOr<QuickAction?> buildNewGameAction(ModuleContext module) {
    return QuickAction(
      module: module,
      icon: Icons.add,
      text: module.context.tr.new_game,
      onNavigate: (context) => const CreateGamePage(),
    );
  }

  FutureOr<QuickAction?> buildGamesAction(ModuleContext module) {
    return QuickAction(
      module: module,
      icon: Icons.list,
      text: module.context.tr.elimination,
      onNavigate: (context) => const GamesPage(),
    );
  }

  FutureOr<ContentSegment?> buildGames(ModuleContext module) {
    return GamesCard.segment(module);
  }

  FutureOr<ContentSegment?> buildGamesList(ModuleContext module) async {
    var games = await module.context.read(gamesProvider.future);
    if (games.isNotEmpty) {
      return ContentSegment.list(
        module: module,
        builder: GamesList.tilesBuilder,
        spacing: 10,
      );
    }
    return null;
  }
}
