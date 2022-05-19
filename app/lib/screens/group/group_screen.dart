import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/groups/selected_group_provider.dart';
import '../loading/loading_screen.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var group = context.watch(selectedGroupProvider);
    if (group != null) {
      return group.template.builder();
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        context.read(selectedGroupIdProvider.notifier).state = null;
      });
      return const LoadingScreen();
    }
  }
}
