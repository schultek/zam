import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jufa/providers/auth/user_provider.dart';

import '../../../providers/trips/selected_trip_provider.dart';
import '../chat_provider.dart';
import 'channel_info_page.dart';

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
      appBar: AppBar(
        title: Text("# ${widget.channel.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(ChannelInfoPage.route(widget.channel));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, watch, _) {
                var messages = watch(widget.channel.messages).data?.value ?? [];
                var trip = watch(selectedTripProvider)!;

                return Chat(
                  theme: const DarkChatTheme(),
                  showUserAvatars: true,
                  showUserNames: true,
                  messages: messages
                      .map((m) => types.TextMessage(
                            author: types.User(
                              id: m.sender,
                              imageUrl: trip.users[m.sender]?.profileUrl,
                              firstName: trip.users[m.sender]?.nickname,
                            ),
                            id: m.text,
                            text: m.text,
                            createdAt: m.sentAt.millisecondsSinceEpoch,
                          ))
                      .toList(),
                  onSendPressed: (types.PartialText t) {
                    context.read(chatLogicProvider).send(widget.channel.id, t.text);
                  },
                  user: types.User(
                    id: context.read(userIdProvider)!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
