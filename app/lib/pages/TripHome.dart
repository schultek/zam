import 'package:flutter/material.dart';
import 'package:jufa/service/AuthService.dart';

import '../models/Trip.dart';
import '../modules/Profile.dart';
import '../modules/UserManagementModule.dart';


class TripHome extends StatelessWidget {
  final Trip trip;

  TripHome(this.trip);

  @override
  Widget build(BuildContext context) {
    String userRole = trip.getUserRole();

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(trip.name, style: Theme.of(context).textTheme.headline5),
                Container(height: 20),
                Expanded(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).primaryColor,
                              boxShadow: [BoxShadow(blurRadius: 10)]),
                          height: 100,
                          child: Center(child: Text("UserManagement")),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserManagementModule(trip)));
                        },
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor,
                            boxShadow: [BoxShadow(blurRadius: 10)]),
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(userRole),
                        ),
                      ),
                      GestureDetector(
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(trip.users[AuthService.getUser().uid])));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
