import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/AppState.dart';
import 'SignIn.dart';
import 'TripCreate.dart';

class NoTrip extends StatefulWidget {
  @override
  _NoTripState createState() => _NoTripState();
}

class _NoTripState extends State<NoTrip> {

  bool isInit = false;

  @override
  Widget build(BuildContext context) {

    if (!this.isInit) {
      this.isInit = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var state = Provider.of<AppState>(context, listen: false);

        if (state.claims.canCreateTrips) {
          if (state.user.isAnonymous) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterPhoneNumber()));
          }
        }
      });
    }

    return Center(
      child: Consumer<AppState>(
        builder: (BuildContext context, AppState state, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Du hast noch keine Freizeit"),
              state.claims.canCreateTrips
                  ? state.user.isAnonymous
                      ? ElevatedButton(
                          child: Text("Jetzt registrieren"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterPhoneNumber()));
                          },
                        )
                      : ElevatedButton(
                          child: Text("Neue Freizeit erstellen"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripCreate()));
                          },
                        )
                  : Text("Erhalte einen Einladungs-Link von deinem Leiter."),
            ],
          );
        },
      ),
    );
  }
}
