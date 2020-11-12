import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/AppState.dart';
import 'SignIn.dart';
import 'TripCreate.dart';

class NoTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AppState>(
          builder: (BuildContext context, AppState state, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Du hast noch keine Freizeit"),
                state.canCreateTrips
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
      ),
    );
  }
}
