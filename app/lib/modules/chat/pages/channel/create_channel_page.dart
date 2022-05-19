import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../chat.module.dart';
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

  bool get isValid => name != null && name!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.new_channel),
        actions: [
          ThemedSurface(
            preference: ColorPreference(useHighlightColor: !context.groupTheme.dark),
            builder: (context, _) => TextButton(
              onPressed: isValid ? createChannel : null,
              child: Text(
                context.tr.create,
                style: TextStyle(color: context.onSurfaceHighlightColor.withOpacity(isValid ? 1 : 0.5)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: context.tr.name,
                prefixIcon: const Icon(Icons.tag),
                border: InputBorder.none,
              ),
              onChanged: (text) => setState(() => name = text),
            ),
          ),
          const Divider(),
          SwitchListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(context.tr.set_closed),
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
