import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../elimination.module.dart';
import '../pages/game_page.dart';
import 'elimination_help.dart';
import 'reveal_text_animation.dart';

class EliminationGameCard extends StatefulWidget {
  final String id;
  const EliminationGameCard(this.id, {Key? key}) : super(key: key);

  @override
  _EliminationGameCardState createState() => _EliminationGameCardState();
}

class _EliminationGameCardState extends State<EliminationGameCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer(
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
        ),
        const Positioned.fill(child: EliminationHelp()),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.leaderboard, size: 20, color: context.onSurfaceHighlightColor),
            onPressed: () {
              Navigator.of(context).push(ModulePageRoute(context, child: GamePage(gameId: widget.id)));
            },
          ),
        ),
      ],
    );
  }
}
