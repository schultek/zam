import 'dart:io';

import 'package:flutter/material.dart';

import '../../../providers/photos/photos_provider.dart';

class SelectableImage extends StatelessWidget {
  final File file;
  final bool selected;
  final FileUploadStatus? status;
  final void Function(bool selected) onSelect;
  const SelectableImage({required this.file, this.selected = false, this.status, required this.onSelect, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (status != FileUploadStatus.completed && status != FileUploadStatus.uploading) {
          onSelect(!selected);
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              file,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: indicatorIcon(),
          ),
        ],
      ),
    );
  }

  Widget indicatorIcon() {
    if (status == FileUploadStatus.completed) {
      return Icon(Icons.cloud_done, color: Colors.grey.shade400);
    } else if (status == FileUploadStatus.uploading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 2,
        ),
      );
    } else {
      return Icon(selected ? Icons.check_circle : Icons.circle_outlined);
    }
  }
}
