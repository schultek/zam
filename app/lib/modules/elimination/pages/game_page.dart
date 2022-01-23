import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/user_avatar.dart';
import '../game_provider.dart';
import '../widgets/all_targets_dialog.dart';
import '../widgets/elimination_dialog.dart';

class GamePage extends StatelessWidget {
  final String gameId;
  const GamePage({Key? key, required this.gameId}) : super(key: key);

  static Route route(String id) {
    return MaterialPageRoute(builder: (context) => GamePage(gameId: id));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var gameSnap = ref.watch(gameProvider(gameId));

        if (gameSnap is! AsyncData<EliminationGame>) {
          return const Scaffold();
        }

        var game = gameSnap.value;

        var curTargets = game.currentTargets;

        var targetsAvailable = curTargets.entries.where((e) => e.value != null && e.value != e.key).isNotEmpty;

        var players = curTargets.length;
        var alive = curTargets.entries.where((e) => e.value != null).length;
        var untouchable = curTargets.entries.where((e) => e.value == e.key).length;

        return Scaffold(
          appBar: AppBar(
            title: Text(game.name),
            actions: [
              if (ref.watch(isOrganizerProvider)) ...[
                IconButton(
                  onPressed: () async {
                    var shouldDelete = await showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('${context.tr.delete} ${game.name}?'),
                          actions: [
                            TextButton(
                              child: Text(context.tr.cancel),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              child: Text(context.tr.delete),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldDelete == true) {
                      Navigator.pop(context);
                      WidgetTemplate.of(context, listen: false).removeWidgetsWithId(game.id);
                      context.read(gameLogicProvider).deleteGame(game.id);
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () async {
                    AllTargetsDialog.show(context, gameId: gameId);
                  },
                  icon: const Icon(Icons.visibility),
                ),
              ]
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      '$alive/$players ${context.tr.alive.toLowerCase()}',
                      textAlign: TextAlign.justify,
                      style: context.theme.textTheme.headline4!.copyWith(color: context.onSurfaceColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$untouchable ${context.tr.immortal.toLowerCase()}',
                      textAlign: TextAlign.justify,
                      style: context.theme.textTheme.headline5!.copyWith(color: context.onSurfaceColor),
                    ),
                  ],
                ),
              ),
              const Divider(),
              for (var elim in game.eliminations) ...[
                ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              UserAvatar(id: elim.eliminatedBy),
                              const SizedBox(height: 5),
                              Text(
                                ref.watch(nicknameProvider(elim.eliminatedBy)) ?? context.tr.anonymous,
                                style: context.theme.textTheme.caption,
                              ),
                            ],
                          ),
                          const SizedBox(width: 5),
                          Column(
                            children: const [
                              Icon(Icons.arrow_forward),
                              SizedBox(height: 18),
                            ],
                          ),
                          const SizedBox(width: 5),
                          Column(
                            children: [
                              UserAvatar(id: elim.target),
                              const SizedBox(height: 5),
                              Text(
                                ref.watch(nicknameProvider(elim.target)) ?? context.tr.anonymous,
                                style: context.theme.textTheme.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              elim.time.toTimeString(),
                              style: context.theme.textTheme.caption,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              elim.description,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
              if (targetsAvailable) ...[
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 30),
                        const SizedBox(width: 10),
                        Text(context.tr.add_elimination),
                      ],
                    ),
                  ),
                  onTap: () async {
                    var elimination = await EliminationDialog.show(context, gameId: gameId);
                    if (elimination != null) {
                      ref.read(gameLogicProvider).addEliminationEntry(gameId, elimination);
                    }
                  },
                ),
                const Divider(),
              ],
            ],
          ),
        );
      },
    );
  }
}

extension on DateTime {
  String toTimeString() {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}
