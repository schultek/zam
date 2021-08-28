import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/themes.dart';
import '../notes_provider.dart';
import '../widgets/note_preview.dart';
import 'edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: context.getTextColor()),
        title: Text('Notes', style: TextStyle(color: context.getTextColor())),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer(
          builder: (context, watch, _) {
            var notes = watch(notesProvider);

            return notes.when(
              data: (data) {
                var folders = data.groupListsBy((n) => n.folder);
                return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    for (var note in folders[null] ?? <Note>[])
                      noteCard(
                        child: NotePreview(note: note),
                        onTap: () async {
                          Navigator.of(context).push(EditNotePage.route(note));
                        },
                      ),
                    for (var folder in folders.keys)
                      if (folder != null) folderCard(folder),
                    noteCard(
                      child: const Center(
                        child: Icon(Icons.add, size: 60),
                      ),
                      onTap: () async {
                        var note = await context.read(notesLogicProvider).createEmptyNote();
                        Navigator.of(context).push(EditNotePage.route(note));
                      },
                    ),
                  ],
                );
              },
              loading: () => const Text('Loading'),
              error: (e, st) => Text('Error $e'),
            );
          },
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

  Widget folderCard(String folder) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (context) => folderDialog(folder), useRootNavigator: false);
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.folder,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                folder,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget folderDialog(String folder) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 86),
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Consumer(
                builder: (context, watch, _) {
                  var notes = watch(notesProvider).data?.value.where((n) => n.folder == folder) ?? [];

                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      for (var note in notes)
                        FittedBox(
                          child: ConstrainedBox(
                            constraints: constraints.scale(0.5),
                            child: noteCard(
                              child: NotePreview(note: note),
                              onTap: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(EditNotePage.route(note));
                              },
                            ),
                          ),
                        ),
                      noteCard(
                        child: const Center(
                          child: Icon(Icons.add, size: 30),
                        ),
                        onTap: () async {
                          var note = await context.read(notesLogicProvider).createEmptyNote(folder: folder);
                          Navigator.of(context).push(EditNotePage.route(note));
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on BoxConstraints {
  BoxConstraints scale(double factor) => copyWith(
        minWidth: minWidth * factor,
        minHeight: minHeight * factor,
        maxWidth: maxWidth * factor,
        maxHeight: maxHeight * factor,
      );
}
