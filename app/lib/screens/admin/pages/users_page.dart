import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../providers/auth/user_provider.dart';
import '../providers/admin_groups_provider.dart';
import '../providers/admin_users_provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var users = context.watch(adminFilteredUsersProvider);

    return ListView(
      children: <Widget>[
        for (var user in users)
          Builder(builder: (context) {
            var groups = context.watch(adminGroupsOfUserProvider(user.id));

            return ListTile(
              title: Text('${user.phoneNumber ?? context.tr.anonymous}'
                  '${groups.isNotEmpty ? ' (${groups.map((g) => g.users[user.id]?.nickname).whereType<String>().join(', ')})' : ''}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.id),
                  Text(
                    groups.map((g) => g.name).join(', '),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              isThreeLine: true,
              leading: Icon(
                user.claims.isAdmin
                    ? Icons.security
                    : user.claims.isGroupCreator
                        ? Icons.group
                        : Icons.account_circle,
                color: user.id == context.watch(userIdProvider) ? context.theme.colorScheme.primary : null,
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('View Groups'),
                    onTap: () {
                      context.read(adminGroupFilterProvider.notifier).state = GroupFilter(hasUser: user.id);
                      DefaultTabController.of(context)!.index = 0;
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('View Organized Groups'),
                    onTap: () {
                      context.read(adminGroupFilterProvider.notifier).state = GroupFilter(hasOrganizer: user.id);
                      DefaultTabController.of(context)!.index = 0;
                    },
                  ),
                  PopupMenuItem(
                    child: Text('${user.claims.isGroupCreator ? 'Remove' : 'Make'} Group Creator'),
                    onTap: () {
                      context
                          .read(adminUsersLogicProvider)
                          .setClaims(user.id, user.claims.copyWith(isGroupCreator: !user.claims.isGroupCreator));
                    },
                  ),
                  PopupMenuItem(
                    child: Text('${user.claims.isAdmin ? 'Remove' : 'Make'} Admin'),
                    onTap: () {
                      context
                          .read(adminUsersLogicProvider)
                          .setClaims(user.id, user.claims.copyWith(isAdmin: !user.claims.isAdmin));
                    },
                  ),
                ],
              ),
            );
          }),
      ].intersperse(const Divider(height: 0)).toList(),
    );
  }
}
