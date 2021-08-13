import 'package:cached_network_image/cached_network_image.dart';
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
        iconTheme: IconThemeData(
          color: context.getTextColor(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Users", style: Theme.of(context).textTheme.headline5!.copyWith(color: context.getTextColor())),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer(
                  builder: (context, watch, _) {
                    var trip = watch(selectedTripProvider)!;
                    return ListView(
                      children: trip.users.entries
                          .map<Widget>(
                            (e) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    e.value.profileUrl != null ? CachedNetworkImageProvider(e.value.profileUrl!) : null,
                              ),
                              title: Text(e.value.nickname ?? e.key, style: TextStyle(color: context.getTextColor())),
                              subtitle: Text(e.value.role),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 20),
                  Flexible(
                    fit: FlexFit.tight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: context.getTextColor(),
                        onPrimary: context.getFillColor(),
                      ),
                      onPressed: () async {
                        var trip = context.read(selectedTripProvider)!;
                        String link = await context.read(linkLogicProvider).createTripInvitationLink(tripId: trip.id);
                        Share.share("Um dich bei dem Ausflug anzumelden, klicke auf den Link: $link");
                      },
                      child: const Text("Teilnehmer einladen"),
                    ),
                  ),
                  const SizedBox(width: 20),
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
                            .createTripInvitationLink(tripId: trip.id, role: UserRoles.Leader);
                        Share.share("Um dich als Leiter bei dem Ausflug anzumelden, klicke auf den Link: $link");
                      },
                      child: const Text("Leiter einladen"),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
