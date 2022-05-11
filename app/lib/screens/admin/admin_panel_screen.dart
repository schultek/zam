import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/core.dart';
import '../../helpers/extensions.dart';
import '../../providers/links/links_provider.dart';
import 'pages/groups_page.dart';
import 'pages/users_page.dart';
import 'widgets/admin_filter_menu.dart';

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
            const AdminFilterMenu(),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Create Admin Link'),
                  onTap: () async {
                    var link = await context.read(linkLogicProvider).createAdminLink(context: context);
                    Share.share('${context.tr.become_admin_desc}: $link');
                  },
                ),
                PopupMenuItem(
                  child: const Text('Create Organizer Link'),
                  onTap: () async {
                    var link = await context.read(linkLogicProvider).createOrganizerLink(context: context);
                    Share.share('${context.tr.become_organizer_desc}: $link');
                  },
                ),
              ],
            ),
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
