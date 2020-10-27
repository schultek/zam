import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/DatabaseService.dart';
import '../service/AuthService.dart';
import '../models/Trip.dart';

import 'NoTrip.dart';
import 'TripHome.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Consumer<AuthService>(
        builder: (BuildContext context, AuthService service, _) {
          return FutureBuilder(
              future: DatabaseService.getTripsForUser(service.user),
              builder: (BuildContext context, AsyncSnapshot<List<Trip>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.isNotEmpty) {
                    return TripHome(snapshot.data.first, service.userRole);
                  } else {
                    return NoTrip();
                  }
                } else {
                  return Container();
                }
              });
        },
      );
  }
}
