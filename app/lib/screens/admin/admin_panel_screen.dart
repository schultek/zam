import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import 'pages/groups_page.dart';
import 'pages/users_page.dart';
import 'providers/admin_groups_provider.dart';
import 'providers/admin_users_provider.dart';
import 'widgets/admin_filter_button.dart';
import 'widgets/admin_group_filter_menu.dart';
import 'widgets/admin_user_filter_menu.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();

  static Route route(BuildContext outerContext) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => InheritedTheme.captureAll(
        outerContext,
        GroupTheme(
          theme: outerContext.groupTheme,
          child: const AdminPanel(),
        ),
      ),
    );
  }
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: TabBar(
            tabs: [
              Tab(text: context.tr.groups),
              Tab(text: context.tr.users),
            ],
          ),
          actions: [
            Builder(builder: (context) {
              var controller = DefaultTabController.of(context)!;
              context.prime();
              if (controller.index == 0) {
                return AdminFilterButton<GroupFilter>(
                  filter: context.watch(adminGroupFilterProvider),
                  menu: const AdminGroupFilterMenu(),
                );
              } else {
                return AdminFilterButton<UserFilter>(
                  filter: context.watch(adminUserFilterProvider),
                  menu: const AdminUserFilterMenu(),
                );
              }
            }),
          ],
        ),
        body: const TabBarView(
          children: [
            GroupsPage(),
            UsersPage(),
          ],
        ),
      ),
    );
  }
}
