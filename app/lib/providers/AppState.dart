import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../models/Trip.dart';
import '../service/AuthService.dart';

class AppState with ChangeNotifier {

  User user;
  bool canCreateTrips = false;
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
    this._userSubscription.cancel();
    if (this._tripsSubscription != null) {
      this._tripsSubscription.cancel();
    }
  }

  selectTrip(String tripId) {
    this.selectedTripId = tripId;
    this.notifyListeners();
  }

  Future<void> updateTripsListener(String userId) async {
    if (this._tripsSubscription != null) {
      this._tripsSubscription.cancel();
    }

    var stream = FirebaseFirestore.instance
      .collection("trips").where("users.$userId.role", whereIn: [UserRoles.Participant, UserRoles.Leader, UserRoles.Organizer])
      .snapshots();
    
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
    var updatePermissions = false;
    if (this.user == null || this.user.uid != user.uid) {
      await this.updateTripsListener(user.uid);
      updatePermissions = true;
    }
    this.user = user;
    if (updatePermissions) {
      await this.updateUserPermissions(false);
    }
    this.notifyListeners();
  }

  Future<void> updateUserPermissions(bool forceRefresh) async {
    var result = await user.getIdTokenResult(forceRefresh);
    this.canCreateTrips = result.claims["canCreateTrips"] ?? false;
    this.notifyListeners();
  }

}