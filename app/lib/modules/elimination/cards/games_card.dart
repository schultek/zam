import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../widgets/simple_card.dart';
import '../pages/games_page.dart';

class GamesCard extends StatelessWidget {
  const GamesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleCard(title: context.tr.elimination, icon: Icons.list);
  }

  static FutureOr<ContentSegment?> segment(ModuleContext context) {
    return ContentSegment(
      context: context,
      builder: (context) => const GamesCard(),
      onNavigate: (context) => const GamesPage(),
    );
  }
}
