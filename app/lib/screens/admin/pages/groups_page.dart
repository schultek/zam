import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
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
          ListTile(
            title: Text(group.name),
            subtitle: Text('${group.users.length} Users'),
            onTap: () {
              context.read(selectedGroupIdProvider.notifier).state = group.id;
            },
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
            trailing: PopupMenuButton(
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
          ),
      ].intersperse(const Divider(height: 0)).toList(),
    );
  }
}
