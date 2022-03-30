library notes_module;

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../module.dart';
import 'builders/notes_cards_builder.dart';
import 'builders/notes_settings_builder.dart';
import 'pages/edit_note_page.dart';
import 'pages/notes_page.dart';
import 'pages/select_note_page.dart';
import 'widgets/folder_card.dart';
import 'widgets/note_preview.dart';
import 'widgets/notes_list.dart';

export '../module.dart';

part 'elements/add_note_action_element.dart';
part 'elements/notes_action_element.dart';
part 'elements/notes_content_element.dart';
part 'elements/notes_grid_content_element.dart';
part 'elements/notes_list_content_element.dart';
part 'elements/notes_list_page_element.dart';
part 'elements/single_note_content_element.dart';
part 'notes.models.dart';
part 'notes.provider.dart';

class NotesModule extends ModuleBuilder {
  NotesModule() : super('notes');

  @override
  String getName(BuildContext context) => context.tr.notes;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {
        'notes_action': NotesActionElement(),
        'add_note_action': AddNoteActionElement(),
        'notes': NotesContentElement(),
        'note': SingleNoteContentElement(),
        'notes_grid': NotesGridContentElement(),
        'notes_list': NotesListContentElement(),
        'notes_list_page': NotesListPageElement(),
      };
}
