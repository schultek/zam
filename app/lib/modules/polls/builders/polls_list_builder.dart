import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../polls.module.dart';
import '../widgets/poll_tile.dart';

class PollsListBuilder {
  PollsListBuilder([this.needsSurface = false]);

  final bool needsSurface;

  List<Widget> call(BuildContext context) {
    var polls = context.watch(pollsProvider).value ?? [];
    polls.sort((a, b) => b.startedAt.compareTo(a.startedAt));

    return [
      for (var poll in polls) //
        PollTile(poll, needsSurface: needsSurface),
    ];
  }
}
