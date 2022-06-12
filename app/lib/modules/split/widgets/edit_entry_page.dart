import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';

class EditEntryPage<T extends SplitEntry> extends StatelessWidget {
  const EditEntryPage({
    required this.pageTitle,
    this.entry,
    this.title,
    required this.onTitleChanged,
    required this.entryValid,
    required this.onSave,
    required this.children,
    Key? key,
  }) : super(key: key);

  final String pageTitle;
  final T? entry;
  final String? title;
  final ValueChanged<String> onTitleChanged;
  final bool entryValid;
  final VoidCallback onSave;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ThemedSurface(
            preference: ColorPreference(useHighlightColor: !context.groupTheme.dark),
            builder: (context, _) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
              child: TextFormField(
                initialValue: title,
                autofocus: title == null || title!.isEmpty,
                decoration: InputDecoration(
                  hintText: context.tr.title,
                  hintStyle: TextStyle(color: context.onSurfaceColor.withOpacity(0.5)),
                  border: InputBorder.none,
                  filled: false,
                ),
                cursorColor: context.onSurfaceHighlightColor,
                style: context.theme.textTheme.bodyLarge!.copyWith(fontSize: 22, color: context.onSurfaceColor),
                onChanged: onTitleChanged,
              ),
            ),
          ),
        ),
        actions: [
          ThemedSurface(
            preference: ColorPreference(useHighlightColor: !context.groupTheme.dark),
            builder: (context, _) => TextButton(
              onPressed: entryValid ? onSave : null,
              child: Text(
                context.tr.save,
                style: TextStyle(color: context.onSurfaceHighlightColor.withOpacity(entryValid ? 1 : 0.5)),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ...children,
          if (entry != null && context.watch(isOrganizerProvider))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: context.theme.colorScheme.onPrimary,
                    onPrimary: context.theme.colorScheme.primary,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                  child: Text(context.tr.delete),
                  onPressed: () async {
                    var shouldDelete = await SettingsDialog.confirm(
                      context,
                      text: context.tr.confirm_delete_entry,
                      confirm: context.tr.delete,
                    );
                    if (shouldDelete) {
                      Navigator.of(context).pop();
                      context.read(splitLogicProvider).deleteEntry(entry!.id);
                    }
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}
