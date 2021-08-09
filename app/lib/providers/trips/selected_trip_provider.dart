import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../auth/user_provider.dart';
import '../helpers.dart';
import 'trips_provider.dart';

final selectedTripIdProvider = StateNotifierProvider<IdNotifier, String?>((ref) => IdNotifier(ref));

class IdNotifier extends StateNotifier<String?> {
  late StreamSubscription<List<Trip>> _tripsSubscription;

  IdNotifier(ProviderReference ref) : super(null) {
    _tripsSubscription = ref.watch(tripsProvider.stream).listen((trips) {
      state ??= trips.firstOrNull?.id;
    });
  }

  String? get id => state;
  set id(String? id) => state = id;

  @override
  void dispose() {
    _tripsSubscription.cancel();
    super.dispose();
  }
}

final selectedTripProvider = StateNotifierProvider<StreamNotifier<Trip?>, Trip?>((ref) {
  var selectedTripIdStream = ref.watch(selectedTripIdProvider.notifier).stream;
  var tripsStream = ref.watch(tripsProvider.stream);
  Trip? get(String? id, List<Trip>? trips) => trips?.where((t) => t.id == id).firstOrNull ?? trips?.firstOrNull;
  return StreamNotifier.from(
    CombinedStream(selectedTripIdStream, tripsStream, get),
    initialValue: get(ref.read(selectedTripIdProvider), ref.read(tripsProvider).data?.value),
  );
});

final tripUserProvider = Provider<TripUser?>((ref) {
  var userId = ref.watch(userIdProvider);
  if (userId == null) return null;

  var selectedTrip = ref.watch(selectedTripProvider);
  if (selectedTrip == null) return null;

  return selectedTrip.users[userId];
});
