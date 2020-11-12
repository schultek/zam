import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Trip.dart';
import 'AuthService.dart';

class DatabaseService {

  static Future<DocumentReference> createNewTrip(String tripName) {
    return FirebaseFirestore.instance.collection("trips").add({
      "name": tripName,
      "users": {AuthService.getUser().uid: {"role": UserRoles.Organizer}},
    });
  }

  static Future<List<Trip>> getTripsForUser(User user) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("trips").where("users.${user.uid}.role", whereIn: [UserRoles.Participant, UserRoles.Leader, UserRoles.Organizer]).get();
    List<Trip> trips = List();
    for (QueryDocumentSnapshot doc in query.docs) {
      trips.add(Trip.fromDocument(doc));
    }
    return trips;
  }
}
