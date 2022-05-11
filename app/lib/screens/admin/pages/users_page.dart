import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:shared/models/models.dart' hide UserClaimsMapperExtension;

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

    var groupedUsers = groupBy<UserData, bool>(
      users,
      (u) => context.watch(adminGroupsOfUserProvider(u.id)).isEmpty,
    );

    return RefreshIndicator(
      onRefresh: () {
        context.refresh(adminUsersProvider);
        return context.read(adminUsersProvider.future);
      },
      child: ListView(
        children: <Widget>[
          ExpansionTile(
            title: const Text('Without Group'),
            children: [
              for (var user in groupedUsers[true] ?? <UserData>[]) _userTile(user),
            ],
          ),
          ExpansionTile(
            title: const Text('With Group'),
            initiallyExpanded: true,
            children: [
              for (var user in groupedUsers[false] ?? <UserData>[]) _userTile(user),
            ],
          ),
        ].intersperse(const Divider(height: 0)).toList(),
      ),
    );
  }

  Widget _userTile(UserData user) {
    return Builder(builder: (context) {
      var groups = context.watch(adminGroupsOfUserProvider(user.id));
      return ExpansionTile(
        title: Text('${user.phoneNumber ?? context.tr.anonymous}'
            '${groups.isNotEmpty ? ' (${groups.map((g) => g.users[user.id]?.nickname).whereType<String>().join(', ')})' : ''}'),
        subtitle: Text('${groups.length} Groups'),
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
        children: [
          ListTile(
            title: const Text('Id'),
            subtitle: Text(user.id),
            visualDensity: VisualDensity.compact,
          ),
          ListTile(
            title: const Text('Groups'),
            subtitle: Text(
              groups.map((g) => g.name).join(', '),
            ),
            visualDensity: VisualDensity.compact,
          ),
          if (user.metadata?.creationTime != null)
            ListTile(
              title: const Text('Created At'),
              subtitle: Text(user.metadata!.creationTime!.toString()),
              visualDensity: VisualDensity.compact,
            ),
          if (user.metadata?.lastSignInTime != null)
            ListTile(
              title: const Text('Last Signed In At'),
              subtitle: Text(user.metadata!.lastSignInTime!.toString()),
              visualDensity: VisualDensity.compact,
            ),
        ],
      );
    });
  }
}
