import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../general/Module.dart';
import '../../service/DynamicLinkService.dart';
import '../../models/Trip.dart';

class UsersModule extends Module {
  @override
  List<ModuleCard> getCards(ModuleData data) {
    return [
      ModuleCard(
        builder: (context) => GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Center(child: Text("Users")),
          ),
          onTap: () {
            Navigator.of(context).push(ModulePageRoute(context, child: UsersPage(data.trip)));
          },
        ),
      ),
    ];
  }
}

class UsersPage extends StatelessWidget {
  final Trip trip;

  UsersPage(this.trip);

  IconData getIconForUser(String role) {
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Container(
                height: 20,
              ),
              Text("Teilnehmerliste"),
              Container(
                height: 5,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: ListView(
                    children: trip.users.entries
                        .map<Widget>(
                          (e) => ListTile(
                            leading: Icon(getIconForUser(e.value.role)),
                            title: Text(e.key),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
