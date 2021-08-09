import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notes_provider.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  const EditNotePage(this.note, {Key? key}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  String? _title, _content;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Title",
              ),
              initialValue: widget.note.title,
              onChanged: (text) => _title = text,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Content",
              ),
              initialValue: widget.note.content,
              onChanged: (text) => _content = text,
            ),
            TextButton(
              onPressed: () {
                context.read(notesLogicProvider).updateNote(
                      widget.note.id,
                      title: _title ?? widget.note.title,
                      content: _content ?? widget.note.content,
                    );
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
