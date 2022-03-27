import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../../helpers/extensions.dart';
import '../../../helpers/optional.dart';
import '../notes_provider.dart';

class ChangeFolderPage extends StatefulWidget {
  final String? folder;
  final bool allowCreate;
  const ChangeFolderPage(this.folder, {this.allowCreate = false, Key? key}) : super(key: key);

  @override
  _ChangeFolderPageState createState() => _ChangeFolderPageState();

  static Route<Optional<String?>?> route(String? folder, {bool allowCreate = false}) {
    return MaterialPageRoute(builder: (context) => ChangeFolderPage(folder, allowCreate: allowCreate));
  }
}

class _ChangeFolderPageState extends State<ChangeFolderPage> {
  bool createFolder = false;
  String? folder;

  @override
  void initState() {
    super.initState();
    folder = widget.folder;
  }

  Future<void> changeFolder() async {
    Navigator.of(context).pop(Optional(folder));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.change_folder),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          var folders = ref.watch(foldersProvider);

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: folders.length + (widget.allowCreate ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < folders.length) {
                return ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: Text(folders[index] ?? context.tr.no_folder),
                  tileColor: folders[index] == folder ? context.onSurfaceColor.withOpacity(0.1) : null,
                  onTap: () {
                    folder = folders[index];
                    changeFolder();
                  },
                );
              } else {
                if (createFolder) {
                  return ListTile(
                      title: TextField(
                    decoration: InputDecoration(
                      labelText: context.tr.folder,
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
                    title: Text(context.tr.create_new_folder),
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
