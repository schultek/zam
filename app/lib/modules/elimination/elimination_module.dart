import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'game_provider.dart';
import 'pages/elimination_help.dart';
import 'pages/elimination_list_page.dart';
import 'widgets/elimination_game_card.dart';

class EliminationModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return context.when(withId: (id) {
      return ContentSegment(
        context: context,
        builder: (context) => Stack(
          children: [
            EliminationGameCard(id),
            const Positioned.fill(child: EliminationHelp()),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.leaderboard, size: 20, color: context.getTextColor()),
                onPressed: () {
                  Navigator.of(context).push(ModulePageRoute(context, child: EliminationListPage(gameId: id)));
                },
              ),
            ),
          ],
        ),
      );
    }, withoutId: () {
      if (!context.context.read(isOrganizerProvider)) {
        return null;
      }
      var idProvider = IdProvider();
      return ContentSegment(
        context: context,
        idProvider: idProvider,
        builder: (context) => GestureDetector(
          onTap: () async {
            var game = await context.read(gameLogicProvider).createGame();
            idProvider.provide(context, game.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: context.getTextColor(),
                  size: 50,
                ),
                const SizedBox(height: 5),
                const Text(
                  'New game\n(Tap to setup)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
