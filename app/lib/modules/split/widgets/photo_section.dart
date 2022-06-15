import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/core.dart';
import '../../../core/widgets/image_selector.dart';
import '../../../helpers/extensions.dart';

class PhotoSection extends StatefulWidget {
  const PhotoSection({required this.label, this.photo, required this.onPhotoAdded, required this.onDelete, Key? key})
      : super(key: key);

  final String label;
  final ImageProvider? photo;
  final ValueChanged<Uint8List> onPhotoAdded;
  final VoidCallback onDelete;

  @override
  State<PhotoSection> createState() => _PhotoSectionState();
}

class _PhotoSectionState extends State<PhotoSection> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(children: [
      ListTile(
        title: Text(widget.label),
        subtitle: Text(widget.photo != null ? context.tr.tap_to_change : context.tr.tap_to_add),
        leading: widget.photo != null
            ? SizedBox(
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          clipBehavior: Clip.antiAlias,
                          contentPadding: EdgeInsets.zero,
                          content: Image(image: widget.photo!),
                        );
                      },
                    );
                  },
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: Image(image: widget.photo!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              )
            : null,
        trailing: isLoading
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : widget.photo != null
                ? IconButton(
                    icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                    onPressed: widget.onDelete,
                  )
                : null,
        onTap: () async {
          setState(() => isLoading = true);
          try {
            var pngBytes = await ImageSelector.open(
              context,
              source: ImageSource.camera,
              crop: false,
              maxWidth: 800,
            );
            if (pngBytes != null) {
              widget.onPhotoAdded(pngBytes);
            }
          } finally {
            setState(() => isLoading = false);
          }
        },
      ),
    ]);
  }
}
