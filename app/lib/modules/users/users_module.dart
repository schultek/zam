import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';

import '../../core/module/module.dart';
import '../../models/models.dart';
import '../../providers/links/links_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../../widgets/user_avatar.dart';
import 'widgets/user_options_dialog.dart';

@Module('users')
class UsersModule {
  @ModuleItem('users')
  ContentSegment getUsers() {
    return ContentSegment(
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.supervised_user_circle,
                color: context.getTextColor(),
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'Users',
                style: Theme.of(context).textTheme.headline6!.copyWith(color: context.getTextColor()),
              ),
            ],
          ),
        ),
      ),
      onNavigate: (context) => const UsersPage(),
    );
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage();

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
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Consumer(
                builder: (context, watch, _) {
                  var trip = watch(selectedTripProvider)!;
                  var organizers = trip.users.entries.where((e) => e.value.role == UserRoles.Organizer);
                  var participants = trip.users.entries.where((e) => e.value.role != UserRoles.Organizer);
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
            if (context.read(isOrganizerProvider))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 10),
                    Flexible(
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: context.getTextColor(),
                          onPrimary: context.getFillColor(),
                        ),
                        onPressed: () async {
                          var trip = context.read(selectedTripProvider)!;
                          String link = await context.read(linkLogicProvider).createTripInvitationLink(trip: trip);
                          Share.share('Um dich bei ${trip.name} anzumelden, klicke auf den Link: $link');
                        },
                        child: const Text(
                          'Teilnehmer\neinladen',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: context.getTextColor(),
                          onPrimary: context.getFillColor(),
                        ),
                        onPressed: () async {
                          var trip = context.read(selectedTripProvider)!;
                          String link = await context
                              .read(linkLogicProvider)
                              .createTripInvitationLink(trip: trip, role: UserRoles.Leader);
                          Share.share('Um dich als Leiter bei ${trip.name} anzumelden, klicke auf den Link: $link');
                        },
                        child: const Text(
                          'Leiter\neinladen',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: context.getTextColor(),
                          onPrimary: context.getFillColor(),
                        ),
                        onPressed: () async {
                          var trip = context.read(selectedTripProvider)!;
                          String link = await context
                              .read(linkLogicProvider)
                              .createTripInvitationLink(trip: trip, role: UserRoles.Organizer);
                          Share.share(
                              'Um dich als Organisator bei ${trip.name} anzumelden, klicke auf den Link: $link');
                        },
                        child: const Text(
                          'Organisator\neinladen',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
          ],
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
