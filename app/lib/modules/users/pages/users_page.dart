import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:share_plus/share_plus.dart';

import '../users_module.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.users),
        actions: [
          if (context.read(isOrganizerProvider)) ...[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                String? name;
                var userName = await showDialog<String>(
                  context: context,
                  useRootNavigator: false,
                  builder: (BuildContext context) => StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      title: Text(context.tr.add_user),
                      content: TextFormField(
                        decoration: InputDecoration(labelText: context.tr.name),
                        onChanged: (text) => setState(() => name = text),
                      ),
                      actions: [
                        TextButton(
                          child: Text(context.tr.add),
                          onPressed: name != null ? () => Navigator.of(context).pop(name) : null,
                        )
                      ],
                    ),
                  ),
                );
                if (userName != null) {
                  await context.read(tripsLogicProvider).addUser(userName);
                }
              },
            ),
            PopupMenuButton<String>(
              offset: const Offset(0, 56),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(title: Text(context.tr.invite_participant)),
                  value: UserRoles.participant,
                ),
                PopupMenuItem(
                  child: ListTile(title: Text(context.tr.invite_organizer)),
                  value: UserRoles.organizer,
                ),
              ],
              icon: const Icon(Icons.add_link),
              onSelected: (role) async {
                var trip = context.read(selectedTripProvider)!;
                String link = await context.read(linkLogicProvider).createTripInvitationLink(trip: trip, role: role);
                if (role == UserRoles.participant) {
                  Share.share('${context.tr.click_link_to_join(trip.name)}: $link');
                } else if (role == UserRoles.organizer) {
                  Share.share('${context.tr.click_link_to_organize(trip.name)}: $link');
                }
              },
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            var trip = ref.watch(selectedTripProvider)!;
            var organizers = trip.users.entries.where((e) => e.value.role == UserRoles.organizer);
            var participants = trip.users.entries.where((e) => e.value.role != UserRoles.organizer);
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: [
                for (var e in organizers) userTile(context, e),
                const Divider(),
                for (var e in participants) userTile(context, e),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget userTile(BuildContext context, MapEntry<String, TripUser> e) {
    return ListTile(
      leading: UserAvatar(id: e.key),
      title: Text(e.value.nickname ?? context.tr.anonymous, style: TextStyle(color: context.onSurfaceColor)),
      subtitle: Text(e.value.role.capitalize()),
      trailing: context.read(isOrganizerProvider) && e.key != context.read(userIdProvider)
          ? PopupMenuButton<String>(
              offset: const Offset(0, 56),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(title: Text(context.tr.delete)),
                  value: 'delete',
                ),
                if (e.value.role != UserRoles.organizer)
                  PopupMenuItem(
                    child: ListTile(title: Text(context.tr.make_organizer)),
                    value: UserRoles.organizer,
                  )
                else
                  PopupMenuItem(
                    child: ListTile(title: Text(context.tr.remove_organizer)),
                    value: UserRoles.organizer,
                  )
              ],
              icon: const Icon(Icons.more_vert),
              onSelected: (option) async {
                if (option == 'delete') {
                  context.read(tripsLogicProvider).deleteUser(e.key);
                } else if (option == UserRoles.organizer) {
                  if (e.value.role == UserRoles.organizer) {
                    context.read(tripsLogicProvider).updateUserRole(e.key, UserRoles.participant);
                  } else {
                    context.read(tripsLogicProvider).updateUserRole(e.key, UserRoles.organizer);
                  }
                }
              },
            )
          : null,
    );
  }

  static Route route() {
    return MaterialPageRoute(builder: (context) => const UsersPage());
  }
}

extension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
