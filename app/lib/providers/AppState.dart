import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../models/Trip.dart';
import '../service/AuthService.dart';

class AppState with ChangeNotifier {
  User user;
  Trip trip;
  List<Trip> trips = [];
  bool canCreateTrips = false;

  static AppState instance;
  AppState() {
    instance = this;
  }

  void updateUser(User user) {
    this.user = user;
    this.notifyListeners();
  }

  Future<void> updateUserPermissions() async {
    var result = await AuthService.getUser().getIdTokenResult(true);
    canCreateTrips = result.claims["canCreateTrips"] ?? false;
    this.notifyListeners();
  }

  Future<void> updateUserAndUserPermissions(User user) async {
    this.user = user;
    var result = await user.getIdTokenResult(true);
    canCreateTrips = result.claims["canCreateTrips"] ?? false;
    this.notifyListeners();
  }

  Future<void> updateTrip(String id) async {
    var document = await FirebaseFirestore.instance.collection("trips").doc(id).get();
    trip = Trip.fromDocument(document);
    trips.add(trip);
    this.notifyListeners();
  }

  void updateTrips(List<Trip> trips) {
    this.trips = trips;
    this.notifyListeners();
  }
}