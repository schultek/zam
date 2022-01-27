import 'package:flutter/material.dart';
import '../../../helpers/extensions.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../providers/trips/selected_trip_provider.dart';
import '../widgets/polls_list.dart';
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
      body: const PollsList(),
    );
  }
}
