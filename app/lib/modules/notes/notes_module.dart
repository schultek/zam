import 'dart:async';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../core/core.dart';
import '../../core/widgets/widget_selector.dart';
import '../../helpers/extensions.dart';
import '../../providers/trips/selected_trip_provider.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/simple_card.dart';
import 'notes_provider.dart';
import 'pages/edit_note_page.dart';
import 'pages/notes_page.dart';
import 'pages/select_note_page.dart';
import 'widgets/note_preview.dart';
import 'widgets/notes_list.dart';

part 'actions.dart';
part 'fullpages.dart';
part 'segments.dart';

class NotesModule extends ModuleBuilder with NotesActionsModule, NotesSegmentsModule, NotesFullPagesModule {
  NotesModule() : super('notes');

  @override
  String getName(BuildContext context) => context.tr.notes;

  @override
  Map<String, ElementBuilder<ModuleElement>> get elements => {...segments, ...actions, ...fullpages};
}
