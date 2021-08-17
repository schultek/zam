import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/themes/themes.dart';
import '../../providers/firebase/doc_provider.dart';

class AnnouncementPage extends StatefulWidget {
  final Function(String) onCreate;
  const AnnouncementPage({Key? key, required this.onCreate}) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
              style: TextStyle(color: context.getTextColor()),
              onChanged: (text) => setState(() => message = text),
            ),
            TextButton(
              onPressed: message != null
                  ? () async {
                      var id = await createAnnouncement();
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 300), () => widget.onCreate(id));
                    }
                  : null,
              child: Text(
                'OK',
                style: TextStyle(color: context.getTextColor()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> createAnnouncement() async {
    var doc = await context.read(moduleDocProvider('announcements')).collection('announcements').add({
      'message': message,
    });
    return doc.id;
  }
}
