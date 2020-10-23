import 'package:flutter/material.dart';
import 'package:jufa/models/Trip.dart';
import 'package:jufa/service/DynamicLinkService.dart';
import 'package:share/share.dart';

class TripHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(trip.name),
          ElevatedButton(
            child: Text("Einladungslink für Teilnehmer erstellen"),
            onPressed: () async {
              String link =
                  await DynamicLinkService.createParticipantLink(trip.id);
              Share.share(
                  "Um dich bei der Freizeit anzumelden, klicke auf den Link: $link");
            },
          ),
        ],
      ),
    );
  }
}
