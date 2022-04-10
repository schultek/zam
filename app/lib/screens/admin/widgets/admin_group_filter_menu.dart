import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../providers/admin_groups_provider.dart';

class AdminGroupFilterMenu extends StatefulWidget {
  const AdminGroupFilterMenu({Key? key}) : super(key: key);

  @override
  State<AdminGroupFilterMenu> createState() => _AdminGroupFilterMenuState();
}

class _AdminGroupFilterMenuState extends State<AdminGroupFilterMenu> {
  GroupFilter? filter;

  @override
  void initState() {
    super.initState();
    filter = context.read(adminGroupFilterProvider)?.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsDialog(
      title: const Text('Group Filters'),
      content: SettingsSection(
        backgroundOpacity: 0.5,
        children: [
          ListTile(
            title: const Text('Has User'),
            subtitle: Text(filter?.hasUser ?? 'None'),
            trailing: filter?.hasUser != null
                ? IconButton(
                    icon: Icon(Icons.delete, color: context.theme.errorColor),
                    onPressed: () {
                      setState(() {
                        filter!.hasUser = null;
                      });
                    },
                  )
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Clear'),
          onPressed: filter != null
              ? () {
                  context.read(adminGroupFilterProvider.notifier).state = null;
                  Navigator.pop(context);
                }
              : null,
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            if (filter?.hasUser == null && filter?.hasOrganizer == null) filter = null;
            context.read(adminGroupFilterProvider.notifier).state = filter;
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
