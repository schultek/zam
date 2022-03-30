import 'package:flutter/material.dart';

import '../../module.dart';
import 'folder_dialog.dart';

class FolderCard extends StatelessWidget {
  final String folder;
  final bool needsSurface;
  const FolderCard({required this.folder, this.needsSurface = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (needsSurface) {
      return ThemedSurface(builder: (context, color) => buildCard(context, color));
    } else {
      return buildCard(context, null);
    }
  }

  Widget buildCard(BuildContext context, Color? color) {
    return GestureDetector(
      onTap: () {
        FolderDialog.show(context, folder);
      },
      child: Material(
        color: color ?? Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 8,
                  child: Icon(
                    Icons.folder,
                    size: 40,
                    color: context.onSurfaceHighlightColor,
                  ),
                ),
                const Spacer(),
                Flexible(
                  flex: 6,
                  child: Text(
                    folder,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, color: context.onSurfaceColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
