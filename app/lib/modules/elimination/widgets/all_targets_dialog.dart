import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../elimination.module.dart';

class AllTargetsDialog extends StatefulWidget {
  final String gameId;
  const AllTargetsDialog({Key? key, required this.gameId}) : super(key: key);

  @override
  _AllTargetsDialogState createState() => _AllTargetsDialogState();

  static Future<void> show(BuildContext context, {required String gameId}) async {
    await showDialog<EliminationEntry>(
      context: context,
      useRootNavigator: false,
      builder: (context) => AllTargetsDialog(gameId: gameId),
    );
  }
}

class _AllTargetsDialogState extends State<AllTargetsDialog> {
  String? playerId;

  @override
  Widget build(BuildContext context) {
    if (playerId == null) {
      return AlertDialog(
        title: Text(context.tr.select_player),
        content: SizedBox(
          height: 400,
          width: 400,
          child: Consumer(
            builder: (context, ref, _) {
              var game = ref.watch(gameProvider(widget.gameId)).asData!.value!;
              var players = game.currentTargets.keys;

              return GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 0.7,
                children: [
                  for (var playerId in players)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          this.playerId = playerId;
                        });
                      },
                      child: Column(
                        children: [
                          UserAvatar(id: playerId),
                          const SizedBox(height: 5),
                          Text(
                            ref.watch(nicknameProvider(playerId)) ?? context.tr.anonymous,
                            style: context.theme.textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      );
    } else {
      return AlertDialog(
        title: Text(context.tr.player_status),
        content: Consumer(
          builder: (context, ref, _) {
            var game = ref.watch(gameProvider(widget.gameId)).asData!.value!;
            var player = game.currentTargets[playerId!];
            if (player == null) {
              return Text(context.tr.eliminated);
            }
            if (player == playerId) {
              return Text(context.tr.immortal);
            }
            return Text('${context.tr.target_player}: ${ref.watch(nicknameProvider(player)) ?? context.tr.anonymous}');
          },
        ),
      );
    }
  }
}
