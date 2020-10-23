import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../models/Trip.dart';
import 'AuthService.dart';

class DatabaseService with ChangeNotifier {
  Trip trip;

  static DatabaseService instance;
  DatabaseService() {
    instance = this;
  }

  Future<void> updateTrip(String id) async {
    var document =
        await FirebaseFirestore.instance.collection("trips").doc(id).get();
    trip = Trip.fromDocument(document);
    this.notifyListeners();
  }

  static Future<DocumentReference> createNewTrip(String tripName) {
    return FirebaseFirestore.instance.collection("trips").add({
      "name": tripName,
      "users": [AuthService.getUser().uid],
    });
  }

  static Future<List<Trip>> getTripsForUser(User user) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("trips").where("users", arrayContains: user.uid).get();
    List<Trip> trips = List();
    for (QueryDocumentSnapshot doc in query.docs) {
      trips.add(Trip.fromDocument(doc));
    }
    return trips;
  }
}
