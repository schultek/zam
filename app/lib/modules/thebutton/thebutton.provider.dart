part of thebutton_module;

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
    doc.set({'aliveHours': optionToValue(time)}, SetOptions(merge: true));
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

double optionToValue(String option) {
  var d = option.split(':');
  int h = int.parse(d[0]);
  int m = d.length == 2 ? int.parse(d[1]) : 0;
  return h + m / 60;
}

String valueToOption(double value) {
  var h = value.floor().toString();
  var m = ((value * 60) % 60).floor().toString();
  return '$h${m != '0' ? ':$m' : ''}';
}
