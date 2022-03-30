part of elimination_module;

@MappableClass()
class EliminationGame {
  final String id;
  final String name;
  final DateTime startedAt;

  final Map<String, String> initialTargets;
  final List<EliminationEntry> eliminations;

  EliminationGame(this.id, this.name, this.startedAt, this.initialTargets, this.eliminations);

  Map<String, String?> get currentTargets {
    var targets = <String, String?>{...initialTargets};
    for (var entry in eliminations) {
      var otherTarget = targets[entry.target];
      targets[entry.target] = null;
      targets[entry.eliminatedBy] = otherTarget;
    }
    return targets;
  }
}

@MappableClass()
class EliminationEntry {
  String target;
  String eliminatedBy;
  String description;
  DateTime time;

  EliminationEntry(this.target, this.eliminatedBy, this.description, this.time);
}
