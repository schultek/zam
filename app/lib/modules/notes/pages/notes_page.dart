import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../notes_module.dart';
import '../notes_provider.dart';
import '../widgets/folder_dialog.dart';
import '../widgets/note_preview.dart';
import 'change_folder_page.dart';
import 'edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const NotesPage());
  }

  static List<Widget> cardsBuilder(BuildContext context, [bool needsSurface = false, NotesListParams? params]) {
    var notes = context.watch(notesProvider).value ?? [];
    var folders = notes.groupListsBy((n) => n.folder);

    if (params?.folder != null) {
      folders = {null: folders[params!.folder!] ?? []};
    }

    return [
      for (var note in folders[null] ?? <Note>[])
        NoteCard(
          needsSurface: needsSurface,
          child: NotePreview(note: note),
          onTap: () async {
            Navigator.of(context).push(EditNotePage.route(note));
          },
        ),
      if (params?.showFolders ?? true)
        for (var folder in folders.keys)
          if (folder != null) FolderCard(folder: folder, needsSurface: needsSurface),
      if (params?.showAdd ?? true)
        NoteCard(
          needsSurface: needsSurface,
          child: Center(
            child: Icon(Icons.add, size: 60, color: context.onSurfaceHighlightColor),
          ),
          onTap: () {
            var note = context.read(notesLogicProvider).createEmptyNote(folder: params?.folder);
            Navigator.of(context).push(EditNotePage.route(note));
          },
        ),
    ];
  }

  static List<Widget> settingsBuilder(BuildContext context, ModuleContext module, NotesListParams params) {
    return [
      SwitchListTile(
        value: params.showAdd,
        onChanged: (v) {
          module.updateParams(params.copyWith(showAdd: v));
        },
        title: Text(context.tr.show_add_tile),
      ),
      Builder(builder: (context) {
        return ListTile(
          title: Text(context.tr.folder),
          subtitle: Text(params.folder ?? context.tr.no_folder),
          onTap: () async {
            var newFolder = await Navigator.of(context).push(ChangeFolderPage.route(params.folder));
            if (newFolder != null) {
              module.updateParams(params.copyWith(folder: newFolder.value));
            }
          },
        );
      }),
      if (params.folder == null)
        SwitchListTile(
          value: params.showFolders,
          onChanged: (v) {
            module.updateParams(params.copyWith(showFolders: v));
          },
          title: Text(context.tr.show_folders),
        )
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
