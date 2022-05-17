import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../core.dart';

Future<String?> showEmojiKeyboard(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
        height: 250,
        child: EmojiPicker(
          onEmojiSelected: (Category category, Emoji emoji) {
            Navigator.of(context).pop(emoji.emoji);
          },
          config: Config(
            columns: 7,
            // Issue: https://github.com/flutter/flutter/issues/28894
            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            initCategory: Category.RECENT,
            bgColor: context.surfaceColor,
            indicatorColor: context.onSurfaceHighlightColor,
            iconColor: context.onSurfaceColor,
            iconColorSelected: context.onSurfaceHighlightColor,
            progressIndicatorColor: context.onSurfaceHighlightColor,
            backspaceColor: context.onSurfaceHighlightColor,
            skinToneDialogBgColor: context.surfaceColor,
            skinToneIndicatorColor: context.onSurfaceColor,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 28,
            noRecentsText: 'No Recents',
            noRecentsStyle: TextStyle(fontSize: 20, color: context.onSurfaceColor),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
          ),
        ),
      );
    },
  );
}
