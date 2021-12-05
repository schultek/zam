import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/user_avatar.dart';
import '../game_provider.dart';

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
        title: const Text('Select Player'),
        content: SizedBox(
          height: 400,
          width: 400,
          child: Consumer(
            builder: (context, ref, _) {
              var game = ref.watch(gameProvider(widget.gameId)).asData!.value;
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
                            ref.watch(nicknameProvider(playerId)) ?? 'Anonym',
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
        title: const Text('Player Status'),
        content: Consumer(
          builder: (context, ref, _) {
            var game = ref.watch(gameProvider(widget.gameId)).asData!.value;
            var player = game.currentTargets[playerId!];
            if (player == null) {
              return const Text('Eliminated');
            }
            if (player == playerId) {
              return const Text('Immortal');
            }
            return Text('Target: ${ref.watch(nicknameProvider(player)) ?? 'Anonym'}');
          },
        ),
      );
    }
  }
}
