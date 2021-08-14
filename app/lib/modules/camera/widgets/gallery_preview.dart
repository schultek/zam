import 'package:flutter/material.dart';

import '../pages/gallery_page.dart';

class GalleryPreview extends StatelessWidget {
  const GalleryPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(GalleryPage.route());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
        width: 40,
        height: 40,
        child: const Icon(Icons.image),
      ),
    );
  }
}
