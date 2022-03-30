import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../polls.module.dart';

class CreatePollPage extends StatefulWidget {
  const CreatePollPage({Key? key}) : super(key: key);

  @override
  _CreatePollPageState createState() => _CreatePollPageState();

  static Route<String> route() {
    return MaterialPageRoute(builder: (context) => const CreatePollPage());
  }
}

class _CreatePollPageState extends State<CreatePollPage> {
  String? _name;
  final List<PollStep> _steps = [];

  bool get isValid => _name != null && _steps.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.create_poll),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: isValid
                ? () async {
                    var poll = await context.read(pollsLogicProvider).createPoll(_name!, _steps);
                    Navigator.pop(context, poll.id);
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
                decoration: InputDecoration(labelText: context.tr.name),
                onChanged: (text) => setState(() => _name = text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
