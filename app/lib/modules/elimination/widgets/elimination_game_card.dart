import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth/user_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/loading_shimmer.dart';
import '../game_provider.dart';
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
    return Consumer(
      builder: (context, ref, _) {
        var game = ref.watch(gameProvider(widget.id));

        return game.when(
          data: (data) {
            var userId = ref.watch(userIdProvider)!;
            var myTarget = data.currentTargets[userId];
            if (myTarget == null) {
              return const Center(
                child: Text(
                  'Eliminated',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              );
            } else if (myTarget == ref.watch(userIdProvider)!) {
              return const Center(
                child: Text(
                  'Immortal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              );
            } else {
              return RevealTextAnimation(text: ref.watch(nicknameProvider(myTarget)) ?? 'Anonym');
            }
          },
          loading: () => const LoadingShimmer(),
          error: (e, st) => Center(child: Text('Error $e')),
        );
      },
    );
  }
}
