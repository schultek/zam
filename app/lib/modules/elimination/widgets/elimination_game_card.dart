import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth/user_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../game_provider.dart';

class EliminationGameCard extends StatefulWidget {
  final String id;
  const EliminationGameCard(this.id, {Key? key}) : super(key: key);

  @override
  _EliminationGameCardState createState() => _EliminationGameCardState();
}

class _EliminationGameCardState extends State<EliminationGameCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var game = watch(gameProvider(widget.id));
        return game.when(
          data: (data) {
            var userId = watch(userIdProvider)!;
            var myTarget = data.currentTargets[userId];
            if (myTarget == null) {
              return const Center(child: Text('Eliminated'));
            } else if (myTarget == watch(userIdProvider)!) {
              return const Center(child: Text('Untouchable'));
            } else {
              return GestureDetector(
                onTap: () {
                  context
                      .read(gameLogicProvider)
                      .addEliminationEntry(data.id, EliminationEntry(myTarget, userId, 'Eliminated'));
                },
                child: Center(
                  child: Text('Target: ${watch(nicknameProvider(myTarget))}'),
                ),
              );
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error $e')),
        );
      },
    );
  }
}
