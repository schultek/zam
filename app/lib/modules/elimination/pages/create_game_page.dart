import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../elimination.module.dart';

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
  bool _allowLoops = true;

  bool get isValid => _name != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.create_game),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: isValid
                ? () async {
                    var game = await context.read(gameLogicProvider).createGame(_name!, _allowLoops);
                    Navigator.pop(context, game.id);
                  }
                : null,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          SettingsSection(
            padding: const EdgeInsets.all(14),
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: context.tr.name),
                onChanged: (text) => setState(() => _name = text),
              ),
            ],
          ),
          SettingsSection(
            children: [
              SwitchListTile(
                value: _allowLoops,
                title: Text(context.tr.allow_loops),
                onChanged: (value) => setState(() => _allowLoops = value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
