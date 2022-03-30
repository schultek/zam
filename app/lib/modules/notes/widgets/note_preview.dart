import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' show QuillController, QuillEditor, Document;

import '../notes.module.dart';

class NotePreview extends StatelessWidget {
  final Note note;
  final QuillController _controller;
  NotePreview({Key? key, required this.note})
      : _controller = QuillController(
          document: note.content.isEmpty ? Document() : Document.fromJson(note.content),
          selection: const TextSelection.collapsed(offset: 0),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (note.title != null)
            Text(
              note.title!,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, color: context.onSurfaceColor),
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 10),
          Expanded(
            child: ClipRect(
              child: FittedBox(
                alignment: Alignment.topLeft,
                fit: BoxFit.cover,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: AbsorbPointer(
                    child: ClipRect(
                      child: DefaultTextStyle(
                        style: TextStyle(color: context.onSurfaceColor),
                        child: QuillEditor(
                          controller: _controller,
                          scrollController: ScrollController(),
                          scrollable: false,
                          focusNode: FocusNode(),
                          autoFocus: false,
                          readOnly: true,
                          expands: false,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
