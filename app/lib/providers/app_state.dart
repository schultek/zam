import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../models/models.dart';

class AppState with ChangeNotifier {
  User? user;
  UserClaims claims = UserClaims();
  List<Trip> trips = [];
  String? selectedTripId;

  StreamSubscription<User>? _userSubscription;
  StreamSubscription<QuerySnapshot>? _tripsSubscription;

  static late AppState instance;

  AppState() {
    instance = this;
  }

  Trip? getSelectedTrip() {
    return trips.map<Trip?>((t) => t).firstWhere((trip) => trip!.id == selectedTripId, orElse: () => null);
  }

  @override
  void dispose() {
    super.dispose();
    _userSubscription?.cancel();
    _tripsSubscription?.cancel();
  }

  void selectTrip(String tripId) {
    selectedTripId = tripId;
    notifyListeners();
  }

  Future<void> updateTripsListener() async {
    _tripsSubscription?.cancel();

    var stream = claims.isAdmin
        ? FirebaseFirestore.instance.collection("trips").snapshots()
        : FirebaseFirestore.instance.collection("trips").where("users.${user?.uid}.role",
            whereIn: [UserRoles.Participant, UserRoles.Leader, UserRoles.Organizer]).snapshots();

    _tripsSubscription = stream.listen((snapshot) {
      trips = snapshot.docs.map((doc) => Trip.fromMap(doc.toMap())).toList();
      selectedTripId = trips.isNotEmpty ? trips.first.id : null;
      notifyListeners();
    });

    await stream.first;
  }

  void initUserSubscription() {
    _userSubscription?.cancel();
    _userSubscription = FirebaseAuth.instance.userChanges().listen((user) {
      updateUser(user);
    });
  }

  Future<void> updateUser(User user) async {
    var userChanged = this.user == null || this.user!.uid != user.uid;
    this.user = user;
    if (userChanged) {
      var claimsChanged = await updateUserClaims(false);
      if (!claimsChanged) {
        await updateTripsListener();
      }
    }
    notifyListeners();
  }

  Future<bool> updateUserClaims(bool forceRefresh) async {
    var result = await user!.getIdTokenResult(forceRefresh);

    print(result.claims);

    bool canCreateTrips = result.claims["canCreateTrips"] as bool? ?? false;
    bool isAdmin = result.claims["isAdmin"] as bool? ?? false;

    var claimsChanged = claims.canCreateTrips != canCreateTrips || claims.isAdmin != isAdmin;

    claims.canCreateTrips = canCreateTrips;
    claims.isAdmin = isAdmin;

    if (claimsChanged) {
      await updateTripsListener();
      notifyListeners();
    }

    return claimsChanged;
  }
}

class UserClaims {
  bool canCreateTrips = false;
  bool isAdmin = false;
}
