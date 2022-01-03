import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../auth/user_provider.dart';
import '../general/preferences_provider.dart';
import 'trips_provider.dart';

final selectedTripIdProvider = StateNotifierProvider<TripIdNotifier, String?>((ref) {
  var prefs = ref.watch(sharedPreferencesProvider).value;
  var initialState = prefs?.getString('selected_trip_id');

  return TripIdNotifier(ref, initialState);
});

class TripIdNotifier extends StateNotifier<String?> {
  final Ref ref;

  TripIdNotifier(this.ref, String? initialState) : super(initialState);

  SharedPreferences? get prefs => ref.read(sharedPreferencesProvider).value;

  @override
  set state(String? value) {
    if (value != null) {
      prefs?.setString('selected_trip_id', value);
    } else {
      prefs?.remove('selected_trip_id');
    }
    super.state = value;
  }
}

final selectedTripProvider = Provider<Trip?>((ref) {
  var selectedTripId = ref.watch(selectedTripIdProvider);

  var trips = ref.watch(tripsProvider);
  var trip = trips.value?.where((t) => t.id == selectedTripId).firstOrNull;

  return trip;
});

final tripUserProvider = Provider<TripUser?>((ref) {
  var userId = ref.watch(userIdProvider);
  if (userId == null) return null;

  var selectedTrip = ref.watch(selectedTripProvider);
  if (selectedTrip == null) return null;

  return selectedTrip.users[userId];
});

final isOrganizerProvider = Provider((ref) => ref.watch(tripUserProvider)?.isOrganizer ?? false);

final tripUserByIdProvider = Provider.family((ref, String id) => ref.watch(selectedTripProvider)?.users[id]);
final nicknameProvider = Provider.family((ref, String id) => ref.watch(tripUserByIdProvider(id))?.nickname);
