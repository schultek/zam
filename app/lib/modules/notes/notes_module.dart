import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/module/module.dart';
import '../../providers/firebase/doc_provider.dart';
import '../../providers/trips/selected_trip_provider.dart';
import 'notes_page.dart';
import 'select_note_page.dart';

@Module()
class NotesModule {
  @ModuleItem(id: "notes")
  ContentSegment getNotes() {
    return ContentSegment(
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sticky_note_2,
                color: context.getTextColor(),
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                "Notes",
                style: Theme.of(context).textTheme.headline6!.copyWith(color: context.getTextColor()),
              ),
            ],
          ),
        ),
      ),
      onNavigate: (context) => const NotesPage(),
    );
  }

  @ModuleItem(id: "note")
  ContentSegment? getNote(BuildContext context, String? id) {
    if (id == null) {
      if (context.read(tripUserProvider)!.isOrganizer) {
        var idProvider = IdProvider();
        return ContentSegment(
          idProvider: idProvider,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Icon(
                Icons.add,
                color: context.getTextColor(),
                size: 50,
              ),
            ),
          ),
          onNavigate: (context) {
            return SelectNotePage(
              onSelect: (id) => idProvider.provide(context, id),
            );
          },
        );
      } else {
        return null;
      }
    }

    return ContentSegment(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: loadNote(context, id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text((snapshot.data?["title"] as String?) ?? "Untitled Note",
                    style: TextStyle(color: context.getTextColor()));
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> loadNote(BuildContext context, String id) async {
    var doc = await context.read(moduleDocProvider('notes')).collection("notes").doc(id).get();
    return doc.data();
  }
}
