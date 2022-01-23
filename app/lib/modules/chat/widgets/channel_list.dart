import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../chat_provider.dart';
import '../pages/channel/add_channel_page.dart';
import '../pages/channel_page.dart';

class ChannelList extends StatelessWidget {
  const ChannelList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var channels = context.watch(channelsProvider);
    return channels.when(
      data: (data) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 16.0, bottom: 20),
              child: Text(context.tr.channels, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            for (var channel in data)
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                leading: const Icon(Icons.tag),
                minLeadingWidth: 0,
                title: Text(
                  channel.name,
                  style: TextStyle(color: context.onSurfaceColor),
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
                context.tr.add_channel,
                style: TextStyle(color: context.onSurfaceColor.withOpacity(0.5)),
              ),
              onTap: () {
                Navigator.of(context).push(AddChannelPage.route());
              },
            )
          ],
        );
      },
      loading: () => Text(context.tr.loading),
      error: (e, st) => Text('${context.tr.error}: $e'),
    );
  }
}
