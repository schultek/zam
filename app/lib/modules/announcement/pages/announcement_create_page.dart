import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o_color_picker/o_color_picker.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../announcement.module.dart';
import '../widgets/announcement_card.dart';

class AnnouncementPage extends StatefulWidget {
  final Function(String) onCreate;
  final AreaState<Area<ContentElement>, ContentElement> parentArea;
  const AnnouncementPage({
    Key? key,
    required this.onCreate,
    required this.parentArea,
  }) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  Announcement announcement = Announcement(message: '');
  bool isCreating = false;

  late final ContentElement fakeElement;

  @override
  void initState() {
    super.initState();
    fakeElement = ContentElement(
      module: ModuleContext<ContentElement>(context, AnnouncementModule(), 'announcements/announcement'),
      builder: (_) => Container(),
      size: ElementSize.wide,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.create_announcement),
        actions: [
          IconButton(
            onPressed: isCreating
                ? null
                : () async {
                    setState(() => isCreating = true);
                    try {
                      var id = await context.read(announcementLogicProvider).createAnnouncement(announcement);
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 300), () => widget.onCreate(id));
                    } finally {
                      setState(() => isCreating = false);
                    }
                  },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        children: [
          GroupTheme(
            theme: widget.parentArea.theme,
            child: Builder(builder: (context) {
              return Container(
                color: context.surfaceColor,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: widget.parentArea.constrainWidget(fakeElement),
                    child: widget.parentArea.elementDecorator.decorateElement(
                      context,
                      fakeElement,
                      AnnouncementCard(announcement: AsyncValue.data(announcement), onDismissed: () {}),
                    ),
                  ),
                ),
              );
            }),
          ),
          const Divider(
            height: 0,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: context.tr.title),
                  style: TextStyle(color: context.onSurfaceColor),
                  onChanged: (text) => setState(() => announcement = announcement.copyWith(title: text)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: context.tr.message),
                  style: TextStyle(color: context.onSurfaceColor),
                  onChanged: (text) => setState(() => announcement = announcement.copyWith(message: text)),
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  title: Text(context.tr.dismissible),
                  onChanged: (dismiss) => setState(() => announcement = announcement.copyWith(isDismissible: dismiss)),
                  value: announcement.isDismissible,
                ),
                const SizedBox(height: 20),
                ...colorPicker(
                  label: context.tr.text_color,
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
                  label: context.tr.background_color,
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
          ),
        ],
      ),
    );
  }

  Iterable<Widget> colorPicker({
    required String label,
    Color? value,
    VoidCallback? onRemove,
    Function(Color)? onChange,
  }) {
    return [
      Row(
        children: [
          Text(label, style: context.theme.textTheme.bodyText1),
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
