import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jufa/providers/trips/selected_trip_provider.dart';

import '../../core/themes/themes.dart';
import 'notes_provider.dart';

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
              title: const Text("Folder"),
              subtitle: Text(note.folder ?? 'No Folder'),
              onTap: () {
                Navigator.of(context).push(ChangeFolderPage.route(note));
              },
            ),
            ListTile(
              title: const Text("Author"),
              subtitle: Text(context.read(nicknameProvider(note.author)) ?? 'Anonym'),
            ),
            ListTile(
              title: const Text("Editors"),
              subtitle: Text(note.editors.map((e) => context.read(nicknameProvider(e)) ?? 'Anonym').join(', ')),
              onTap: () {
                Navigator.of(context).push(AddEditorsPage.route(note));
              },
            ),
            ListTile(
              title: const Text(
                "Delete",
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

class AddEditorsPage extends StatefulWidget {
  final Note note;
  const AddEditorsPage(this.note, {Key? key}) : super(key: key);

  @override
  _AddEditorsPageState createState() => _AddEditorsPageState();

  static Route route(Note note) {
    return MaterialPageRoute(builder: (context) => AddEditorsPage(note));
  }
}

class _AddEditorsPageState extends State<AddEditorsPage> {
  Map<String, bool> isEditor = {};

  List<String> get selectedUsers => isEditor.entries.where((e) => e.value).map((e) => e.key).toList();

  @override
  void initState() {
    super.initState();
    for (var e in widget.note.editors) {
      isEditor[e] = true;
    }
  }

  Future<void> setEditors() async {
    await context.read(notesLogicProvider).setEditors(widget.note.id, selectedUsers);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Editors"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: setEditors,
          )
        ],
      ),
      body: Consumer(
        builder: (context, watch, _) {
          var users = watch(selectedTripProvider)!.users.entries.toList();

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: users.length,
            itemBuilder: (context, index) => CheckboxListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              value: isEditor[users[index].key] ?? false,
              onChanged: (v) {
                setState(() => isEditor = {...isEditor, users[index].key: v ?? false});
              },
              title: Text(users[index].value.nickname ?? 'Anonym'),
              controlAffinity: ListTileControlAffinity.trailing,
              secondary: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: users[index].value.profileUrl != null
                    ? CachedNetworkImageProvider(users[index].value.profileUrl!)
                    : null,
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}

class ChangeFolderPage extends StatefulWidget {
  final Note note;
  const ChangeFolderPage(this.note, {Key? key}) : super(key: key);

  @override
  _ChangeFolderPageState createState() => _ChangeFolderPageState();

  static Route route(Note note) {
    return MaterialPageRoute(builder: (context) => ChangeFolderPage(note));
  }
}

class _ChangeFolderPageState extends State<ChangeFolderPage> {
  bool createFolder = false;
  String? folder;

  @override
  void initState() {
    super.initState();
    folder = widget.note.folder;
  }

  Future<void> changeFolder() async {
    await context.read(notesLogicProvider).changeFolder(widget.note.id, folder);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Folder"),
      ),
      body: Consumer(
        builder: (context, watch, _) {
          var folders = watch(foldersProvider);

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: folders.length + 1,
            itemBuilder: (context, index) {
              if (index < folders.length) {
                return ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: Text(folders[index]),
                  tileColor: folders[index] == folder ? context.getTextColor().withOpacity(0.1) : null,
                  onTap: () {
                    folder = folders[index];
                    changeFolder();
                  },
                );
              } else {
                if (createFolder) {
                  return ListTile(
                      title: TextField(
                    decoration: const InputDecoration(
                      labelText: "Folder",
                    ),
                    autofocus: true,
                    onSubmitted: (text) {
                      folder = text;
                      changeFolder();
                    },
                  ));
                } else {
                  return ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    title: const Text("Create new folder"),
                    onTap: () {
                      setState(() => createFolder = true);
                    },
                  );
                }
              }
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
