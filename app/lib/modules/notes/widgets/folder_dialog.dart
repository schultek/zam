import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notes.module.dart';
import '../pages/edit_note_page.dart';
import 'note_card.dart';
import 'note_preview.dart';

class FolderDialog extends StatelessWidget {
  final String folder;

  const FolderDialog(this.folder, {Key? key}) : super(key: key);

  static Future<void> show(BuildContext context, String folder) {
    return showDialog(
      context: context,
      builder: (context) => FolderDialog(folder),
      useRootNavigator: false,
      barrierColor: Colors.black45,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 86),
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Consumer(
                builder: (context, ref, _) {
                  var notes = ref.watch(notesProvider).asData?.value.where((n) => n.folder == folder) ?? [];

                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      for (var note in notes)
                        FittedBox(
                          child: ConstrainedBox(
                            constraints: constraints.scale(0.5),
                            child: NoteCard(
                              needsSurface: true,
                              child: NotePreview(note: note),
                              onTap: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(EditNotePage.route(note));
                              },
                            ),
                          ),
                        ),
                      NoteCard(
                        needsSurface: true,
                        child: const Center(
                          child: Icon(Icons.add, size: 30),
                        ),
                        onTap: () {
                          var note = ref.read(notesLogicProvider).createEmptyNote(folder: folder);
                          Navigator.of(context).push(EditNotePage.route(note));
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on BoxConstraints {
  BoxConstraints scale(double factor) => copyWith(
        minWidth: minWidth * factor,
        minHeight: minHeight * factor,
        maxWidth: maxWidth * factor,
        maxHeight: maxHeight * factor,
      );
}
