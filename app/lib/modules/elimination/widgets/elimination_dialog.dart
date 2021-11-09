import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/user_avatar.dart';
import '../game_provider.dart';

class EliminationDialog extends StatefulWidget {
  final String gameId;
  const EliminationDialog({Key? key, required this.gameId}) : super(key: key);

  @override
  _EliminationDialogState createState() => _EliminationDialogState();

  static Future<EliminationEntry?> show(BuildContext context, {required String gameId}) {
    return showDialog<EliminationEntry>(context: context, builder: (context) => EliminationDialog(gameId: gameId));
  }
}

class _EliminationDialogState extends State<EliminationDialog> {
  int step = 0;
  MapEntry<String, String>? targetEntry;
  String? description;

  void close() {
    Navigator.of(context)
        .pop(EliminationEntry(targetEntry!.value, targetEntry!.key, description ?? '', DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    if (step == 0) {
      return AlertDialog(
        title: const Text('Select the target'),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        content: SizedBox(
          height: 400,
          width: 400,
          child: Consumer(
            builder: (context, ref, _) {
              var game = ref.watch(gameProvider(widget.gameId)).asData!.value;
              var availableTargets = game.currentTargets.entries.where((e) => e.value != null && e.value != e.key);

              return ListView(
                children: [
                  for (var entry in availableTargets)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 26),
                      leading: UserAvatar(id: entry.value!),
                      title: Text(ref.watch(nicknameProvider(entry.value!)) ?? 'Anonym'),
                      onTap: () {
                        setState(() {
                          targetEntry = MapEntry(entry.key, entry.value!);
                          step++;
                        });
                      },
                    ),
                ],
              );
            },
          ),
        ),
      );
    } else {
      return AlertDialog(
        title: const Text('Add a description'),
        content: SizedBox(
          width: 400,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'How did it happen?',
            ),
            onChanged: (text) {
              setState(() {
                description = text;
              });
            },
            onFieldSubmitted: (text) {
              close();
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              close();
            },
            child: const Text('Finish'),
          )
        ],
      );
    }
  }
}
