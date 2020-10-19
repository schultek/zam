import 'package:flutter/material.dart';

class TripCreate extends StatelessWidget {

  String tripName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(

                  labelText: "Freizeit-Name",
                ),
                onSubmitted: (text) {
                  tripName = text;
                },
              ),

              Container(
                height: 20,
              ),

              ElevatedButton(
                child: Text("Erstellen"),
                onPressed: () {
                  print(tripName);
                },
              ),
            ]),
      ),
      ),
    );
  }
}