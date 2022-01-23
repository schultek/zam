import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../providers/auth/user_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/loading_shimmer.dart';
import '../game_provider.dart';
import '../pages/elimination_help.dart';
import '../pages/game_page.dart';
import '../widgets/reveal_text_animation.dart';

class EliminationGameCard extends StatefulWidget {
  final String id;
  const EliminationGameCard(this.id, {Key? key}) : super(key: key);

  @override
  _EliminationGameCardState createState() => _EliminationGameCardState();

  static FutureOr<ContentSegment?> segment(ModuleContext context, String id) {
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
              icon: Icon(Icons.leaderboard, size: 20, color: context.onSurfaceHighlightColor),
              onPressed: () {
                Navigator.of(context).push(ModulePageRoute(context, child: GamePage(gameId: id)));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EliminationGameCardState extends State<EliminationGameCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var game = ref.watch(gameProvider(widget.id));

        return game.when(
          data: (data) {
            var userId = ref.watch(userIdProvider)!;
            var myTarget = data.currentTargets[userId];
            if (myTarget == null) {
              return Center(
                child: Text(
                  context.tr.eliminated,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: context.onSurfaceColor),
                ),
              );
            } else if (myTarget == ref.watch(userIdProvider)!) {
              return Center(
                child: Text(
                  context.tr.immortal,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: context.onSurfaceColor),
                ),
              );
            } else {
              return RevealTextAnimation(text: ref.watch(nicknameProvider(myTarget)) ?? context.tr.anonymous);
            }
          },
          loading: () => const LoadingShimmer(),
          error: (e, st) => Center(child: Text('${context.tr.error}: $e')),
        );
      },
    );
  }
}
