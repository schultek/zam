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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                    height: 100,
                    color: Colors.white,
                    child: Center(child: Text("UserManagement")),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserManagementModule(trip)));
                  },
                ),
                Container(
                    height: 100,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(userRole),
                    )),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}
