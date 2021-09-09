import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o_color_picker/o_color_picker.dart';

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
  Announcement announcement = Announcement(message: '');

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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FillColor(
              builder: (context, fillColor) => Material(
                textStyle: TextStyle(color: context.getTextColor()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: fillColor.withOpacity(1),
                child: AnnouncementCard(announcement: AsyncValue.data(announcement), onDismissed: () {}),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
            style: TextStyle(color: context.getTextColor()),
            onChanged: (text) => setState(() => announcement = announcement.copyWith(title: text)),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Message',
            ),
            style: TextStyle(color: context.getTextColor()),
            onChanged: (text) => setState(() => announcement = announcement.copyWith(message: text)),
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            title: const Text('Dismissible'),
            onChanged: (dismiss) => setState(() => announcement = announcement.copyWith(isDismissible: dismiss)),
            value: announcement.isDismissible,
          ),
          const SizedBox(height: 20),
          ...colorPicker(
            label: 'Text Color',
            value: announcement.textColor,
            onRemove: () => setState(() => announcement = Announcement(
                  title: announcement.title,
                  message: announcement.message,
                  backgroundColor: announcement.backgroundColor,
                  isDismissible: announcement.isDismissible,
                )),
            onChange: (color) => setState(() => announcement = announcement.copyWith(textColor: color)),
          ),
          const SizedBox(height: 20),
          ...colorPicker(
            label: 'Background Color',
            value: announcement.backgroundColor,
            onRemove: () => setState(() => announcement = Announcement(
                  title: announcement.title,
                  message: announcement.message,
                  textColor: announcement.textColor,
                  isDismissible: announcement.isDismissible,
                )),
            onChange: (color) => setState(() => announcement = announcement.copyWith(backgroundColor: color)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Iterable<Widget> colorPicker(
      {required String label, Color? value, VoidCallback? onRemove, Function(Color)? onChange}) {
    return [
      Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyText1),
          const Spacer(),
          if (value != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onRemove,
            ),
        ],
      ),
      const SizedBox(height: 10),
      LayoutBuilder(
        builder: (context, constraints) => OColorPicker(
          key: ValueKey(value),
          selectedColor: value,
          boxSize: Size.square((constraints.maxWidth - (9 * 6)) / 7),
          onColorChange: onChange,
        ),
      ),
    ];
  }
}
