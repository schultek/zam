import 'package:flutter/material.dart';

import '../../module.dart';
import '../builders/notes_cards_builder.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();

  static Route route() {
    return MaterialPageRoute(builder: (context) => const NotesPage());
  }
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.notes),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: NotesCardsBuilder(true)(context),
        ),
      ),
    );
  }
}
