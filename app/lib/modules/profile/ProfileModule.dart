import 'package:flutter/material.dart';

import '../../general/module/Module.dart';
import '../../models/Trip.dart';

class Profile extends Module {
  @override
  List<ModuleCard> getCards(ModuleData data) {
    return [
      ModuleCard("profile",
        builder: (context) => Container(
          padding: EdgeInsets.all(10),
          child: Center(child: Text("Profil")),
        ),
        onNavigate: (context) => ProfilePage(data.trip.currentUser()),
      ),
    ];
  }
}

class ProfilePage extends StatelessWidget {
  final TripUser user;

  ProfilePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                onChanged: (text) {
                  user.nickname = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}