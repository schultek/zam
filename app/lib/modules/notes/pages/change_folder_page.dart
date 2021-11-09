import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/themes/themes.dart';
import '../notes_provider.dart';

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
        title: const Text('Change Folder'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          var folders = ref.watch(foldersProvider);

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: folders.length + 1,
            itemBuilder: (context, index) {
              if (index < folders.length) {
                return ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: Text(folders[index] ?? 'No Folder'),
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
                      labelText: 'Folder',
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
                    title: const Text('Create new folder'),
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
