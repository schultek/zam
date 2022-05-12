part of thebutton_module;

const _theButtonLevels = [
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.red,
  Colors.purple,
  Colors.blue,
];

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

  TheButtonState(
      {Timestamp? lastReset, required this.aliveHours, required this.leaderboard, this.showInAvatars = false})
      : lastReset = lastReset ?? Timestamp.now();

  int get currentLevel {
    var hours = max(0, DateTime.now().difference(lastReset.toDate()).inSeconds / 3600.0);
    return hours >= aliveHours ? -1 : (hours / aliveHours * _theButtonLevels.length).floor();
  }

  Duration get timeUntilValueChanges {
    var hours = DateTime.now().difference(lastReset.toDate()).inSeconds / 3600.0;
    var interval = aliveHours / _theButtonLevels.length;
    return Duration(seconds: ((interval - (hours % interval)) * 3600 + 1).round());
  }
}
