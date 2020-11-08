import 'package:flutter/material.dart';
import 'package:jufa/general/Module.dart';
import 'package:jufa/models/Trip.dart';

class Profile extends Module {

  @override
  List<ModuleCard> getCards(ModuleData data) {
    return [
      ModuleCard(
        builder: (context) => GestureDetector(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColor,
                boxShadow: [BoxShadow(blurRadius: 10)]),
            padding: EdgeInsets.all(10),
            child: Center(child: Text("Profil")),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(data.trip.currentUser())));
          },
        ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                onChanged: (text) {
                  user.nickname = text;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
