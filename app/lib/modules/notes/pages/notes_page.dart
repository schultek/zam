import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../notes_provider.dart';
import '../widgets/note_preview.dart';
import 'edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const NotesPage());
  }

  static List<Widget> cardsBuilder(BuildContext context, [bool needsSurface = false]) {
    var notes = context.watch(notesProvider).value ?? [];
    var folders = notes.groupListsBy((n) => n.folder);

    return [
      for (var note in folders[null] ?? <Note>[])
        NoteCard(
          needsSurface: needsSurface,
          child: NotePreview(note: note),
          onTap: () async {
            Navigator.of(context).push(EditNotePage.route(note));
          },
        ),
      for (var folder in folders.keys)
        if (folder != null) FolderCard(folder: folder, needsSurface: needsSurface),
    ];
  }
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            ...NotesPage.cardsBuilder(context, true),
            NoteCard(
              needsSurface: true,
              child: Center(
                child: Icon(Icons.add, size: 60, color: context.theme.colorScheme.primary),
              ),
              onTap: () {
                var note = context.read(notesLogicProvider).createEmptyNote();
                Navigator.of(context).push(EditNotePage.route(note));
              },
            ),
          ],
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

class NoteCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool needsSurface;

  const NoteCard({required this.child, required this.onTap, this.needsSurface = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (needsSurface) {
      return ThemedSurface(builder: (context, color) => buildCard(context, color));
    } else {
      return buildCard(context, null);
    }
  }

  Widget buildCard(BuildContext context, Color? color) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: color ?? Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: child,
      ),
    );
  }
}

class FolderCard extends StatelessWidget {
  final String folder;
  final bool needsSurface;
  const FolderCard({required this.folder, this.needsSurface = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (needsSurface) {
      return ThemedSurface(builder: (context, color) => buildCard(context, color));
    } else {
      return buildCard(context, null);
    }
  }

  Widget buildCard(BuildContext context, Color? color) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => folderDialog(folder),
          useRootNavigator: false,
          barrierColor: Colors.black45,
        );
      },
      child: Material(
        color: color ?? Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 8,
                child: Icon(
                  Icons.folder,
                  size: 40,
                  color: context.onSurfaceHighlightColor,
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 6,
                child: Text(
                  folder,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: context.onSurfaceColor),
                  overflow: TextOverflow.ellipsis,
                ),
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
                builder: (context, ref, _) {
                  var notes = ref.watch(notesProvider).asData?.value.where((n) => n.folder == folder) ?? [];

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
                            child: NoteCard(
                              needsSurface: true,
                              child: NotePreview(note: note),
                              onTap: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(EditNotePage.route(note));
                              },
                            ),
                          ),
                        ),
                      NoteCard(
                        needsSurface: true,
                        child: const Center(
                          child: Icon(Icons.add, size: 30),
                        ),
                        onTap: () {
                          var note = ref.read(notesLogicProvider).createEmptyNote(folder: folder);
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
