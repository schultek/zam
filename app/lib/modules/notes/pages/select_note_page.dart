import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notes_provider.dart';

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
      body: Consumer(
        builder: (context, watch, _) {
          var notes = watch(notesProvider);
          print(notes);
          return notes.when(
              data: (data) => ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Select a note',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      for (var note in data)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          title: Text(note.title ?? 'Untitled'),
                          subtitle: Text(
                            Document.fromJson(note.content).toPlainText().replaceAll('\n', '  '),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Future.delayed(const Duration(milliseconds: 300), () => widget.onSelect(note.id));
                          },
                        ),
                    ],
                  ),
              loading: () => const Text('Loading...'),
              error: (e, st) => Text('Error $e'));
        },
      ),
    );
  }
}
