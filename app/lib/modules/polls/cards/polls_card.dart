import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../widgets/simple_card.dart';
import '../pages/polls_page.dart';

class PollsCard extends StatelessWidget {
  const PollsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleCard(title: context.tr.polls, icon: Icons.list);
  }

  static FutureOr<ContentSegment?> segment(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => const PollsCard(),
      onNavigate: (context) => const PollsPage(),
    );
  }
}
