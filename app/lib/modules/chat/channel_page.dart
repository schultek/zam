import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/themes/themes.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'chat_provider.dart';

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
            child: Consumer(
              builder: (context, watch, _) {
                var messages = watch(widget.channel.messages);
                var trip = watch(selectedTripProvider)!;

                return messages.when(
                  data: (data) {
                    return ListView(
                      children: [
                        for (var msg in data)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: trip.users[msg.sender]?.profileUrl != null
                                  ? NetworkImage(trip.users[msg.sender]!.profileUrl!)
                                  : null,
                            ),
                            title: Text(
                              msg.text,
                              style: TextStyle(color: context.getTextColor()),
                            ),
                            subtitle: Text(
                              trip.users[msg.sender]?.nickname ?? "Anonym",
                              style: TextStyle(color: context.getTextColor()),
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const Text("Loading"),
                  error: (e, st) => Text("Error $e"),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Nachricht",
                hintStyle: TextStyle(color: context.getTextColor()),
              ),
              style: TextStyle(color: context.getTextColor()),
              onFieldSubmitted: (text) {
                context.read(chatLogicProvider).send(widget.channel.id, text);
              },
            ),
          )
        ],
      ),
    );
  }
}
