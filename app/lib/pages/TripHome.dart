import 'package:flutter/material.dart';
import 'package:jufa/models/Trip.dart';
import 'package:jufa/modules/UserManagementModule.dart';
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
          child: Column(children: [
            Text(trip.name, style: Theme.of(context).textTheme.headline5),
            Container(height: 10),
            GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                userRole == UserRoles.Organizer
                    ? GestureDetector(
                        child: Container(
                          child: Text("UserManagementModule"),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserManagementModule(trip)));
                        })
                    : Container(),
                Text(userRole),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
