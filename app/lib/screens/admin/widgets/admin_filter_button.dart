import 'package:flutter/material.dart';

import '../../../core/core.dart';

class AdminFilterButton<T> extends StatelessWidget {
  const AdminFilterButton({required this.filter, required this.menu, Key? key}) : super(key: key);

  final T? filter;
  final Widget menu;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        showDialog(
          context: context,
          useRootNavigator: false,
          builder: (_) => InheritedTheme.captureAll(
            context,
            GroupTheme(
              theme: context.groupTheme,
              child: menu,
            ),
          ),
        );
      },
    );
  }
}
