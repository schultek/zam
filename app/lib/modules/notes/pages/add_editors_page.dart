import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../helpers/extensions.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../../../widgets/user_avatar.dart';
import '../notes_provider.dart';

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
        title: Text(context.tr.add_editors),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: setEditors,
          )
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          var users = ref.watch(selectedTripProvider)!.users.entries.toList();

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: users.length,
            itemBuilder: (context, index) => CheckboxListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              value: isEditor[users[index].key] ?? false,
              onChanged: (v) {
                setState(() => isEditor = {...isEditor, users[index].key: v ?? false});
              },
              title: Text(users[index].value.nickname ?? context.tr.anonymous),
              controlAffinity: ListTileControlAffinity.trailing,
              secondary: UserAvatar(id: users[index].key),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
