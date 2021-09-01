import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/trips/selected_trip_provider.dart';
import '../../chat_provider.dart';

class MembersPage extends StatefulWidget {
  final ChannelInfo channel;
  const MembersPage(this.channel, {Key? key}) : super(key: key);

  @override
  _MembersPageState createState() => _MembersPageState();

  static Route route(ChannelInfo channel) {
    return MaterialPageRoute(builder: (context) => MembersPage(channel));
  }
}

class _MembersPageState extends State<MembersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mitglieder'),
      ),
      body: Consumer(
        builder: (context, watch, _) {
          var trip = watch(selectedTripProvider);
          var users = trip!.users.entries.where((e) => widget.channel.members.contains(e.key)).toList();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: users.length,
            itemBuilder: (context, index) => ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text(users[index].value.nickname ?? 'Anonym'),
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: users[index].value.profileUrl != null
                    ? CachedNetworkImageProvider(users[index].value.profileUrl!)
                    : null,
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
