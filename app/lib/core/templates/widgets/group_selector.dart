import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../editing/editing_providers.dart';
import '../../pages/groups_page.dart';
import '../../pages/settings_page.dart';
import '../../themes/themes.dart';

class GroupSelectorButton extends StatelessWidget {
  const GroupSelectorButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: InkResponse(
        child: Icon(Icons.menu_open, color: context.onSurfaceColor),
        onTap: () {
          if (context.read(isEditingProvider)) {
            context.read(editProvider.notifier).toggleEdit();
          }
          Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const SelectGroupPage(),
          ));
        },
      ),
    );
  }
}

class GroupSettingsButton extends StatelessWidget {
  const GroupSettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: InkResponse(
        child: Icon(Icons.settings, color: context.onSurfaceColor, size: 20),
        onTap: () {
          Navigator.push(context, SettingsPage.route());
        },
      ),
    );
  }
}
