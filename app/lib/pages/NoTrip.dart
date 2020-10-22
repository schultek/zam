import 'package:flutter/material.dart';
import '../service/AuthService.dart';

import 'TripCreate.dart';

class NoTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: AuthService.hasRole("organizer"),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Neue Freizeit erstellen"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripCreate()));
                      },
                    ),
                  ],
                );
              }
            }
            return Container();



          },
        ),
      ),
    );
  }
}