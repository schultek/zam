import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../notes.module.dart';
import '../pages/edit_note_page.dart';
import '../widgets/folder_card.dart';
import '../widgets/note_card.dart';
import '../widgets/note_preview.dart';

class NotesCardsBuilder {
  NotesCardsBuilder([this.needsSurface = false, this.params]);

  final bool needsSurface;
  final NotesListParams? params;

  List<Widget> call(BuildContext context) {
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
          if (folder != null)
            FolderCard(
              folder: folder,
              needsSurface: needsSurface,
            ),
      if (params?.showAdd ?? true)
        NoteCard(
          needsSurface: needsSurface,
          child: Center(
            child: Builder(builder: (context) {
              return Icon(
                Icons.add,
                size: 60,
                color: context.onSurfaceHighlightColor,
              );
            }),
          ),
          onTap: () {
            var note = context.read(notesLogicProvider).createEmptyNote(folder: params?.folder);
            Navigator.of(context).push(EditNotePage.route(note));
          },
        ),
    ];
  }
}
