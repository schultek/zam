import 'package:flutter/material.dart';
import 'package:jufa/models/Trip.dart';
import 'package:jufa/service/AuthService.dart';
import 'package:jufa/service/DynamicLinkService.dart';
import 'package:share/share.dart';

class TripHome extends StatelessWidget {
  final Trip trip;

  TripHome(this.trip);

  @override
  Widget build(BuildContext context) {
    String userRole = trip.getUserRole();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Text(trip.name, style: Theme.of(context).textTheme.headline5),
              Container(height: 10),
              userRole == UserRoles.Organizer
                  ? ElevatedButton(
                      child: Text("Einladungslink für Teilnehmer erstellen"),
                      onPressed: () async {
                        String link = await DynamicLinkService.createParticipantLink(trip.id);
                        Share.share("Um dich bei der Freizeit anzumelden, klicke auf den Link: $link");
                      },
                    )
                  : Container(),
              userRole == UserRoles.Organizer
                  ? ElevatedButton(
                      child: Text("Einladungslink für Leiter erstellen"),
                      onPressed: () async {
                        String link = await DynamicLinkService.createLeaderLink(trip.id);
                        Share.share("Um dich als Leiter bei der Freizeit anzumelden, klicke auf den Link: $link");
                      },
                    )
                  : Container(),
              Text(userRole),
            ],
          ),
        ),
      ),
    );
  }
}
