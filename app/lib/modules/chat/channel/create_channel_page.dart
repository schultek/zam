import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth/user_provider.dart';
import '../chat_provider.dart';
import 'add_members_page.dart';

class CreateChannelPage extends StatefulWidget {
  const CreateChannelPage({Key? key}) : super(key: key);

  @override
  _CreateChannelPageState createState() => _CreateChannelPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const CreateChannelPage());
  }
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  String? name;
  bool isOpen = true;

  Future<void> createChannel() async {
    var channel = await context.read(chatLogicProvider).addChannel(
      name!,
      isOpen: isOpen,
      members: [context.read(userIdProvider)!],
    );
    Navigator.of(context).pushReplacement(AddMembersPage.route(channel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neuer Channel"),
        actions: [
          TextButton(
            onPressed: name != null && name!.isNotEmpty ? createChannel : null,
            child: const Text("Erstellen"),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.tag),
                border: InputBorder.none,
              ),
              onChanged: (text) => setState(() => name = text),
            ),
          ),
          const Divider(),
          SwitchListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text('Auf "Geschlossen" setzen'),
            value: !isOpen,
            onChanged: (v) {
              setState(() => isOpen = !v);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
