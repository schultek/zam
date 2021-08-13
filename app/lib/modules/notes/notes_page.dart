import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_note_page.dart';
import 'note_preview.dart';
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Notes",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer(
                builder: (context, watch, _) {
                  var notes = watch(notesProvider);

                  return notes.when(
                    data: (data) => GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        for (var note in data)
                          noteCard(
                            child: NotePreview(note: note),
                            onTap: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => EditNotePage(note)),
                              );
                            },
                          ),
                        noteCard(
                          child: const Center(
                            child: Icon(Icons.add, size: 60),
                          ),
                          onTap: () async {
                            var note = await context.read(notesLogicProvider).createEmptyNote();
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => EditNotePage(note)),
                            );
                          },
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

  Widget noteCard({required Widget child, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: child,
      ),
    );
  }
}
