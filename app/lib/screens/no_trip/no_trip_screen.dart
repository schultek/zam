import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/app_bloc.dart';
import '../create_trip/create_trip_screen.dart';
import '../signin/signin_screen.dart';

class NoTripScreen extends StatefulWidget {
  @override
  _NoTripScreenState createState() => _NoTripScreenState();
}

class _NoTripScreenState extends State<NoTripScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      var state = Provider.of<AppState>(context, listen: false);

      if (state.claims.canCreateTrips) {
        if (state.user!.isAnonymous) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInScreen()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AppState>(
          builder: (BuildContext context, AppState state, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Du hast noch keine Freizeit"),
                if (state.claims.canCreateTrips)
                  state.user!.isAnonymous
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInScreen()));
                          },
                          child: const Text("Jetzt registrieren"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateTripScreen()));
                          },
                          child: const Text("Neue Freizeit erstellen"),
                        )
                else
                  const Text("Erhalte einen Einladungs-Link von deinem Leiter."),
              ],
            );
          },
        ),
      ),
    );
  }
}
