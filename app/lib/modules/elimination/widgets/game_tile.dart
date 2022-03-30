import 'dart:math';

import 'package:flutter/material.dart';

import '../elimination.module.dart';
import '../pages/game_page.dart';

class GameTile extends StatelessWidget {
  final EliminationGame game;
  final bool needsSurface;
  const GameTile(this.game, {this.needsSurface = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (needsSurface) {
      return ThemedSurface(builder: (context, color) => buildTile(context, color));
    } else {
      return buildTile(context, null);
    }
  }

  Widget buildTile(BuildContext context, Color? tileColor) {
    var curTargets = game.currentTargets;

    var alivePlayers = curTargets.entries.where((e) => e.value != null && e.value != e.key);
    var immortalPlayers = curTargets.entries.where((e) => e.value == e.key);

    var labels = [
      if (immortalPlayers.isNotEmpty) context.tr.immortal,
      if (alivePlayers.isNotEmpty) context.tr.alive,
    ];

    var area = Area.of<ContentElement>(context);

    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: constraints.hasBoundedWidth
            ? constraints
            : BoxConstraints(maxWidth: min(300, area?.areaSize.width ?? 300) * 0.9),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(GamePage.route(game.id));
          },
          child: Container(
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(game.name, style: TextStyle(color: context.onSurfaceColor)),
                const SizedBox(height: 5),
                Text(
                  '${context.tr.started} ${game.startedAt.toDateString()}',
                  style: context.theme.textTheme.caption!.copyWith(color: context.onSurfaceColor.withOpacity(0.8)),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var player in immortalPlayers) ...[
                        UserAvatar(id: player.key),
                        const SizedBox(width: 8),
                      ],
                      if (immortalPlayers.isNotEmpty && alivePlayers.isNotEmpty) ...[
                        const VerticalDivider(),
                        const SizedBox(width: 8),
                      ],
                      for (var player in alivePlayers) ...[
                        UserAvatar(id: player.key),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(labels.join(' | '), style: TextStyle(color: context.onSurfaceColor.withOpacity(0.7))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
