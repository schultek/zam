import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../models/models.dart';
import '../../../providers/trips/logic_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';

class UserOptionsDialog extends StatelessWidget {
  final String id;
  const UserOptionsDialog({Key? key, required this.id}) : super(key: key);

  static Future<void> show(BuildContext context, {required String userId}) {
    return showDialog(context: context, builder: (context) => UserOptionsDialog(id: userId));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('User Options'),
      content: SizedBox(
        width: 400,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: const Text('Delete'),
              onTap: () {
                context.read(tripsLogicProvider).deleteUser(id);
                Navigator.of(context).pop();
              },
            ),
            roleOption(context, context.read(tripUserByIdProvider(id))?.role ?? UserRoles.participant),
          ],
        ),
      ),
    );
  }

  Widget roleOption(BuildContext context, String role) {
    if (role == UserRoles.organizer) {
      return ListTile(
        title: const Text('Remove Organizer Status'),
        onTap: () {
          context.read(tripsLogicProvider).updateUserRole(id, UserRoles.participant);
          Navigator.of(context).pop();
        },
      );
    } else {
      return ListTile(
        title: const Text('Make Organizer'),
        onTap: () {
          context.read(tripsLogicProvider).updateUserRole(id, UserRoles.organizer);
          Navigator.of(context).pop();
        },
      );
    }
  }
}
