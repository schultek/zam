import 'package:flutter/material.dart';

import 'chat_repository.dart';

class ChannelPage extends StatefulWidget {
  final ChannelInfo channel;
  const ChannelPage(this.channel) : super();

  static Route route(ChannelInfo channel) {
    return MaterialPageRoute(builder: (context) => ChannelPage(channel));
  }

  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: widget.channel.messages,
              builder: (context, snapshot) {
                print(snapshot.error);
                print(snapshot.data);
                if (snapshot.hasData) {
                  return ListView(
                    children: [
                      for (var msg in snapshot.data!)
                        ListTile(
                          title: Text(msg.text),
                          subtitle: Text(msg.sender),
                        ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              decoration: const InputDecoration(hintText: "Nachricht"),
              onFieldSubmitted: (text) {
                widget.channel.send(text);
              },
            ),
          )
        ],
      ),
    );
  }
}
