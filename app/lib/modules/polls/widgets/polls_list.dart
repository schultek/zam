import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../polls_provider.dart';

class PollsList extends StatelessWidget {
  const PollsList({Key? key}) : super(key: key);

  static List<Widget> listBuilder(BuildContext context, [bool needsSurface = false]) {
    var polls = context.watch(pollsProvider).value ?? [];
    polls.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return [for (var poll in polls) PollTile(poll, needsSurface: needsSurface)];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: listBuilder(context, true).intersperse(const SizedBox(height: 10)).toList(),
    );
  }
}

class PollTile extends StatelessWidget {
  final Poll poll;
  final bool needsSurface;
  const PollTile(this.poll, {this.needsSurface = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (needsSurface) {
      return ThemedSurface(builder: (context, color) => buildTile(context, color));
    } else {
      return buildTile(context, null);
    }
  }

  Widget buildTile(BuildContext context, Color? tileColor) {
    var area = WidgetArea.of<ContentSegment>(context);

    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: constraints.hasBoundedWidth
            ? constraints
            : BoxConstraints(maxWidth: min(300, area?.areaSize.width ?? 300) * 0.9),
        child: InkWell(
          onTap: () {
            //Navigator.of(context).push(PollPage.route(game.id));
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
                Text(poll.name, style: TextStyle(color: context.onSurfaceColor)),
                const SizedBox(height: 5),
                Text(
                  'Started ${poll.startedAt.toDateString()}',
                  style: context.theme.textTheme.caption!.copyWith(color: context.onSurfaceColor.withOpacity(0.8)),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
