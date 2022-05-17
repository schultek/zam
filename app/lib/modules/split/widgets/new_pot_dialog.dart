import 'package:flutter/material.dart';

import '../../../core/widgets/emoji_keyboard.dart';
import '../../../core/widgets/input_list_tile.dart';
import '../split.module.dart';

class NewPotDialog extends StatefulWidget {
  const NewPotDialog({Key? key}) : super(key: key);

  @override
  State<NewPotDialog> createState() => _NewPotDialogState();

  static Future<SplitPot?> show(BuildContext context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => const NewPotDialog(),
    );
  }
}

class _NewPotDialogState extends State<NewPotDialog> {
  String? name;
  String? icon;

  @override
  Widget build(BuildContext context) {
    return SettingsDialog(
      title: Text(context.tr.new_pot),
      content: SettingsSection(
        margin: EdgeInsets.zero,
        children: [
          InputListTile(
            label: 'Name',
            value: name,
            autofocus: true,
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          ListTile(
            title: const Text('Icon'),
            subtitle: Text(icon != null ? context.tr.tap_to_change : context.tr.tap_to_add),
            trailing: icon != null ? Text(icon!, style: const TextStyle(fontSize: 24)) : const Icon(Icons.savings),
            onTap: () async {
              var emoji = await showEmojiKeyboard(context);
              if (emoji != null) {
                setState(() {
                  icon = emoji;
                });
              }
            },
          ),
        ],
        backgroundOpacity: 0.3,
      ),
      actions: [
        TextButton(
          onPressed: name != null
              ? () {
                  Navigator.of(context).pop(SplitPot(name: name!, icon: icon));
                }
              : null,
          child: Text(context.tr.create),
        ),
      ],
    );
  }
}
