import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/themes/themes.dart';
import 'announcement_provider.dart';
import 'widgets/announcement_card.dart';

class AnnouncementPage extends StatefulWidget {
  final Function(String) onCreate;
  const AnnouncementPage({Key? key, required this.onCreate}) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  Announcement announcement = Announcement('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Announcement'),
        actions: [
          IconButton(
            onPressed: () async {
              var id = await context.read(announcementLogicProvider).createAnnouncement(announcement);
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 300), () => widget.onCreate(id));
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FillColor(
                builder: (context, fillColor) => Material(
                  textStyle: TextStyle(color: context.getTextColor()),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: fillColor.withOpacity(1),
                  child: AnnouncementCard(announcement: AsyncValue.data(announcement)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
              style: TextStyle(color: context.getTextColor()),
              onChanged: (text) => setState(() => announcement = announcement.copyWith(message: text)),
            ),
          ],
        ),
      ),
    );
  }
}
