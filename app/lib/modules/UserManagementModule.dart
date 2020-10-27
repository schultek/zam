import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../service/DynamicLinkService.dart';
import '../models/Trip.dart';

class UserManagementModule extends StatelessWidget{
  final Trip trip;

  UserManagementModule(this.trip);

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Text(trip.name, style: Theme.of(context).textTheme.headline5),
              Container(height: 10),
              ElevatedButton(
                child: Text("Einladungslink für Teilnehmer erstellen"),
                onPressed: () async {
                  String link = await DynamicLinkService.createParticipantLink(trip.id);
                  Share.share("Um dich bei der Freizeit anzumelden, klicke auf den Link: $link");
                },
              ),
              ElevatedButton(
                child: Text("Einladungslink für Leiter erstellen"),
                onPressed: () async {
                  String link = await DynamicLinkService.createLeaderLink(trip.id);
                  Share.share("Um dich als Leiter bei der Freizeit anzumelden, klicke auf den Link: $link");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
