import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/module/module.dart';
import 'channel_page.dart';
import 'chat_provider.dart';

class ChatPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var channels = watch(channelsProvider);
    return channels.when(
      data: (data) {
        return ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, left: 16.0, bottom: 20),
              child: Text("Channels"),
            ),
            for (var channel in data)
              Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (DismissDirection direction) {
                  context.read(chatLogicProvider).delete(channel.id);
                },
                key: ValueKey(channel.id),
                child: ListTile(
                  title: Text(
                    "# ${channel.name}",
                    style: TextStyle(color: context.getTextColor()),
                  ),
                  onTap: () {
                    Navigator.of(context).push(ChannelPage.route(channel));
                  },
                ),
              ),
            ListTile(
              title: Text("Channel Hinzufügen", style: TextStyle(color: context.getTextColor().withOpacity(0.5))),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String? name;
                    return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                        title: const Text("Neuer Channel"),
                        content: TextFormField(
                          decoration: const InputDecoration(hintText: "Name"),
                          onChanged: (text) => setState(() => name = text),
                          autofocus: true,
                          onFieldSubmitted: (text) {
                            context.read(chatLogicProvider).addChannel(text);
                            Navigator.pop(context);
                          },
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: name != null
                                ? () {
                                    context.read(chatLogicProvider).addChannel(name!);
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: const Text("Erstellen"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          ],
        );
      },
      loading: () => const Text("Loading"),
      error: (e, st) => Text("Error $e"),
    );
  }
}
