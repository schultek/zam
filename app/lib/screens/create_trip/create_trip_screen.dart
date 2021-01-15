// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../service/database_service.dart';

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  String? tripName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Freizeit-Name",
                ),
                onChanged: (text) {
                  setState(() {
                    tripName = text;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (tripName == null) return;
                  var state = Provider.of<AppState>(context, listen: false);
                  DocumentReference doc = await DatabaseService.createNewTrip(tripName!, state.user!.uid);
                  state.selectTrip(doc.id);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Erstellen"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
