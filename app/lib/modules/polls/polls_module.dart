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

  FutureOr<ContentSegment?> buildPoll(ModuleContext context) {
    return context.when(
      withId: (id) => PollCard.segment(context, id),
      withoutId: () => NewPollCard.segment(context),
    );
  }

  FutureOr<QuickAction?> buildNewPollAction(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.add,
      text: context.context.tr.new_poll,
      onNavigate: (context) => const CreatePollPage(),
    );
  }

  FutureOr<ContentSegment?> buildPolls(ModuleContext context) {
    return PollsCard.segment(context);
  }

  FutureOr<ContentSegment?> buildPollsList(ModuleContext context) async {
    var polls = await context.context.read(pollsProvider.future);
    if (polls.isNotEmpty) {
      return ContentSegment.list(
        context: context,
        builder: PollsList.listBuilder,
        spacing: 10,
      );
    }
    return null;
  }
}
