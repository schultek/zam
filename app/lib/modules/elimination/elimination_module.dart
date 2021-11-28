import 'dart:async';

import '../../core/core.dart';
import 'cards/elimination_game_card.dart';
import 'cards/games_card.dart';
import 'cards/new_game_card.dart';

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

class EliminationGamesModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return GamesCard.segment(context);
  }
}
