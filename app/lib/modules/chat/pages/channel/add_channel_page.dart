import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../chat.module.dart';
import '../channel_page.dart';
import 'create_channel_page.dart';

class AddChannelPage extends StatefulWidget {
  const AddChannelPage({Key? key}) : super(key: key);

  @override
  _AddChannelPageState createState() => _AddChannelPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const AddChannelPage());
  }
}

class _AddChannelPageState extends State<AddChannelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.channels),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          var channelsToJoin = ref.watch(channelsToJoinProvider);
          return channelsToJoin.when(
            data: (channels) => ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: [
                for (var channel in channels)
                  ThemedSurface(
                    builder: (context, color) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(channel.name),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        tileColor: color,
                        leading: const Icon(Icons.tag),
                        minLeadingWidth: 0,
                        onTap: () async {
                          var nav = Navigator.of(context);
                          await ref.read(chatLogicProvider).joinChannel(channel);
                          nav.pushReplacement(ChannelPage.route(channel.id));
                        },
                      ),
                    ),
                  ),
                ThemedSurface(
                  builder: (context, color) => ListTile(
                    title: Text(context.tr.new_channel),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: color,
                    leading: const Icon(Icons.add_box),
                    minLeadingWidth: 0,
                    onTap: () async {
                      Navigator.of(context).pushReplacement(CreateChannelPage.route());
                    },
                  ),
                ),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
            error: (e, st) => Text('${context.tr.error}: $e'),
          );
        },
      ),
    );
  }
}
