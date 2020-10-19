import 'package:flutter/material.dart';

class TripAdd extends StatelessWidget {
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
                  print("Höhö");
                },
              ),
              ElevatedButton(
                child: Text("Freizeit beitreten"),
                onPressed: () {
                  print("Hähä");
                },
              ),
            ]),
      ),
    );
  }
}