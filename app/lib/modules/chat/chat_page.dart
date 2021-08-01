import 'package:flutter/material.dart';

import '../../core/module/module.dart';
import 'channel_page.dart';
import 'chat_repository.dart';

class ChatPage extends StatelessWidget {
  final ModuleData moduleData;
  const ChatPage(this.moduleData) : super();

  @override
  Widget build(BuildContext context) {
    var repo = ChatRepository(moduleData);
    return StreamBuilder<List<ChannelInfo>>(
      stream: repo.channels,
      builder: (context, snapshot) {
        print(snapshot.data);
        print(snapshot.error);
        if (snapshot.hasData) {
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40, left: 16.0, bottom: 20),
                child: Text("Channels"),
              ),
              for (var channel in snapshot.data!)
                Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (DismissDirection direction) {
                    repo.delete(channel.id);
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
                              repo.addChannel(text);
                              Navigator.pop(context);
                            },
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: name != null
                                  ? () {
                                      repo.addChannel(name!);
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
        } else {
          return Container();
        }
      },
    );
  }
}
