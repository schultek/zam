import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../widgets/simple_card.dart';

class PollCard extends StatelessWidget {
  final String id;
  const PollCard(this.id, {Key? key}) : super(key: key);

  static FutureOr<ContentSegment?> segment(ModuleContext context, String id) {
    return ContentSegment(
      context: context,
      builder: (context) => PollCard(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleCard(title: 'Poll\n$id', icon: Icons.add_reaction);
  }
}
