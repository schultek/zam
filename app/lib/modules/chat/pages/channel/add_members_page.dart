import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/trips/selected_trip_provider.dart';
import '../../chat_provider.dart';

class AddMembersPage extends StatefulWidget {
  final ChannelInfo channel;
  const AddMembersPage(this.channel, {Key? key}) : super(key: key);

  @override
  _AddMembersPageState createState() => _AddMembersPageState();

  static Route route(ChannelInfo channel) {
    return MaterialPageRoute(builder: (context) => AddMembersPage(channel));
  }
}

class _AddMembersPageState extends State<AddMembersPage> {
  Map<String, bool> shouldAddUser = {};

  List<String> get selectedUsers => shouldAddUser.entries.where((e) => e.value).map((e) => e.key).toList();

  Future<void> addMembers() async {
    await context.read(chatLogicProvider).addMembers(widget.channel.id, selectedUsers);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mitglieder hinzufügen'),
        actions: [
          TextButton(
            onPressed: selectedUsers.isNotEmpty ? addMembers : null,
            child: const Text('Hinzufügen'),
          )
        ],
      ),
      body: Consumer(
        builder: (context, watch, _) {
          var trip = watch(selectedTripProvider);
          var users = trip!.users.entries.where((e) => !widget.channel.members.contains(e.key)).toList();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: users.length,
            itemBuilder: (context, index) => CheckboxListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              value: shouldAddUser[users[index].key] ?? false,
              onChanged: (v) {
                setState(() => shouldAddUser = {...shouldAddUser, users[index].key: v ?? false});
              },
              title: Text(users[index].value.nickname ?? 'Anonym'),
              controlAffinity: ListTileControlAffinity.trailing,
              secondary: CircleAvatar(
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
