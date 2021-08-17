import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/themes.dart';
import '../../thebutton/widgets/clip_layer.dart';
import '../../thebutton/widgets/expand_clipper.dart';
import '../game_provider.dart';

class EliminationStats extends StatefulWidget {
  final String id;
  const EliminationStats(this.id, {required Key key}) : super(key: key);

  @override
  _EliminationStatsState createState() => _EliminationStatsState();
}

class _EliminationStatsState extends State<EliminationStats> {
  bool statsOpen = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          statsButton(context, constraints),
          statsPage(constraints),
        ],
      ),
    );
  }

  Widget statsButton(BuildContext context, BoxConstraints constraints) {
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        visualDensity: VisualDensity.compact,
        icon: Icon(Icons.leaderboard, size: 20, color: context.getTextColor()),
        onPressed: () => setState(() {
          statsOpen = true;
        }),
      ),
    );
  }

  Widget statsPage(BoxConstraints constraints) {
    return ClipLayer(
      matchColor: true,
      corner: Corner.topRight,
      isOpen: statsOpen,
      child: Stack(
        children: [
          statsLayer(),
          closeButton(),
        ],
      ),
    );
  }

  Widget statsLayer() {
    return Positioned.fill(
      child: Consumer(
        builder: (context, watch, _) {
          var game = watch(gameProvider(widget.id));

          var curTargets = game.data!.value.currentTargets;
          var players = curTargets.length;
          var alive = curTargets.entries.where((e) => e.value != null).length;

          return Padding(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 10),
            child: Column(
              children: [
                Text(
                  'Statistics',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(color: context.getTextColor()),
                ),
                const Spacer(),
                Text(
                  '$alive/$players alive',
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.headline6!.copyWith(color: context.getTextColor()),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget closeButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: Builder(
        builder: (context) => IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.close, size: 20, color: context.getTextColor()),
          onPressed: () {
            setState(() {
              statsOpen = false;
            });
          },
        ),
      ),
    );
  }
}
