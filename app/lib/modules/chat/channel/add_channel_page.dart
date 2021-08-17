import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/themes.dart';
import '../chat_provider.dart';
import 'channel_page.dart';
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
        title: const Text('Channels'),
      ),
      body: Consumer(
        builder: (context, watch, _) {
          var channelsToJoin = watch(channelsToJoinProvider);
          return channelsToJoin.when(
            data: (channels) => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: channels.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(channels[index].name),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                leading: const Icon(Icons.tag),
                minLeadingWidth: 0,
                onTap: () async {
                  await context.read(chatLogicProvider).joinChannel(channels[index]);
                  Navigator.of(context).pushReplacement(ChannelPage.route(channels[index]));
                },
              ),
              separatorBuilder: (context, _) => const Divider(),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (e, st) => Text('Error $e'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(CreateChannelPage.route());
        },
        backgroundColor: context.getTextColor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
