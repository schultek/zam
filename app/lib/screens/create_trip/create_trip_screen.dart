import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/app_bloc.dart';
import '../../models/models.dart';

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
                  var bloc = context.read<AppBloc>();
                  DocumentReference doc = await createNewTrip(tripName!, bloc.state.user!.uid);
                  bloc.selectTrip(doc.id);
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

  static Future<DocumentReference> createNewTrip(String tripName, String userId) {
    return FirebaseFirestore.instance.collection("trips").add({
      "name": tripName,
      "users": {
        userId: {"role": UserRoles.Organizer}
      },
    });
  }
}
