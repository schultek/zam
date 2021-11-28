import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/simple_card.dart';
import '../pages/create_game_page.dart';

class NewGameCard extends StatelessWidget {
  final IdProvider idProvider;
  const NewGameCard(this.idProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var gameId = await Navigator.of(context).push(CreateGamePage.route());
        if (gameId != null) {
          idProvider.provide(context, gameId);
        }
      },
      child: const SimpleCard(title: 'New game\n(Tap to setup)', icon: Icons.add),
    );
  }

  static FutureOr<ContentSegment?> segment(ModuleContext context) {
    if (!context.context.read(isOrganizerProvider)) {
      return null;
    }
    var idProvider = IdProvider();
    return ContentSegment(context: context, idProvider: idProvider, builder: (context) => NewGameCard(idProvider));
  }
}
