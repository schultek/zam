import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/user_provider.dart';
import '../../providers/firebase/doc_provider.dart';
import '../../providers/helpers.dart';
import '../../providers/trips/selected_trip_provider.dart';

class TheButtonState {
  DateTime? lastReset;
  double? aliveHours;
  Map<String, double> leaderboard = {};

  TheButtonState(this.lastReset, this.aliveHours, this.leaderboard);
  // TODO make mappable
}

final theButtonProvider = StateNotifierProvider<StreamNotifier<TheButtonState>, TheButtonState>((ref) {
  return StreamNotifier.from(
    ref.watch(moduleDocProvider('thebutton')).snapshots().map((s) => TheButtonState(
          (s.data()?["lastReset"] as Timestamp?)?.toDate() ?? DateTime.now(),
          (s.data()?["aliveHours"] ?? 0.1) * 1.0 as double?,
          (s.data()?["leaderboard"] as Map<String, dynamic>? ?? {})
              .map((key, value) => MapEntry(key, (value as num).toDouble())),
        )),
    initialValue: TheButtonState(null, null, {}),
  );
});

final theButtonValueProvider = StreamProvider<double>((ref) {
  ref.watch(theButtonProvider);
  return Stream.periodic(const Duration(seconds: 1), (_) => ref.read(theButtonLogicProvider).value)
      .where((v) => v != null)
      .cast<double>();
});

final theButtonLogicProvider = Provider((ref) => TheButtonLogic(ref));

class TheButtonLogic {
  final ProviderReference ref;
  final DocumentReference doc;
  TheButtonLogic(this.ref) : doc = ref.watch(moduleDocProvider('thebutton'));

  double? get value {
    var state = ref.read(theButtonProvider);
    if (state.lastReset == null) return null;
    var hours = DateTime.now().difference(state.lastReset!).inSeconds / 3600.0;
    return hours >= state.aliveHours! ? 1 : hours / state.aliveHours!;
  }

  bool? get isAlive => value != null ? value! < 1 : null;

  void setAlive(String time) {
    var d = time.split(":");
    int h = int.parse(d[0]);
    int m = d.length == 2 ? int.parse(d[1]) : 0;

    doc.set({"aliveHours": h + m / 60}, SetOptions(merge: true));
  }

  void resetState() {
    if (isAlive ?? false) {
      doc.set({
        "lastReset": Timestamp.now(),
        "leaderboard": {
          ref.read(userIdProvider): FieldValue.increment((value! * 100).floor()),
        },
      }, SetOptions(merge: true));
    }
  }

  void resetHealth() {
    if (ref.read(isOrganizerProvider)) {
      doc.set({
        "lastReset": Timestamp.now(),
      }, SetOptions(merge: true));
    }
  }

  void resetLeaderboard() {
    if (ref.read(isOrganizerProvider)) {
      doc.set({
        "leaderboard": {},
      }, SetOptions(merge: true));
    }
  }
}
