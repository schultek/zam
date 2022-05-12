import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../modules/modules.dart';
import '../../../providers/groups/logic_provider.dart';
import '../../../providers/groups/selected_group_provider.dart';
import '../providers/admin_groups_provider.dart';
import '../providers/admin_users_provider.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groups = context.watch(adminFilteredGroupsProvider);
    return ListView(
      children: <Widget>[
        for (var group in groups)
          ExpansionTile(
            title: Text(group.name),
            subtitle: Text('${group.users.length} Users'),
            leading: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: Container(
                  color: context.theme.cardColor,
                  child: group.pictureUrl != null //
                      ? CachedNetworkImage(imageUrl: group.pictureUrl!)
                      : null,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: () {
                    context.read(selectedGroupIdProvider.notifier).state = group.id;
                  },
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('View Users'),
                      onTap: () {
                        context.read(adminUserFilterProvider.notifier).state = UserFilter(isInGroup: group.id);
                        DefaultTabController.of(context)!.index = 1;
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('View Organizers'),
                      onTap: () {
                        context.read(adminUserFilterProvider.notifier).state = UserFilter(isOrganizerOfGroup: group.id);
                        DefaultTabController.of(context)!.index = 1;
                      },
                    ),
                  ],
                ),
              ],
            ),
            children: [
              ListTile(
                title: const Text('Blacklist'),
                subtitle: Text(group.moduleBlacklist.map((id) => registry.modules[id]!.getName(context)).join(', ')),
                isThreeLine: group.moduleBlacklist.isNotEmpty,
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    var newBlacklist = await BlacklistDialog.show(context, group.moduleBlacklist);
                    if (newBlacklist != null) {
                      context.read(groupsLogicProvider).updateGroup({'moduleBlacklist': newBlacklist}, group.id);
                    }
                  },
                ),
              ),
            ],
          ),
      ].intersperse(const Divider(height: 0)).toList(),
    );
  }
}

class BlacklistDialog extends StatefulWidget {
  const BlacklistDialog(this.blacklist, {Key? key}) : super(key: key);
  final List<String> blacklist;
  @override
  State<BlacklistDialog> createState() => _BlacklistDialogState();

  static Future<List<String>?> show(BuildContext context, List<String> blacklist) {
    return showDialog(
      context: context,
      builder: (context) => BlacklistDialog(blacklist),
    );
  }
}

class _BlacklistDialogState extends State<BlacklistDialog> {
  List<String> blacklist = [];

  @override
  void initState() {
    super.initState();
    blacklist = [...widget.blacklist];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Blacklist'),
      content: SizedBox(
        width: 300,
        height: 500,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (var id in registry.modules.keys)
              CheckboxListTile(
                title: Text(registry.modules[id]!.getName(context)),
                value: blacklist.contains(id),
                onChanged: (value) {
                  setState(() {
                    if (value ?? false) {
                      blacklist.add(id);
                    } else {
                      blacklist.remove(id);
                    }
                  });
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            Navigator.of(context).pop(blacklist);
          },
        ),
      ],
    );
  }
}
