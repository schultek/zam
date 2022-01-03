import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import 'cards/new_poll_card.dart';
import 'cards/poll_card.dart';
import 'cards/polls_card.dart';
import 'pages/create_poll_page.dart';
import 'polls_provider.dart';
import 'widgets/polls_list.dart';

class PollModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return context.when(
      withId: (id) => PollCard.segment(context, id),
      withoutId: () => NewPollCard.segment(context),
    );
  }
}

class NewPollActionModule extends ModuleBuilder<QuickAction> {
  @override
  FutureOr<QuickAction?> build(ModuleContext context) {
    return QuickAction(
      context: context,
      icon: Icons.add,
      text: 'New Poll',
      onNavigate: (context) => const CreatePollPage(),
    );
  }
}

class PollsModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) {
    return PollsCard.segment(context);
  }
}

class PollsListModule extends ModuleBuilder<ContentSegment> {
  @override
  FutureOr<ContentSegment?> build(ModuleContext context) async {
    var polls = await context.context.read(pollsProvider.future);
    if (polls.isNotEmpty) {
      return ContentSegment.list(
        context: context,
        builder: PollsList.listBuilder,
        spacing: 10,
      );
    }
  }
}
