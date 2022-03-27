import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import 'cards/new_poll_card.dart';
import 'cards/poll_card.dart';
import 'cards/polls_card.dart';
import 'pages/create_poll_page.dart';
import 'polls_provider.dart';
import 'widgets/polls_list.dart';

class PollsModule extends ModuleBuilder {
  PollsModule() : super('polls');

  @override
  String getName(BuildContext context) => context.tr.polls;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        // 'poll': buildPoll,
        // 'new_poll_action': buildNewPollAction,
        // 'polls': buildPolls,
        // 'polls_list': buildPollsList,
      };

  FutureOr<ContentSegment?> buildPoll(ModuleContext module) {
    if (module.hasParams) {
      var pollId = module.getParams<String>();
      return PollCard.segment(module, pollId);
    } else {
      return NewPollCard.segment(module);
    }
  }

  FutureOr<QuickAction?> buildNewPollAction(ModuleContext module) {
    return QuickAction(
      module: module,
      icon: Icons.add,
      text: module.context.tr.new_poll,
      onNavigate: (context) => const CreatePollPage(),
    );
  }

  FutureOr<ContentSegment?> buildPolls(ModuleContext module) {
    return PollsCard.segment(module);
  }

  FutureOr<ContentSegment?> buildPollsList(ModuleContext module) async {
    var polls = await module.context.read(pollsProvider.future);
    if (polls.isNotEmpty) {
      return ContentSegment.list(
        module: module,
        builder: PollsList.listBuilder,
        spacing: 10,
      );
    }
    return null;
  }
}
