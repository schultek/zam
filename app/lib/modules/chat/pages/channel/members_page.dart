import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../chat.module.dart';

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
        title: Text(context.tr.members),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          var group = ref.watch(selectedGroupProvider);
          var users = group!.users.entries.where((e) => widget.channel.members.contains(e.key)).toList();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: users.length,
            itemBuilder: (context, index) => ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text(users[index].value.nickname ?? context.tr.anonymous),
              leading: UserAvatar(id: users[index].key),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
