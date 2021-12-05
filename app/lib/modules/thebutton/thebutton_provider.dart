import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/firebase/doc_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';

const _theButtonLevels = [Colors.green, Colors.yellow, Colors.orange, Colors.red, Colors.purple, Colors.blue];

final theButtonLevelsCount = _theButtonLevels.length;

Color getColorForLevel(int level, BuildContext context) {
  return Color.alphaBlend(context.theme.primaryColorLight.withAlpha(60), _theButtonLevels[level]);
}

@MappableClass()
class TheButtonState {
  Timestamp lastReset;
  double aliveHours;
  Map<String, int> leaderboard = {};
  bool showInAvatars;

  TheButtonState(this.lastReset, this.aliveHours, this.leaderboard, {this.showInAvatars = false});

  int get currentLevel {
    var hours = DateTime.now().difference(lastReset.toDate()).inSeconds / 3600.0;
    return hours >= aliveHours ? -1 : (hours / aliveHours * _theButtonLevels.length).floor();
  }

  Duration get timeUntilValueChanges {
    var hours = DateTime.now().difference(lastReset.toDate()).inSeconds / 3600.0;
    var interval = aliveHours / _theButtonLevels.length;
    return Duration(seconds: ((interval - (hours % interval)) * 3600 + 1).round());
  }
}

final theButtonProvider = StreamProvider<TheButtonState?>((ref) {
  var doc = ref.watch(moduleDocProvider('thebutton'));
  return doc.snapshotsMapped<TheButtonState?>();
});

final theButtonLevelProvider = Provider.autoDispose<int>((ref) {
  var state = ref.watch(theButtonProvider).value;

  if (state == null) {
    return -1;
  }

  Timer? timer;
  int updateLevel() {
    var level = state.currentLevel;
    if (level != -1) {
      timer = Timer(state.timeUntilValueChanges, () => ref.state = updateLevel());
    }
    return level;
  }

  ref.onDispose(() => timer?.cancel());

  return updateLevel();
});

final theButtonUserLevelProvider = Provider.family<int?, String?>((ref, userId) {
  var state = ref.watch(theButtonProvider).value;
  if (state == null) {
    return null;
  } else {
    return state.leaderboard[userId];
  }
});

final theButtonLogicProvider = Provider((ref) => TheButtonLogic(ref));

class TheButtonLogic {
  final Ref ref;
  final DocumentReference<Map<String, dynamic>> doc;
  TheButtonLogic(this.ref) : doc = ref.watch(moduleDocProvider('thebutton'));

  Future<void> init() async {
    await doc.mapped<TheButtonState>().set(TheButtonState(Timestamp.now(), 2, {}));
  }

  void setAliveHours(String time) {
    var d = time.split(':');
    int h = int.parse(d[0]);
    int m = d.length == 2 ? int.parse(d[1]) : 0;

    doc.set({'aliveHours': h + m / 60}, SetOptions(merge: true));
  }

  Future<void> resetState() async {
    await doc.firestore.runTransaction((transaction) async {
      var snapshot = await transaction.get(doc.mapped<TheButtonState>());
      var state = snapshot.data()!;
      var level = state.currentLevel;
      if (level != -1) {
        var userId = ref.read(userIdProvider);
        transaction.set(
          doc,
          {
            'lastReset': Timestamp.now(),
            'leaderboard': {userId: max(level, state.leaderboard[userId] ?? 0)},
          },
          SetOptions(merge: true),
        );
      }
    });
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

  Future<void> setShowInAvatars(bool showInAvatars) async {
    if (ref.read(isOrganizerProvider)) {
      await doc.set({
        'showInAvatars': showInAvatars,
      }, SetOptions(merge: true));
    }
  }
}
