import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';

import '../../core/module/module.dart';
import '../../models/models.dart';
import '../../providers/links/links_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';

@Module()
class UsersModule {
  @ModuleItem(id: "users")
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
                "Users",
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

  IconData? getIconForUser(String role) {
    if (role == "organizer") {
      return Icons.account_box;
    } else if (role == "leader") {
      return Icons.account_circle;
    } else if (role == "participant") {
      return Icons.account_circle_outlined;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Users", style: Theme.of(context).textTheme.headline5!.copyWith(color: context.getTextColor())),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  var trip = context.read(selectedTripProvider)!;
                  String link = await context.read(linkLogicProvider).createTripInvitationLink(tripId: trip.id);
                  Share.share("Um dich bei dem Ausflug anzumelden, klicke auf den Link: $link");
                },
                child: const Text("Einladungslink für Teilnehmer erstellen"),
              ),
              ElevatedButton(
                onPressed: () async {
                  var trip = context.read(selectedTripProvider)!;
                  String link = await context
                      .read(linkLogicProvider)
                      .createTripInvitationLink(tripId: trip.id, role: UserRoles.Leader);
                  Share.share("Um dich als Leiter bei dem Ausflug anzumelden, klicke auf den Link: $link");
                },
                child: const Text("Einladungslink für Leiter erstellen"),
              ),
              const SizedBox(height: 20),
              Text(
                "Teilnehmerliste",
                style: TextStyle(color: context.getTextColor()),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Consumer(
                  builder: (context, watch, _) {
                    var trip = watch(selectedTripProvider)!;
                    return ListView(
                      children: trip.users.entries
                          .map<Widget>(
                            (e) => ListTile(
                              leading: Icon(getIconForUser(e.value.role), color: context.getTextColor()),
                              title: Text(e.value.nickname ?? e.key, style: TextStyle(color: context.getTextColor())),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
