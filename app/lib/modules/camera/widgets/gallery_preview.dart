import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../files_provider.dart';
import '../pages/gallery_page.dart';

class GalleryPreview extends StatelessWidget {
  const GalleryPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(GalleryPage.route());
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          width: 40,
          height: 40,
          child: Consumer(
            builder: (context, ref, child) {
              var lastPicture = ref.watch(lastPictureProvider);
              if (lastPicture == null) return child!;
              return Image.memory(lastPicture.thumbData);
            },
            child: const Icon(Icons.image),
          ),
        ),
      ),
    );
  }
}
