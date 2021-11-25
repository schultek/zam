import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/core.dart';
import '../../../providers/links/links_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/user_avatar.dart';
import '../widgets/user_options_dialog.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: context.getTextColor(),
        ),
        title: Text('Users', style: TextStyle(color: context.getTextColor())),
        actions: [
          if (context.read(isOrganizerProvider))
            PopupMenuButton<String>(
              offset: const Offset(0, 56),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  child: ListTile(title: Text('Teilnehmer einladen')),
                  value: UserRoles.participant,
                ),
                const PopupMenuItem(
                  child: ListTile(title: Text('Organisator einladen')),
                  value: UserRoles.organizer,
                ),
              ],
              icon: const Icon(Icons.add_link),
              onSelected: (role) async {
                var trip = context.read(selectedTripProvider)!;
                String link = await context.read(linkLogicProvider).createTripInvitationLink(trip: trip, role: role);
                if (role == UserRoles.participant) {
                  Share.share('Um dich bei ${trip.name} anzumelden, klicke auf den Link: $link');
                } else if (role == UserRoles.organizer) {
                  Share.share('Um dich als Organisator bei ${trip.name} anzumelden, klicke auf den Link: $link');
                }
              },
            ),
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
      title: Text(e.value.nickname ?? 'Anonym', style: TextStyle(color: context.getTextColor())),
      subtitle: Text(e.value.role.capitalize()),
      trailing: context.read(isOrganizerProvider)
          ? IconButton(
              onPressed: () {
                UserOptionsDialog.show(context, userId: e.key);
              },
              icon: const Icon(Icons.more_vert),
            )
          : null,
    );
  }
}

extension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
