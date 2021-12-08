import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../thebutton_provider.dart';
import '../widgets/clip_layer.dart';

class LeaderboardEntry {
  String name;
  int level;
  LeaderboardEntry(this.name, this.level);
}

final theButtonLeaderboardProvider = Provider.autoDispose((ref) {
  var state = ref.watch(theButtonProvider).value;
  var trip = ref.watch(selectedTripProvider);
  return (state?.leaderboard ?? {})
      .entries
      .map((e) => LeaderboardEntry(trip?.users[e.key]?.nickname ?? 'Anonym', e.value.round()))
      .toList()
    ..sort((a, b) => b.level.compareTo(a.level));
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
            icon: Icon(Icons.help, size: 20, color: context.onSurfaceHighlightColor),
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
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              Text(
                'The Button',
                style: context.theme.textTheme.bodyText2!.copyWith(color: context.onSurfaceColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'A social game where you have to keep the button alive.',
                style: context.theme.textTheme.caption!.apply(color: context.onSurfaceColor, fontSizeFactor: 0.9),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => setState(() => instructionsOpen = true),
                child: AutoSizeText(
                  'How to play?',
                  style: TextStyle(color: context.onSurfaceColor),
                  minFontSize: 8,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 5),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => setState(() => leaderboardOpen = true),
                child: AutoSizeText(
                  'Leaderboard',
                  style: TextStyle(color: context.onSurfaceColor),
                  maxLines: 1,
                  minFontSize: 8,
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
                'How to play',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.subtitle2!.copyWith(color: context.onSurfaceColor),
              ),
              const SizedBox(height: 10),
              Text(
                "The main goal is to never let the button die. The button will slowly loose health until it's dead. You can heal the button anytime while it is still alive by tapping on it for two seconds. But once it's dead, it can never be brought back, so stay alert.",
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.caption!.copyWith(color: context.onSurfaceColor),
              ),
              const SizedBox(height: 10),
              Text(
                'The buttons health is synchronized across all players, so it is a group efford to keep it alive.',
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.caption!.copyWith(color: context.onSurfaceColor),
              ),
              const SizedBox(height: 10),
              Text(
                "When you save the button from its demise, you will get it's level. The lower the buttons health is the higher is level you get. But don't wait too long, someone else might just come along and save the button before you have the chance.",
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.caption!.copyWith(color: context.onSurfaceColor),
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
          builder: (context, ref, _) => ListView(
            padding: const EdgeInsets.only(bottom: 10),
            physics: const BouncingScrollPhysics(),
            children: [
              Text(
                'Leaderboard',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.subtitle2!.copyWith(color: context.onSurfaceColor),
              ),
              const SizedBox(height: 12),
              for (var entry in ref.watch(theButtonLeaderboardProvider)) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Text(
                        entry.name,
                        style: context.theme.textTheme.bodyText1!.copyWith(color: context.onSurfaceColor),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, color: getColorForLevel(entry.level, context)),
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
          icon: Icon(Icons.close, size: 20, color: context.onSurfaceColor),
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
