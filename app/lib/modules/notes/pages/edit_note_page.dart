import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../notes.module.dart';
import 'note_info_page.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  const EditNotePage(this.note, {Key? key}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();

  static Route route(Note note) {
    return MaterialPageRoute(builder: (_) => EditNotePage(note));
  }
}

enum SaveMode { idle, saving, saved }

class _EditNotePageState extends State<EditNotePage> {
  late final QuillController _controller;
  late final TextEditingController _titleController;
  late final ScrollController _scrollController;

  double _noteOpacity = 0.0;

  final editorFocusNode = FocusNode();
  final editorFocusListenable = ValueNotifier(false);

  ProviderSubscription<AsyncValue<Note?>>? _noteSub;

  bool get isEditor => _currentNote.editors.contains(context.read(userIdProvider));
  bool get isAuthor => context.read(isOrganizerProvider) || widget.note.author == context.read(userIdProvider);

  SaveMode saveMode = SaveMode.idle;
  late Note _currentNote;

  @override
  void initState() {
    super.initState();

    _currentNote = widget.note;
    if (_currentNote.content.isEmpty) {
      _currentNote = _currentNote.copyWith(content: (Delta()..insert('\n')).toJson());
    }

    _controller = QuillController(
      document: widget.note.content.isEmpty ? Document() : Document.fromJson(widget.note.content),
      selection: const TextSelection.collapsed(offset: 0),
    )..document.changes.listen((e) => debouncedSave());

    _titleController = TextEditingController(text: widget.note.title)..addListener(debouncedSave);

    _scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      setState(() {
        _noteOpacity = 1;
      });
    });

    editorFocusNode.addListener(() {
      editorFocusListenable.value = editorFocusNode.hasPrimaryFocus;
    });
  }

  @override
  void didChangeDependencies() {
    _noteSub?.close();
    _noteSub = context.subscribe<AsyncValue<Note?>>(noteProvider(widget.note.id), (_, value) {
      var note = value.value;
      if (note != null) {
        _currentNote = note;

        if (_titleController.text != note.title) {
          _titleController.text = note.title ?? '';
        }

        var newDelta = Delta.fromJson(note.content);
        var currDelta = _controller.document.toDelta();
        if (newDelta != currDelta) {
          _controller.document
            ..delete(0, _controller.document.length)
            ..compose(newDelta, ChangeSource.REMOTE);
        }
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _noteSub?.close();
    _controller.dispose();
    _saveTimer?.cancel();
    super.dispose();
  }

  Timer? _saveTimer;

  Future<void> debouncedSave() async {
    if (!isEditor) return;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), _saveNote);
  }

  Future<void> _saveNote() async {
    var currDelta = Delta.fromJson(_currentNote.content);
    var updatedDelta = _controller.document.toDelta();

    var hasChanged = currDelta != updatedDelta || (_currentNote.title ?? '') != _titleController.text;
    if (hasChanged) {
      setState(() {
        saveMode = SaveMode.saving;
      });
      try {
        await context.read(notesLogicProvider).updateNote(
            widget.note.id,
            _currentNote.copyWith(
              title: _titleController.text,
              content: updatedDelta.toJson(),
            ));
      } finally {
        setState(() {
          saveMode = SaveMode.saved;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (saveMode == SaveMode.saving)
            const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 1)))
          else if (saveMode == SaveMode.saved)
            Center(child: Opacity(opacity: 0.5, child: Text(context.tr.saved))),
          if (isAuthor)
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                onPressed: () async {
                  if (isEditor) {
                    await _saveNote();
                  }
                  var nav = Navigator.of(context);
                  var logic = context.read(notesLogicProvider);
                  var template = Template.of(context, listen: false);
                  var shouldDelete = await nav.push<bool>(NoteInfoPage.route(widget.note));
                  if (shouldDelete == true) {
                    logic.deleteNote(widget.note.id);
                    template.removeWidgetsWithParams(widget.note.id);
                    nav.pop();
                  }
                },
                icon: const Icon(Icons.info),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Builder(
            builder: (context) => Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!editorFocusNode.hasPrimaryFocus) {
                    editorFocusNode.requestFocus();
                  }
                  _controller.updateSelection(const TextSelection.collapsed(offset: 99999), ChangeSource.LOCAL);
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    opacity: _noteOpacity,
                    duration: const Duration(milliseconds: 200),
                    child: ListView(
                      shrinkWrap: true,
                      reverse: true,
                      controller: _scrollController,
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
                          keyboardAppearance: context.theme.brightness,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            autofocus: isEditor && (widget.note.title ?? '').isEmpty,
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: context.tr.title,
                              filled: false,
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontSize: 30, color: context.onSurfaceColor),
                            onChanged: (_) => debouncedSave(),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => editorFocusNode.requestFocus(),
                            readOnly: !isEditor,
                          ),
                        ),
                      ],
                    ),
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
                  return ThemedSurface(
                    builder: (context, fillColor) => Container(
                      color: fillColor,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        scrollDirection: Axis.horizontal,
                        child: QuillToolbar.basic(
                          controller: _controller,
                          onImagePickCallback: (file) async {
                            return logic.uploadFile(widget.note.id, file);
                          },
                          onVideoPickCallback: (file) async {
                            return logic.uploadFile(widget.note.id, file);
                          },
                          showCameraButton: false,
                          dialogTheme: QuillDialogTheme(
                            dialogBackgroundColor: context.surfaceColor,
                          ),
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
    );
  }
}
