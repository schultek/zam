import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../auth/user_provider.dart';
import 'trips_provider.dart';

final selectedTripIdProvider = StateProvider<String?>((ref) {
  ref.listen<AsyncValue<List<Trip>>>(tripsProvider, (_, trips) {
    ref.controller.state ??= trips.value?.firstOrNull?.id;
  });

  return ref.read(tripsProvider).value?.firstOrNull?.id;
});

final selectedTripProvider = Provider<Trip?>((ref) {
  var selectedTripId = ref.watch(selectedTripIdProvider);

  var trips = ref.watch(tripsProvider).value;

  if (trips == null || selectedTripId == null) {
    return trips?.firstOrNull;
  } else {
    return trips.where((t) => t.id == selectedTripId).firstOrNull;
  }
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
