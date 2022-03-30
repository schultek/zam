import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../users_module.dart';

class UserOptionsDialog extends StatelessWidget {
  final String id;
  const UserOptionsDialog({Key? key, required this.id}) : super(key: key);

  static Future<void> show(BuildContext context, {required String userId}) {
    return showDialog(context: context, builder: (context) => UserOptionsDialog(id: userId));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr.user_options),
      content: SizedBox(
        width: 400,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(context.tr.delete),
              onTap: () {
                context.read(groupsLogicProvider).deleteUser(id);
                Navigator.of(context).pop();
              },
            ),
            roleOption(context, context.read(groupUserByIdProvider(id))?.role ?? UserRoles.participant),
          ],
        ),
      ),
    );
  }

  Widget roleOption(BuildContext context, String role) {
    if (role == UserRoles.organizer) {
      return ListTile(
        title: Text(context.tr.remove_organizer),
        onTap: () {
          context.read(groupsLogicProvider).updateUserRole(id, UserRoles.participant);
          Navigator.of(context).pop();
        },
      );
    } else {
      return ListTile(
        title: Text(context.tr.make_organizer),
        onTap: () {
          context.read(groupsLogicProvider).updateUserRole(id, UserRoles.organizer);
          Navigator.of(context).pop();
        },
      );
    }
  }
}
