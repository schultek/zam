library image_selector;

import 'dart:io';
import 'dart:typed_data';

import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/extensions.dart';

class ImageSelector {
  static Future<Uint8List?> fromGallery(BuildContext context) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    return CropDialog.show(context, image);
  }
}

class CropDialog extends StatefulWidget {
  final XFile image;

  const CropDialog({required this.image, Key? key}) : super(key: key);

  @override
  _CropDialogState createState() => _CropDialogState();

  static Future<Uint8List?> show(BuildContext context, XFile image) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (context) => CropDialog(image: image)));
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
              print(bytes?.length);
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
              child: AspectRatio(
                aspectRatio: 1,
                child: Cropper(
                  cropperKey: _cropperKey, // Use your key here
                  image: Image.file(File(widget.image.path)),
                  overlayType: OverlayType.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
