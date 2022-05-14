import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../notes.module.dart';
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
          title: Text(note.title ?? context.tr.untitled_note),
        ),
        body: ListView(
          children: [
            SettingsSection(children: [
              ListTile(
                title: Text(context.tr.folder),
                subtitle: Text(note.folder ?? context.tr.no_folder),
                onTap: () async {
                  var newFolder =
                      await Navigator.of(context).push(ChangeFolderPage.route(note.folder, allowCreate: true));
                  if (newFolder != null) {
                    await context.read(notesLogicProvider).changeFolder(widget.note.id, newFolder.value);
                  }
                },
              ),
              ListTile(
                title: Text(context.tr.author),
                subtitle: Text(ref.read(nicknameProvider(note.author)) ?? context.tr.anonymous),
              ),
              ListTile(
                title: Text(context.tr.editors),
                subtitle:
                    Text(note.editors.map((e) => ref.read(nicknameProvider(e)) ?? context.tr.anonymous).join(', ')),
                onTap: () {
                  Navigator.of(context).push(AddEditorsPage.route(note));
                },
              ),
            ]),
            SettingsSection(children: [
              ListTile(
                title: Text(
                  context.tr.delete,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  var shouldDelete = await showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('${context.tr.delete} ${note.title}?'),
                        actions: [
                          TextButton(
                            child: Text(context.tr.cancel),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            child: Text(context.tr.delete),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldDelete == true) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ]),
          ],
        ),
      );
    });
  }
}
