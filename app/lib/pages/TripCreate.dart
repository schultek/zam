import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/AppState.dart';
import '../service/DatabaseService.dart';

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
                onChanged: (text) {
                  tripName = text;
                },
              ),
              Container(
                height: 20,
              ),
              ElevatedButton(
                child: Text("Erstellen"),
                onPressed: () async {
                  var state = Provider.of<AppState>(context, listen: false);
                  DocumentReference doc = await DatabaseService.createNewTrip(tripName, state.user.uid);
                  state.selectTrip(doc.id);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
