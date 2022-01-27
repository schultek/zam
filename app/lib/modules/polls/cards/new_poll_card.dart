import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/simple_card.dart';
import '../pages/create_poll_page.dart';

class NewPollCard extends StatelessWidget {
  final IdProvider idProvider;
  const NewPollCard(this.idProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var pollId = await Navigator.of(context).push(CreatePollPage.route());
        if (pollId != null) {
          idProvider.provide(context, pollId);
        }
      },
      child: SimpleCard(title: context.tr.new_poll_create, icon: Icons.add),
    );
  }

  static FutureOr<ContentSegment?> segment(ModuleContext context) {
    if (!context.context.read(isOrganizerProvider)) {
      return null;
    }
    var idProvider = IdProvider();
    return ContentSegment(context: context, idProvider: idProvider, builder: (context) => NewPollCard(idProvider));
  }
}
