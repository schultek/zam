import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notes_provider.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Consumer(
          builder: (context, watch, _) {
            var notes = watch(notesProvider);
            return notes.when(
                data: (data) => ListView(
                      children: [
                        for (var note in data)
                          ListTile(
                            title: Text(note.title),
                            subtitle: Text(note.content.substring(0, min(note.content.length, 20))),
                            onTap: () {
                              Navigator.of(context).pop();
                              Future.delayed(const Duration(milliseconds: 300), () => widget.onSelect(note.id));
                            },
                          ),
                      ],
                    ),
                loading: () => const Text("Loading"),
                error: (e, st) => Text("Error $e"));
          },
        ),
      ),
    );
  }
}
