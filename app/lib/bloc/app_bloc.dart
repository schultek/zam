import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/locator.dart';
import '../helpers/optional.dart';
import '../models/models.dart';

class AppBloc extends Cubit<AppState> {
  StreamSubscription<User?>? _userSubscription;
  StreamSubscription<QuerySnapshot>? _tripsSubscription;

  AppBloc(User user) : super(AppState.initial(user)) {
    _userSubscription = FirebaseAuth.instance.userChanges().listen((user) {
      updateUser(user);
    });
    updateUserClaims(false);
  }

  @override
  Future<void> onChange(Change<AppState> change) async {
    super.onChange(change);
    if (change.currentState.user?.uid != change.nextState.user?.uid) {
      if (change.nextState.user != null) {
        await updateUserClaims(false);
        updateTripsListener();
      } else {
        _tripsSubscription?.cancel();
        _tripsSubscription = null;
      }
    } else if (change.currentState.claims.isAdmin != change.nextState.claims.isAdmin) {
      updateTripsListener();
    }
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    _tripsSubscription?.cancel();
    await super.close();
  }

  void selectTrip(String tripId) {
    emit(state.copyWith(selectedTripId: Optional(tripId)));
  }

  Future<void> updateTripsListener() async {
    _tripsSubscription?.cancel();

    var stream = state.claims.isAdmin
        ? FirebaseFirestore.instance.collection("trips").snapshots()
        : FirebaseFirestore.instance.collection("trips").where("users.${state.user?.uid}.role",
            whereIn: [UserRoles.Participant, UserRoles.Leader, UserRoles.Organizer]).snapshots();

    _tripsSubscription = stream.listen((snapshot) {
      print(snapshot.docs.map((d) => d.data()));
      var trips = snapshot.toList<Trip>();
      emit(state.copyWith(
        trips: trips,
        selectedTripId: Optional(trips.isNotEmpty ? trips.first.id : null),
      ));
    });
  }

  Future<void> updateUser(User? user) async {
    emit(state.copyWith(user: Optional(user)));
  }

  Future<void> updateUserClaims(bool forceRefresh) async {
    var result = await state.user!.getIdTokenResult(forceRefresh);

    bool canCreateTrips = result.claims?["canCreateTrips"] as bool? ?? false;
    bool isAdmin = result.claims?["isAdmin"] as bool? ?? false;

    emit(state.copyWith(
      claims: UserClaims(
        canCreateTrips: canCreateTrips,
        isAdmin: isAdmin,
      ),
    ));
  }
}

class AppState {
  final User? user;
  final UserClaims claims;
  final List<Trip> trips;
  final String? selectedTripId;

  AppState({
    this.user,
    this.claims = const UserClaims(),
    this.trips = const [],
    this.selectedTripId,
  });

  factory AppState.initial(User user) {
    return AppState(user: user);
  }

  Trip? getSelectedTrip() {
    return trips.map<Trip?>((t) => t).firstWhere((trip) => trip!.id == selectedTripId, orElse: () => null);
  }

  AppState copyWith({
    Optional<User>? user,
    UserClaims? claims,
    List<Trip>? trips,
    Optional<String>? selectedTripId,
  }) {
    return AppState(
      user: user != null ? user.value : this.user,
      claims: claims ?? this.claims,
      trips: trips ?? this.trips,
      selectedTripId: selectedTripId != null ? selectedTripId.value : this.selectedTripId,
    );
  }
}

class UserClaims {
  final bool canCreateTrips;
  final bool isAdmin;

  const UserClaims({
    this.canCreateTrips = false,
    this.isAdmin = false,
  });
}

extension TripContext on BuildContext {
  Trip? get trip => locator<AppBloc>().state.getSelectedTrip();
  String? get tripId => locator<AppBloc>().state.selectedTripId;

  Future<void> updateTrip(Map<String, dynamic> data) async {
    if (tripId == null) return;
    await FirebaseFirestore.instance.collection("trips").doc(tripId).update(data);
  }
}
