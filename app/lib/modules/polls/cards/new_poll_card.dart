import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/simple_card.dart';
import '../pages/create_poll_page.dart';

class NewPollCard extends StatelessWidget {
  final ModuleContext module;
  const NewPollCard(this.module, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleCard(title: context.tr.new_poll_create, icon: Icons.add);
  }

  static FutureOr<ContentSegment?> segment(ModuleContext module) {
    if (!module.context.read(isOrganizerProvider)) {
      return null;
    }
    return ContentSegment(
      module: module,
      builder: (_) => NewPollCard(module),
      settings: (context) => [
        ListTile(
          title: Text(context.tr.new_poll_create),
          onTap: () async {
            var pollId = await Navigator.of(context).push(CreatePollPage.route());
            if (pollId != null) {
              module.updateParams(pollId);
            }
          },
        ),
      ],
    );
  }
}
