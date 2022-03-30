import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../thebutton.module.dart';
import '../widgets/clip_layer.dart';

class LeaderboardEntry {
  String? name;
  int level;
  LeaderboardEntry(this.name, this.level);
}

final theButtonLeaderboardProvider = Provider.autoDispose((ref) {
  var state = ref.watch(theButtonProvider).value;
  var group = ref.watch(selectedGroupProvider);
  return (state?.leaderboard ?? {})
      .entries
      .map((e) => LeaderboardEntry(group?.users[e.key]?.nickname, e.value.round()))
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
                context.tr.the_button,
                style: context.theme.textTheme.bodyText2!.copyWith(color: context.onSurfaceColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                context.tr.the_button_tagline,
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
                  context.tr.how_to_play,
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
                  context.tr.leaderboard,
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
                context.tr.how_to_play,
                textAlign: TextAlign.center,
                style: context.theme.textTheme.subtitle2!.copyWith(color: context.onSurfaceColor),
              ),
              const SizedBox(height: 10),
              Text(
                context.tr.the_button_description,
                textAlign: TextAlign.justify,
                style: context.theme.textTheme.caption!.copyWith(color: context.onSurfaceColor),
              ),
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
                context.tr.leaderboard,
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
                        entry.name ?? context.tr.anonymous,
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
