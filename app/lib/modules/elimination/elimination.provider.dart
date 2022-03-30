part of elimination_module;

final gamesProvider = StreamProvider(
    (ref) => ref.watch(moduleDocProvider('elimination')).collection('games').snapshotsMapped<EliminationGame>());

final gameProvider = StreamProvider.family((ref, String id) =>
    ref.watch(moduleDocProvider('elimination')).collection('games').doc(id).snapshotsMapped<EliminationGame>());

final gameLogicProvider = Provider((ref) => GameLogic(ref));

class GameLogic {
  final Ref ref;
  final DocumentReference doc;
  GameLogic(this.ref) : doc = ref.watch(moduleDocProvider('elimination'));

  Future<EliminationGame> createGame(String name, bool allowLoops) async {
    var gameDoc = doc.collection('games').doc();
    var game = EliminationGame(gameDoc.id, name, DateTime.now(), _generateTargetMap(allowLoops), []);
    await gameDoc.set(game.toMap());
    return game;
  }

  Map<String, String> _generateTargetMap(bool allowLoops) {
    var userIds = [...ref.read(selectedTripProvider)!.users.keys];

    if (userIds.length == 1) {
      return {userIds.first: userIds.first};
    }

    var possibleTargets = [...userIds];

    var rand = Random();
    var targets = <String, String>{};

    String randId(String not) {
      var i = rand.nextInt(possibleTargets.length);
      var id = possibleTargets[i];
      if (id == not) {
        return randId(not);
      }
      if (!allowLoops && id == possibleTargets.first) {
        return randId(not);
      }
      return id;
    }

    var nextIndex = 0;

    while (userIds.length > 2) {
      var id = userIds.removeAt(nextIndex);

      var target = randId(id);
      possibleTargets.remove(target);
      targets[id] = target;

      if (!allowLoops) {
        nextIndex = userIds.indexOf(target);
      }
    }

    int firstTargetIndex;
    if (possibleTargets.contains(userIds.first)) {
      firstTargetIndex = 1 - possibleTargets.indexOf(userIds.first);
    } else if (possibleTargets.contains(userIds.last)) {
      firstTargetIndex = possibleTargets.indexOf(userIds.last);
    } else {
      firstTargetIndex = rand.nextInt(1);
    }

    targets[userIds.first] = possibleTargets[firstTargetIndex];
    targets[userIds.last] = possibleTargets[1 - firstTargetIndex];

    return targets;
  }

  Future<void> addEliminationEntry(String id, EliminationEntry entry) async {
    await doc.collection('games').doc(id).update({
      'eliminations': FieldValue.arrayUnion([entry.toMap()]),
    });
  }

  Future<void> deleteGame(String id) async {
    await doc.collection('games').doc(id).delete();
  }
}
