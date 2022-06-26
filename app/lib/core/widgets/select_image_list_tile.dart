import 'dart:async';
import 'dart:typed_data';

import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../themes/themes.dart';
import 'image_selector.dart';

class SelectImageListTile extends StatefulWidget {
  const SelectImageListTile({
    required this.label,
    this.hasImage = false,
    required this.onImageSelected,
    this.onDelete,
    this.crop,
    this.leading,
    this.maxWidth,
    Key? key,
  }) : super(key: key);

  final String label;
  final bool hasImage;
  final FutureOr<void> Function(Uint8List bytes) onImageSelected;
  final VoidCallback? onDelete;
  final OverlayType? crop;
  final Widget? leading;
  final double? maxWidth;

  @override
  State<SelectImageListTile> createState() => _SelectImageListTileState();
}

class _SelectImageListTileState extends State<SelectImageListTile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      subtitle: Text(widget.hasImage ? context.tr.tap_to_change : context.tr.tap_to_add),
      leading: widget.leading,
      trailing: isLoading
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : widget.hasImage && widget.onDelete != null
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
            crop: widget.crop != null,
            cropOverlayType: widget.crop ?? OverlayType.none,
            maxWidth: widget.maxWidth,
          );
          if (pngBytes != null) {
            await widget.onImageSelected(pngBytes);
          }
        } finally {
          setState(() => isLoading = false);
        }
      },
    );
  }
}
