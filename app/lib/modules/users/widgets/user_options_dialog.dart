import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/trips/logic_provider.dart';

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
          ],
        ),
      ),
    );
  }
}
