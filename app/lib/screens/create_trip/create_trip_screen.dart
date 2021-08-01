import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/trip_bloc.dart';
import '../../core/templates/templates.dart';
import '../../helpers/locator.dart';
import '../../models/models.dart';
import '../../widgets/ju_background.dart';

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  String? tripName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuBackground(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                "Neuen Ausflug erstellen.",
                style: TextStyle(color: Colors.white, fontSize: 45),
              ),
              const Spacer(
                flex: 3,
              ),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Ausflugsname eingeben",
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        setState(() {
                          tripName = text;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 3,
              ),
              CupertinoCard(
                elevation: 8.0,
                radius: const BorderRadius.all(Radius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    if (tripName == null) return;
                    DocumentReference doc = await createNewTrip(tripName!, locator<AuthBloc>().state.user!.uid);
                    locator<TripBloc>().selectTrip(doc.id);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text(
                        "Erstellen",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  static Future<DocumentReference> createNewTrip(String tripName, String userId) {
    var trip = Trip(
      id: '',
      name: tripName,
      users: {userId: TripUser(role: UserRoles.Organizer)},
      template: SwipeTemplateModel(),
    );
    return FirebaseFirestore.instance.collection("trips").add(trip.toMap());
  }
}
