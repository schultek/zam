import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../notes_provider.dart';
import '../widgets/folder_dialog.dart';
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
      NoteCard(
        needsSurface: needsSurface,
        child: Center(
          child: Icon(Icons.add, size: 60, color: context.onSurfaceHighlightColor),
        ),
        onTap: () {
          var note = context.read(notesLogicProvider).createEmptyNote();
          Navigator.of(context).push(EditNotePage.route(note));
        },
      ),
    ];
  }
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.notes),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: NotesPage.cardsBuilder(context, true),
        ),
      ),
    );
  }
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
        child: AspectRatio(aspectRatio: 1, child: child),
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
        FolderDialog.show(context, folder);
      },
      child: Material(
        color: color ?? Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: AspectRatio(
          aspectRatio: 1,
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
      ),
    );
  }
}
