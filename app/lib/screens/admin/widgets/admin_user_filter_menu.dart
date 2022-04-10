import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../providers/admin_users_provider.dart';

class AdminUserFilterMenu extends StatefulWidget {
  const AdminUserFilterMenu({Key? key}) : super(key: key);

  @override
  State<AdminUserFilterMenu> createState() => _AdminUserFilterMenuState();
}

class _AdminUserFilterMenuState extends State<AdminUserFilterMenu> {
  UserFilter? filter;

  @override
  void initState() {
    super.initState();
    filter = context.read(adminUserFilterProvider)?.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsDialog(
      title: const Text('User Filters'),
      content: SettingsSection(
        backgroundOpacity: 0.5,
        children: [
          SwitchListTile(
            title: const Text('Is Admin'),
            subtitle: Text(filter?.isAdmin?.toString() ?? 'Not Set'),
            value: filter?.isAdmin ?? false,
            onChanged: (bool value) {
              setState(() {
                filter = filter?.copyWith(isAdmin: value) ?? UserFilter(isAdmin: value);
              });
            },
          ),
          ListTile(
            title: const Text('Is In Group'),
            subtitle: Text(filter?.isInGroup ?? 'None'),
            trailing: filter?.isInGroup != null
                ? IconButton(
                    icon: Icon(Icons.delete, color: context.theme.errorColor),
                    onPressed: () {
                      setState(() {
                        filter!.isInGroup = null;
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
                  context.read(adminUserFilterProvider.notifier).state = null;
                  Navigator.pop(context);
                }
              : null,
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            if (filter?.isInGroup == null &&
                filter?.isOrganizerOfGroup == null &&
                filter?.isAdmin == null &&
                filter?.isGroupCreator == null) filter = null;
            context.read(adminUserFilterProvider.notifier).state = filter;
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
