import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/themes.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../thebutton_provider.dart';
import '../widgets/clip_layer.dart';

class LeaderboardEntry {
  String name;
  int points;
  LeaderboardEntry(this.name, this.points);
}

final theButtonLeaderboardProvider = Provider.autoDispose((ref) {
  var state = ref.watch(theButtonProvider);
  var trip = ref.watch(selectedTripProvider);
  return state.leaderboard.entries
      .map((e) => LeaderboardEntry(trip?.users[e.key]?.nickname ?? 'Anonym', e.value.round()))
      .toList()
        ..sort((a, b) => b.points.compareTo(a.points));
});

class TheButtonHelp extends StatefulWidget {
  const TheButtonHelp({required Key key}) : super(key: key);

  @override
  _TheButtonHelpState createState() => _TheButtonHelpState();
}

class _TheButtonHelpState extends State<TheButtonHelp> {
  bool helpOpen = false;
  bool instructionsOpen = false;
  bool leaderboardOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.help, size: 20, color: context.getTextColor()),
            onPressed: () => setState(() => helpOpen = true),
          ),
        ),
        ClipLayer(
          isOpen: helpOpen,
          matchColor: true,
          child: Stack(
            children: [
              helpLayer(),
              howToPlayLayer(),
              leaderboardLayer(),
              closeButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget helpLayer() {
    return Positioned.fill(
      child: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "The Button",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: context.getTextColor()),
              ),
              Text(
                "The Button is a social game where you have to keep the button alive.",
                style: Theme.of(context).textTheme.caption!.copyWith(color: context.getTextColor()),
                textAlign: TextAlign.center,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => setState(() => instructionsOpen = true),
                child: Text(
                  "How to play?",
                  style: TextStyle(color: context.getTextColor()),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => setState(() => leaderboardOpen = true),
                child: Text(
                  "Leaderboard",
                  style: TextStyle(color: context.getTextColor()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget howToPlayLayer() {
    return ClipLayer(
      isOpen: instructionsOpen,
      child: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 10),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 10),
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                "How to play",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: context.getTextColor()),
              ),
              const SizedBox(height: 10),
              Text(
                "The main goal is to never let the button die. The button will slowly loose health until it's dead. You can heal the button anytime while it is still alive by tapping on it for two seconds. But once it's dead, it can never be brought back, so stay alert.",
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.caption!.copyWith(color: context.getTextColor()),
              ),
              const SizedBox(height: 10),
              Text(
                "The buttons health is synchronized across all players, so it is a group efford to keep it alive.",
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.caption!.copyWith(color: context.getTextColor()),
              ),
              const SizedBox(height: 10),
              Text(
                "You will receive points when you save the button from its demise. The lower the buttons health is the more points you get. But don't wait too long, someone else might just come along and save the button before you have the chance.",
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.caption!.copyWith(color: context.getTextColor()),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget leaderboardLayer() {
    return ClipLayer(
      isOpen: leaderboardOpen,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 10),
        child: Consumer(
          builder: (context, watch, _) => ListView(
            padding: const EdgeInsets.only(bottom: 10),
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                "Leaderboard",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: context.getTextColor()),
              ),
              const SizedBox(height: 12),
              for (var entry in watch(theButtonLeaderboardProvider)) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Text(
                        entry.name,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: context.getTextColor()),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Text(
                        "${entry.points} P",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: context.getTextColor()),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget closeButton() {
    return Positioned(
      top: 0,
      left: 0,
      child: Builder(
        builder: (context) => IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.close, size: 20, color: context.getTextColor()),
          onPressed: () {
            setState(() {
              helpOpen = false;
              instructionsOpen = false;
              leaderboardOpen = false;
            });
          },
        ),
      ),
    );
  }
}
