import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';
import 'pot_icon.dart';

class SelectSourceDialog extends StatefulWidget {
  const SelectSourceDialog({this.source, this.allowUsers = true, Key? key}) : super(key: key);

  final SplitSource? source;
  final bool allowUsers;

  @override
  State<SelectSourceDialog> createState() => _SelectSourceDialogState();

  static Future<SplitSource?> show(BuildContext context, SplitSource? source, {bool allowUsers = true}) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) => SelectSourceDialog(source: source, allowUsers: allowUsers),
    );
  }
}

class _SelectSourceDialogState extends State<SelectSourceDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      content: SizedBox(
        width: 300,
        child: ThemedSurface(
          builder: (context, color) => ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              if (widget.allowUsers) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
                  child: Text(
                    context.tr.users,
                    style: context.theme.textTheme.caption,
                  ),
                ),
                for (var user in context.read(selectedGroupProvider)!.users.entries)
                  ListTile(
                    title: Text(user.value.nickname ?? context.tr.anonymous),
                    leading: UserAvatar(id: user.key, small: true),
                    minLeadingWidth: 10,
                    tileColor: widget.source == SplitSource.user(user.key) ? color.withOpacity(0.5) : null,
                    onTap: () {
                      Navigator.of(context).pop(SplitSource(user.key, SplitSourceType.user));
                    },
                  ),
              ],
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
                child: Text(
                  context.tr.pots,
                  style: context.theme.textTheme.caption,
                ),
              ),
              for (var pot in context.read(splitProvider).value?.pots.entries ?? <MapEntry<String, SplitPot>>[])
                ListTile(
                  title: Text(pot.value.name),
                  leading: PotIcon(id: pot.key),
                  minLeadingWidth: 10,
                  tileColor: widget.source == SplitSource.pot(pot.key) ? color.withOpacity(0.5) : null,
                  onTap: () {
                    Navigator.of(context).pop(SplitSource(pot.key, SplitSourceType.pot));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
