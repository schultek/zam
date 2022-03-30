import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notes.module.dart';

class SelectNotePage extends StatefulWidget {
  final Function(String) onSelect;
  const SelectNotePage({Key? key, required this.onSelect}) : super(key: key);

  @override
  _SelectNotePageState createState() => _SelectNotePageState();
}

class _SelectNotePageState extends State<SelectNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.select_note_or_folder),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          var notes = ref.watch(notesProvider);
          return notes.when(
              data: (data) {
                var folders = data.groupListsBy((n) => n.folder);

                return ListView(
                  children: [
                    for (var note in data)
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(note.title ?? context.tr.untitled),
                        subtitle: Text(
                          Document.fromJson(note.content).toPlainText().replaceAll('\n', '  '),
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: const Icon(Icons.sticky_note_2),
                        onTap: () {
                          Navigator.of(context).pop();
                          Future.delayed(const Duration(milliseconds: 300), () => widget.onSelect(note.id));
                        },
                      ),
                    for (var folder in folders.entries)
                      if (folder.key != null)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          title: Text(folder.key!),
                          subtitle: Text(
                            folder.value.map((n) => n.title).join(', '),
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: const Icon(Icons.folder),
                          onTap: () {
                            Navigator.of(context).pop();
                            Future.delayed(const Duration(milliseconds: 300), () => widget.onSelect('%' + folder.key!));
                          },
                        ),
                  ],
                );
              },
              loading: () => Text('${context.tr.loading}...'),
              error: (e, st) => Text('${context.tr.error} $e'));
        },
      ),
    );
  }
}
