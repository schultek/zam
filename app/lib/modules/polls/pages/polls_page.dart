import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../builders/polls_list_builder.dart';
import '../polls.module.dart';
import 'create_poll_page.dart';

class PollsPage extends StatelessWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.polls),
        actions: [
          if (context.read(isOrganizerProvider))
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, CreatePollPage.route());
              },
            )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: PollsListBuilder(true)(context) //
            .intersperse(const SizedBox(height: 10))
            .toList(),
      ),
    );
  }
}
