import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../split.module.dart';

class EditEntryPage<T extends SplitEntry> extends StatefulWidget {
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
  final FutureOr<void> Function() onSave;
  final List<Widget> children;

  @override
  State<EditEntryPage<T>> createState() => _EditEntryPageState<T>();
}

class _EditEntryPageState<T extends SplitEntry> extends State<EditEntryPage<T>> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ThemedSurface(
            preference: ColorPreference(useHighlightColor: !context.groupTheme.dark),
            builder: (context, _) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
              child: TextFormField(
                initialValue: widget.title,
                autofocus: widget.title == null || widget.title!.isEmpty,
                decoration: InputDecoration(
                  hintText: context.tr.title,
                  hintStyle: TextStyle(color: context.onSurfaceColor.withOpacity(0.5)),
                  border: InputBorder.none,
                  filled: false,
                ),
                cursorColor: context.onSurfaceHighlightColor,
                style: context.theme.textTheme.bodyLarge!.copyWith(fontSize: 22, color: context.onSurfaceColor),
                onChanged: widget.onTitleChanged,
              ),
            ),
          ),
        ),
        actions: [
          ThemedSurface(
            preference: ColorPreference(useHighlightColor: !context.groupTheme.dark),
            builder: (context, _) => TextButton(
              onPressed: widget.entryValid
                  ? () async {
                      setState(() => isSaving = true);
                      try {
                        await widget.onSave();
                      } finally {
                        setState(() => isSaving = false);
                      }
                    }
                  : null,
              child: isSaving
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(context.onSurfaceHighlightColor),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      context.tr.save,
                      style: TextStyle(color: context.onSurfaceHighlightColor.withOpacity(widget.entryValid ? 1 : 0.5)),
                    ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ...widget.children,
          if (widget.entry != null && context.watch(isOrganizerProvider))
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
                      context.read(splitLogicProvider).deleteEntry(widget.entry!.id);
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
