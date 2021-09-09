import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/themes.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/user_avatar.dart';
import '../game_provider.dart';
import '../widgets/all_targets_dialog.dart';
import '../widgets/elimination_dialog.dart';

class EliminationListPage extends StatelessWidget {
  final String gameId;
  const EliminationListPage({Key? key, required this.gameId}) : super(key: key);

  static Route route(String id) {
    return MaterialPageRoute(builder: (context) => EliminationListPage(gameId: id));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var game = watch(gameProvider(gameId)).data!.value;

        var curTargets = game.currentTargets;

        var targetsAvailable = curTargets.entries.where((e) => e.value != null && e.value != e.key).isNotEmpty;

        var players = curTargets.length;
        var alive = curTargets.entries.where((e) => e.value != null).length;
        var untouchable = curTargets.entries.where((e) => e.value == e.key).length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Elimination List'),
            actions: [
              if (watch(isOrganizerProvider))
                IconButton(
                  onPressed: () async {
                    AllTargetsDialog.show(context, gameId: gameId);
                  },
                  icon: const Icon(Icons.visibility),
                ),
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
                      '$alive/$players alive',
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.headline4!.copyWith(color: context.getTextColor()),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$untouchable immortal',
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.headline5!.copyWith(color: context.getTextColor()),
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
                                watch(nicknameProvider(elim.eliminatedBy)) ?? 'Anonym',
                                style: Theme.of(context).textTheme.caption,
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
                                watch(nicknameProvider(elim.target)) ?? 'Anonym',
                                style: Theme.of(context).textTheme.caption,
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
                              style: Theme.of(context).textTheme.caption,
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
                      children: const [
                        Icon(Icons.add, size: 30),
                        SizedBox(width: 10),
                        Text('Add Elimination'),
                      ],
                    ),
                  ),
                  onTap: () async {
                    var elimination = await EliminationDialog.show(context, gameId: gameId);
                    if (elimination != null) {
                      context.read(gameLogicProvider).addEliminationEntry(gameId, elimination);
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
