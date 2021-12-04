import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../../providers/auth/user_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/loading_shimmer.dart';
import '../game_provider.dart';
import '../pages/elimination_help.dart';
import '../pages/elimination_list_page.dart';
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
              icon: Icon(Icons.leaderboard, size: 20, color: context.onSurfaceColor),
              onPressed: () {
                Navigator.of(context).push(ModulePageRoute(context, child: EliminationListPage(gameId: id)));
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
