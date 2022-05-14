import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../notes.module.dart';
import 'edit_note_page.dart';

class SelectNotePage extends StatefulWidget {
  const SelectNotePage({Key? key}) : super(key: key);

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
                  padding: const EdgeInsets.all(15),
                  children: <Widget>[
                    ThemedSurface(
                      builder: (context, color) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(context.tr.new_note),
                        leading: const Icon(Icons.note_add),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        tileColor: color,
                        onTap: () async {
                          var note = context.read(notesLogicProvider).createEmptyNote();
                          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditNotePage(note)));
                          if (context.read(noteProvider(note.id)).value != null) {
                            Navigator.of(context).pop(note.id);
                          }
                        },
                      ),
                    ),
                    for (var note in data)
                      ThemedSurface(
                        builder: (context, color) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          title: Text(note.title ?? context.tr.untitled),
                          subtitle: Text(
                            Document.fromJson(note.content).toPlainText().replaceAll('\n', '  '),
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: const Icon(Icons.sticky_note_2),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          tileColor: color,
                          onTap: () {
                            Navigator.of(context).pop(note.id);
                          },
                        ),
                      ),
                    for (var folder in folders.entries)
                      if (folder.key != null)
                        ThemedSurface(
                          builder: (context, color) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            title: Text(folder.key!),
                            subtitle: Text(
                              folder.value.map((n) => n.title).join(', '),
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: const Icon(Icons.folder),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            tileColor: color,
                            onTap: () {
                              Navigator.of(context).pop('%' + folder.key!);
                            },
                          ),
                        ),
                  ].intersperse(const SizedBox(height: 10)).toList(),
                );
              },
              loading: () => Text('${context.tr.loading}...'),
              error: (e, st) => Text('${context.tr.error} $e'));
        },
      ),
    );
  }
}
