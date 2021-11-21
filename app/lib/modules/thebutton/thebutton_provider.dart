import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/user_provider.dart';
import '../../providers/firebase/doc_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';

@MappableClass()
class TheButtonState {
  Timestamp? lastReset;
  double? aliveHours;
  Map<String, double> leaderboard = {};

  TheButtonState(this.lastReset, this.aliveHours, this.leaderboard);
}

final theButtonProvider = Provider<TheButtonState>((ref) {
  var doc = ref.watch(moduleDocProvider('thebutton'));

  var sub = doc.snapshotsMapped<TheButtonState>().listen((value) {
    ref.state = value;
  });

  ref.onDispose(() => sub.cancel());

  return TheButtonState(null, null, {});
});

final theButtonValueProvider = StreamProvider<double>((ref) async* {
  ref.watch(theButtonProvider);

  var timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    var val = ref.read(theButtonLogicProvider).value;
    if (val != null) {
      ref.state = AsyncValue.data(val);
    }
  });

  ref.onDispose(() => timer.cancel());
});

final theButtonLogicProvider = Provider((ref) => TheButtonLogic(ref));

class TheButtonLogic {
  final Ref ref;
  final DocumentReference<Map<String, dynamic>> doc;
  TheButtonLogic(this.ref) : doc = ref.watch(moduleDocProvider('thebutton'));

  double? get value {
    return getValue(ref.read(theButtonProvider));
  }

  double? getValue(TheButtonState state) {
    if (state.lastReset == null) return null;
    var hours = DateTime.now().difference(state.lastReset!.toDate()).inSeconds / 3600.0;
    return hours >= state.aliveHours! ? 1 : hours / state.aliveHours!;
  }

  bool? get isAlive => value != null ? value! < 1 : null;

  void setAlive(String time) {
    var d = time.split(':');
    int h = int.parse(d[0]);
    int m = d.length == 2 ? int.parse(d[1]) : 0;

    doc.set({'aliveHours': h + m / 60}, SetOptions(merge: true));
  }

  Future<int?> resetState() async {
    int? points;
    await doc.firestore.runTransaction((transaction) async {
      var snapshot = await transaction.get(doc.mapped<TheButtonState>());
      var state = snapshot.data()!;
      var value = getValue(state);
      if (value != null && value < 1) {
        points = (value * 100).floor();
        transaction.set(
          doc,
          {
            'lastReset': Timestamp.now(),
            'leaderboard': {ref.read(userIdProvider): FieldValue.increment(points!)},
          },
          SetOptions(merge: true),
        );
      }
    });
    return points;
  }

  void resetHealth() {
    if (ref.read(isOrganizerProvider)) {
      doc.set({
        'lastReset': Timestamp.now(),
      }, SetOptions(merge: true));
    }
  }

  void resetLeaderboard() {
    if (ref.read(isOrganizerProvider)) {
      doc.set({
        'leaderboard': {},
      }, SetOptions(merge: true));
    }
  }
}
