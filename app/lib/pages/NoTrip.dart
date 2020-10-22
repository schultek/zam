import 'package:flutter/material.dart';

import 'TripCreate.dart';

class NoTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Neue Freizeit erstellen"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripCreate()));
                },
              ),
            ]),
      ),
    );
  }
}