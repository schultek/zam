import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../providers/groups/selected_group_provider.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var group = context.watch(selectedGroupProvider)!;
    return group.template.builder();
  }
}
