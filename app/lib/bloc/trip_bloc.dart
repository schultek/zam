import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/locator.dart';
import '../helpers/optional.dart';
import '../models/models.dart';
import 'auth_bloc.dart';

extension BlocChanges<T> on BlocBase<T> {
  Stream<Change<T>> get changes {
    var currState = state;
    return stream.map((nextState) {
      var change = Change(currentState: currState, nextState: nextState);
      currState = nextState;
      return change;
    });
  }
}

class TripBloc extends Cubit<TripState> {
  StreamSubscription<Change<AuthState>>? _authChangesSubscription;
  StreamSubscription<QuerySnapshot>? _tripsSubscription;

  TripBloc() : super(TripState.initial()) {
    _authChangesSubscription = locator<AuthBloc>().changes.listen((change) {
      if (change.currentState.user?.uid != change.nextState.user?.uid) {
        if (change.nextState.user != null) {
          _updateTripsListener(change.nextState);
        } else {
          _tripsSubscription?.cancel();
          _tripsSubscription = null;
          emit(state.copyWith(trips: [], selectedTripId: Optional(null)));
        }
      } else if (change.currentState.claims.isAdmin != change.nextState.claims.isAdmin) {
        _updateTripsListener(change.nextState);
      }
    });
    _updateTripsListener(locator<AuthBloc>().state);
  }

  @override
  Future<void> close() async {
    _authChangesSubscription?.cancel();
    _tripsSubscription?.cancel();
    await super.close();
  }

  void selectTrip(String tripId) {
    emit(state.copyWith(selectedTripId: Optional(tripId)));
  }

  void _updateTripsListener(AuthState authState) {
    _tripsSubscription?.cancel();
    print("UPDATE TRIPS");

    var query = authState.claims.isAdmin
        ? FirebaseFirestore.instance.collection("trips")
        : FirebaseFirestore.instance.collection("trips").where("users.${authState.user?.uid}.role",
            whereIn: [UserRoles.Participant, UserRoles.Leader, UserRoles.Organizer]);

    _tripsSubscription = query.snapshots().listen((snapshot) {
      var trips = snapshot.toList<Trip>();
      print("TRIPS $trips");
      emit(state.copyWith(
        trips: trips,
        selectedTripId: Optional(trips.isNotEmpty ? trips.first.id : null),
      ));
    });
  }
}

class TripState {
  final List<Trip>? trips;
  final String? selectedTripId;

  TripState({
    this.trips,
    this.selectedTripId,
  });

  factory TripState.initial() {
    return TripState();
  }

  Trip? get selectedTrip {
    if (selectedTripId == null || trips == null) {
      return null;
    }
    for (var trip in trips!) {
      if (trip.id == selectedTripId) return trip;
    }
  }

  TripState copyWith({
    List<Trip>? trips,
    Optional<String>? selectedTripId,
  }) {
    return TripState(
      trips: trips ?? this.trips,
      selectedTripId: selectedTripId != null ? selectedTripId.value : this.selectedTripId,
    );
  }
}

extension TripContext on BuildContext {
  Trip? get trip => locator<TripBloc>().state.selectedTrip;
  String? get tripId => locator<TripBloc>().state.selectedTripId;

  Future<void> updateTrip(Map<String, dynamic> data) async {
    if (tripId == null) return;
    await FirebaseFirestore.instance.collection("trips").doc(tripId).update(data);
  }
}
