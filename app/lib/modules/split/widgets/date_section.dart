import 'package:flutter/material.dart';

import '../split.module.dart';

class DateSection extends StatelessWidget {
  const DateSection({
    this.transactedAt,
    required this.createdAt,
    required this.showCreatedAt,
    required this.onTransactedDateChanged,
    Key? key,
  }) : super(key: key);

  final DateTime? transactedAt;
  final DateTime createdAt;
  final bool showCreatedAt;
  final ValueChanged<DateTime> onTransactedDateChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(children: [
      ListTile(
        title: Text(context.tr.date),
        trailing: transactedAt != null ? Text(dateFormat.format(transactedAt!)) : null,
        onTap: () async {
          var date = await showDatePicker(
            context: context,
            initialDate: transactedAt ?? createdAt,
            lastDate: createdAt,
            useRootNavigator: false,
            firstDate: DateTime(2000),
          );

          if (date != null) {
            onTransactedDateChanged(date);
          }
        },
      ),
      if (showCreatedAt)
        ListTile(
          title: Text(context.tr.created_at),
          trailing: Text(dateFormat.format(createdAt)),
        ),
    ]);
  }
}
