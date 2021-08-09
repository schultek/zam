import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_note_page.dart';
import 'notes_provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            const Text("Notes"),
            const SizedBox(height: 30),
            Expanded(
              child: Consumer(
                builder: (context, watch, _) {
                  var notes = watch(notesProvider);

                  return notes.when(
                    data: (data) => GridView.count(
                      crossAxisCount: 2,
                      children: [
                        for (var note in data) noteItem(note),
                        GestureDetector(
                          onTap: () async {
                            var note = await context.read(notesLogicProvider).createEmptyNote();

                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => EditNotePage(note)),
                            );
                          },
                          child: const Card(
                            child: Center(
                              child: Icon(Icons.add, size: 50),
                            ),
                          ),
                        ),
                      ],
                    ),
                    loading: () => const Text("Loading"),
                    error: (e, st) => Text("Error $e"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget noteItem(Note note) {
    return Card(
      child: Center(
        child: Text(note.content),
      ),
    );
  }
}
