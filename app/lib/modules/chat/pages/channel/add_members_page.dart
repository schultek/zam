import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../chat.module.dart';

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
        title: Text(context.tr.add_members),
        actions: [
          TextButton(
            onPressed: selectedUsers.isNotEmpty ? addMembers : null,
            child: Text(context.tr.add),
          )
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          var group = ref.watch(selectedGroupProvider);
          var users = group!.users.entries.where((e) => !widget.channel.members.contains(e.key)).toList();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: users.length,
            itemBuilder: (context, index) => CheckboxListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              value: shouldAddUser[users[index].key] ?? false,
              onChanged: (v) {
                setState(() => shouldAddUser = {...shouldAddUser, users[index].key: v ?? false});
              },
              title: Text(users[index].value.nickname ?? context.tr.anonymous),
              controlAffinity: ListTileControlAffinity.trailing,
              secondary: UserAvatar(id: users[index].key),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
