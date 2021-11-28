import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../game_provider.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({Key? key}) : super(key: key);

  @override
  _CreateGamePageState createState() => _CreateGamePageState();

  static Route<String> route() {
    return MaterialPageRoute(builder: (context) => const CreateGamePage());
  }
}

class _CreateGamePageState extends State<CreateGamePage> {
  String? _name;

  bool get isValid => _name != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: isValid
                ? () async {
                    var game = await context.read(gameLogicProvider).createGame(_name!);
                    Navigator.pop(context, game.id);
                  }
                : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (text) => setState(() => _name = text),
            ),
          ],
        ),
      ),
    );
  }
}
