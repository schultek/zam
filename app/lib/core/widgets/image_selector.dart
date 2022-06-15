library image_selector;

import 'dart:io';
import 'dart:typed_data';

import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/extensions.dart';

class ImageSelector {
  static Future<Uint8List?> open(
    BuildContext context, {
    ImageSource source = ImageSource.gallery,
    bool crop = true,
    double cropAspectRatio = 1,
    OverlayType cropOverlayType = OverlayType.none,
    double? maxWidth,
  }) async {
    XFile? image = await ImagePicker().pickImage(source: source, maxWidth: maxWidth);
    if (image == null) return null;

    if (crop) {
      return CropDialog.show(context, image, aspectRatio: cropAspectRatio, overlayType: cropOverlayType);
    } else {
      return image.readAsBytes();
    }
  }
}

class CropDialog extends StatefulWidget {
  final XFile image;
  final double aspectRatio;
  final OverlayType overlayType;

  const CropDialog({
    required this.image,
    this.aspectRatio = 1,
    this.overlayType = OverlayType.none,
    Key? key,
  }) : super(key: key);

  @override
  _CropDialogState createState() => _CropDialogState();

  static Future<Uint8List?> show(
    BuildContext context,
    XFile image, {
    double aspectRatio = 1,
    OverlayType overlayType = OverlayType.none,
  }) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CropDialog(
              image: image,
              aspectRatio: aspectRatio,
              overlayType: overlayType,
            )));
  }
}

class _CropDialogState extends State<CropDialog> {
  final _cropperKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.cut_picture),
        actions: [
          IconButton(
            onPressed: () async {
              var bytes = await Cropper.crop(cropperKey: _cropperKey, pixelRatio: 1);
              Navigator.of(context).pop(bytes);
            },
            icon: const Icon(Icons.check),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Cropper(
                cropperKey: _cropperKey, // Use your key here
                image: Image.file(File(widget.image.path)),
                aspectRatio: widget.aspectRatio,
                overlayType: widget.overlayType,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
