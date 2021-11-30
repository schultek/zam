import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/settings_section.dart';
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
    return Consumer(builder: (context, ref, _) {
      var note = ref.watch(noteProvider(widget.note.id)).asData!.value;
      if (note == null) {
        return Container();
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(note.title ?? 'Untitled Note'),
        ),
        body: ListView(
          children: [
            SettingsSection(children: [
              ListTile(
                title: const Text('Folder'),
                subtitle: Text(note.folder ?? 'No Folder'),
                onTap: () {
                  Navigator.of(context).push(ChangeFolderPage.route(note));
                },
              ),
              ListTile(
                title: const Text('Author'),
                subtitle: Text(ref.read(nicknameProvider(note.author)) ?? 'Anonym'),
              ),
              ListTile(
                title: const Text('Editors'),
                subtitle: Text(note.editors.map((e) => ref.read(nicknameProvider(e)) ?? 'Anonym').join(', ')),
                onTap: () {
                  Navigator.of(context).push(AddEditorsPage.route(note));
                },
              ),
            ]),
            SettingsSection(children: [
              ListTile(
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.pop(context, true);
                },
              ),
            ]),
          ],
        ),
      );
    });
  }
}
