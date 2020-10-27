import 'package:flutter/material.dart';
import 'package:jufa/models/Trip.dart';
import 'package:jufa/service/AuthService.dart';
import 'package:jufa/service/DynamicLinkService.dart';
import 'package:share/share.dart';

class TripHome extends StatelessWidget {
  final Trip trip;
  final String userRole;

  TripHome(this.trip, this.userRole);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(trip.name),
          userRole == UserRoles.Organizer ? ElevatedButton(
            child: Text("Einladungslink für Teilnehmer erstellen"),
            onPressed: () async {
              String link =
                  await DynamicLinkService.createParticipantLink(trip.id);
              Share.share(
                  "Um dich bei der Freizeit anzumelden, klicke auf den Link: $link");
            },
          ) : Container(),

          userRole == UserRoles.Organizer ? ElevatedButton(
            child: Text("Einladungslink für Leiter erstellen"),
            onPressed: () async {
              String link =
              await DynamicLinkService.createLeaderLink(trip.id);
              Share.share(
                  "Um dich als Leiter bei der Freizeit anzumelden, klicke auf den Link: $link");
            },
          ) : Container(),
          Text(userRole),
        ],
      ),
    );
  }
}
