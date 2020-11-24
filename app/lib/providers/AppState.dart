import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../models/Trip.dart';
import '../service/AuthService.dart';

class AppState with ChangeNotifier {
  User user;
  UserClaims claims = UserClaims();
  List<Trip> trips = [];
  String selectedTripId;

  StreamSubscription<User> _userSubscription;
  StreamSubscription<QuerySnapshot> _tripsSubscription;

  static AppState instance;

  AppState() {
    instance = this;
  }

  getSelectedTrip() {
    return this.trips.firstWhere((trip) => trip.id == this.selectedTripId, orElse: () => null);
  }

  @override
  void dispose() {
    super.dispose();
    if (this._userSubscription != null) {
      this._userSubscription.cancel();
    }
    if (this._tripsSubscription != null) {
      this._tripsSubscription.cancel();
    }
  }

  selectTrip(String tripId) {
    this.selectedTripId = tripId;
    this.notifyListeners();
  }

  Future<void> updateTripsListener() async {
    if (this._tripsSubscription != null) {
      this._tripsSubscription.cancel();
    }

    var stream = this.claims.isAdmin
        ? FirebaseFirestore.instance.collection("trips").snapshots()
        : FirebaseFirestore.instance
            .collection("trips")
            .where("users.${user.uid}.role", whereIn: [UserRoles.Participant, UserRoles.Leader, UserRoles.Organizer]).snapshots();

    this._tripsSubscription = stream.listen((snapshot) {
      this.trips = snapshot.docs.map((doc) => Trip.fromDocument(doc)).toList();
      this.selectedTripId = this.trips.length > 0 ? this.trips.first.id : null;
      this.notifyListeners();
    });

    await stream.first;
  }

  initUserSubscription() {
    if (this._userSubscription != null) {
      this._userSubscription.cancel();
    }
    this._userSubscription = FirebaseAuth.instance.userChanges().listen((user) {
      this.updateUser(user);
    });
  }

  Future<void> updateUser(User user) async {
    var userChanged = (this.user == null || this.user.uid != user.uid);
    this.user = user;
    if (userChanged) {
      var claimsChanged = await this.updateUserClaims(false);
      if (!claimsChanged) {
        await this.updateTripsListener();
      }
    }
    this.notifyListeners();
  }

  Future<bool> updateUserClaims(bool forceRefresh) async {
    var result = await user.getIdTokenResult(forceRefresh);

    print(result.claims);

    var canCreateTrips = result.claims["canCreateTrips"] ?? false;
    var isAdmin = result.claims["isAdmin"] ?? false;

    var claimsChanged = this.claims.canCreateTrips != canCreateTrips || this.claims.isAdmin != isAdmin;

    this.claims.canCreateTrips = canCreateTrips;
    this.claims.isAdmin = isAdmin;

    if (claimsChanged) {
      await this.updateTripsListener();
      this.notifyListeners();
    }

    return claimsChanged;
  }
}

class UserClaims {
  bool canCreateTrips = false;
  bool isAdmin = false;
}
