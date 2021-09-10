import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/module/module.dart';
import '../chat_provider.dart';
import 'channel/add_channel_page.dart';
import 'channel_page.dart';

class ChatPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var channels = watch(channelsProvider);
    return channels.when(
      data: (data) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, left: 16.0, bottom: 20),
              child: Text('Channels', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            for (var channel in data)
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                leading: const Icon(Icons.tag),
                minLeadingWidth: 0,
                title: Text(
                  channel.name,
                  style: TextStyle(color: context.getTextColor()),
                ),
                onTap: () {
                  Navigator.of(context).push(ChannelPage.route(channel.id));
                },
              ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minLeadingWidth: 0,
              leading: const Icon(Icons.add_box),
              title: Text(
                'Channel hinzufügen',
                style: TextStyle(color: context.getTextColor().withOpacity(0.5)),
              ),
              onTap: () {
                Navigator.of(context).push(AddChannelPage.route());
              },
            )
          ],
        );
      },
      loading: () => const Text('Loading'),
      error: (e, st) => Text('Error $e'),
    );
  }
}
