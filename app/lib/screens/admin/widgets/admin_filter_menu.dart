import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../providers/admin_groups_provider.dart';
import '../providers/admin_users_provider.dart';
import 'admin_filter_button.dart';
import 'admin_group_filter_menu.dart';
import 'admin_user_filter_menu.dart';

class AdminFilterMenu extends StatefulWidget {
  const AdminFilterMenu({Key? key}) : super(key: key);

  @override
  State<AdminFilterMenu> createState() => _AdminFilterMenuState();
}

class _AdminFilterMenuState extends State<AdminFilterMenu> {
  int index = 0;

  TabController? controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var newController = DefaultTabController.of(context)!;
    controller?.removeListener(checkIndex);
    controller = newController;
    newController.addListener(checkIndex);
    checkIndex();
  }

  void checkIndex() {
    if (controller != null && index != controller?.index) {
      setState(() {
        index = controller!.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.prime();
    if (index == 0) {
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
  }
}
