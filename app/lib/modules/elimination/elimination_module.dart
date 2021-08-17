/*

Quad Card

- Starting Countdown

- State
  - Current Target (Obscurred until pressed)  ( §$%&#*:¶±¿ɫɤɷʓʘʨʧʦʥʤΦΧΨΩΣϔϞϢϪϰϼϠϑϐξ )
  - Untouchable
  - Eliminated
  - Emperor
- Amount Players Left / Total Players

Elimination Page

 - Current Target
 - Amount Players Left
 - List (Hitman -- Target -- Situation)
 - Add Entry (For self by default, or choose other player)


Organizer Card
- Show Other Targets




 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/module/module.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'game_provider.dart';
import 'pages/elimination_help.dart';
import 'pages/elimination_stats.dart';
import 'widgets/elimination_game_card.dart';

@Module('elimination')
class EliminationModule {
  @ModuleItem('game')
  ContentSegment? getGame(BuildContext context, String? id) {
    if (id == null) {
      if (!context.read(isOrganizerProvider)) {
        return null;
      }
      var idProvider = IdProvider();
      return ContentSegment(
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
    }

    var helpKey = GlobalKey(), statsKey = GlobalKey();
    return ContentSegment(
      builder: (context) => Stack(
        children: [
          EliminationGameCard(id),
          Positioned.fill(child: EliminationHelp(key: helpKey)),
          Positioned.fill(child: EliminationStats(id, key: statsKey)),
        ],
      ),
    );
  }
}
