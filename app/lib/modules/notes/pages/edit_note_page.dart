import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../core/areas/areas.dart';
import '../../../core/module/module.dart' hide Brightness;
import '../../../providers/auth/user_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../notes_provider.dart';
import 'note_info_page.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  final WidgetAreaState? area;
  const EditNotePage(this.note, {this.area, Key? key}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();

  static Route route(Note note) {
    return MaterialPageRoute(builder: (_) => EditNotePage(note));
  }
}

class _EditNotePageState extends State<EditNotePage> {
  late final QuillController _controller;
  final editorFocusNode = FocusNode();
  final editorFocusListenable = ValueNotifier(false);
  String? _title;

  bool get isEditor => widget.note.editors.contains(context.read(userIdProvider));
  bool get isAuthor => context.read(isOrganizerProvider) || widget.note.author == context.read(userIdProvider);

  @override
  void initState() {
    super.initState();
    _controller = QuillController(
      document: widget.note.content.isEmpty ? Document() : Document.fromJson(widget.note.content),
      selection: const TextSelection.collapsed(offset: 0),
    );
    editorFocusNode.addListener(() {
      editorFocusListenable.value = editorFocusNode.hasPrimaryFocus;
    });
  }

  Future<void> saveNote() async {
    var content = _controller.document.toDelta().toJson();
    await context.read(notesLogicProvider).updateNote(
          widget.note.id,
          widget.note.copyWith(title: _title, content: content),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isAuthor)
            IconButton(
              onPressed: () async {
                await saveNote();
                var nav = Navigator.of(context);
                var logic = context.read(notesLogicProvider);
                var shouldDelete = await nav.push<bool>(NoteInfoPage.route(widget.note));
                if (shouldDelete == true) {
                  logic.deleteNote(widget.note.id);
                  widget.area?.removeWidgetWithId(widget.note.id);
                  nav.pop();
                }
              },
              icon: const Icon(Icons.info),
            ),
          if (isEditor)
            IconButton(
              onPressed: () async {
                await saveNote();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: TripTheme.of(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(
              builder: (context) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!editorFocusNode.hasPrimaryFocus) {
                      editorFocusNode.requestFocus();
                    }
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView(
                      shrinkWrap: true,
                      reverse: true,
                      children: [
                        QuillEditor(
                          controller: _controller,
                          scrollController: ScrollController(),
                          scrollable: false,
                          focusNode: editorFocusNode,
                          autoFocus: false,
                          readOnly: !isEditor,
                          expands: false,
                          padding: const EdgeInsets.all(20.0),
                          keyboardAppearance: Brightness.dark,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextFormField(
                            decoration: const InputDecoration(hintText: 'Title'),
                            style: TextStyle(fontSize: 30, color: context.getTextColor()),
                            initialValue: widget.note.title,
                            onChanged: (text) => _title = text,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => editorFocusNode.requestFocus(),
                            readOnly: !isEditor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isEditor)
              ValueListenableBuilder<bool>(
                valueListenable: editorFocusListenable,
                builder: (context, value, _) {
                  var logic = context.read(notesLogicProvider);
                  if (value) {
                    return FillColor(
                      builder: (context, fillColor) => Container(
                        color: fillColor,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          scrollDirection: Axis.horizontal,
                          child: QuillToolbar.basic(
                            controller: _controller,
                            onImagePickCallback: (file) async {
                              return logic.uploadImage(widget.note.id, file);
                            },
                            showCameraButton: false,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
