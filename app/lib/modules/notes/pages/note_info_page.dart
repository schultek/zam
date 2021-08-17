import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/trips/selected_trip_provider.dart';
import '../notes_provider.dart';
import 'add_editors_page.dart';
import 'change_folder_page.dart';

class NoteInfoPage extends StatefulWidget {
  final Note note;
  const NoteInfoPage(this.note, {Key? key}) : super(key: key);

  @override
  _NoteInfoPageState createState() => _NoteInfoPageState();

  static Route<bool> route(Note note) {
    return MaterialPageRoute(builder: (context) => NoteInfoPage(note));
  }
}

class _NoteInfoPageState extends State<NoteInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      var note = watch(noteProvider(widget.note.id)).data!.value!;

      return Scaffold(
        appBar: AppBar(
          title: Text(note.title ?? 'Untitled Note'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Folder'),
              subtitle: Text(note.folder ?? 'No Folder'),
              onTap: () {
                Navigator.of(context).push(ChangeFolderPage.route(note));
              },
            ),
            ListTile(
              title: const Text('Author'),
              subtitle: Text(context.read(nicknameProvider(note.author)) ?? 'Anonym'),
            ),
            ListTile(
              title: const Text('Editors'),
              subtitle: Text(note.editors.map((e) => context.read(nicknameProvider(e)) ?? 'Anonym').join(', ')),
              onTap: () {
                Navigator.of(context).push(AddEditorsPage.route(note));
              },
            ),
            ListTile(
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await context.read(notesLogicProvider).deleteNote(note.id);
                Navigator.pop(context, true);
              },
            )
          ],
        ),
      );
    });
  }
}
