import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' show ChatTheme;

class CustomChatTheme extends ChatTheme {
  CustomChatTheme(ThemeData theme)
      : super(
          attachmentButtonIcon: const Icon(Icons.link),
          backgroundColor: theme.scaffoldBackgroundColor,
          dateDividerMargin: const EdgeInsets.only(
            bottom: 32,
            top: 16,
          ),
          dateDividerTextStyle: TextStyle(
            color: theme.colorScheme.onBackground,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            height: 1.333,
          ),
          deliveredIcon: null,
          documentIcon: null,
          emptyChatPlaceholderTextStyle: TextStyle(
            color: theme.colorScheme.onBackground,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          errorColor: theme.colorScheme.error,
          errorIcon: null,
          inputBackgroundColor: theme.backgroundColor,
          inputBorderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          inputPadding: EdgeInsets.zero,
          inputTextColor: theme.colorScheme.onSurface,
          inputTextCursorColor: null,
          inputTextDecoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isCollapsed: true,
            fillColor: theme.backgroundColor,
          ),
          inputTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          inputMargin: EdgeInsets.zero,
          messageBorderRadius: 20,
          messageInsetsHorizontal: 20,
          messageInsetsVertical: 16,
          primaryColor: theme.colorScheme.primary,
          receivedEmojiMessageTextStyle: const TextStyle(fontSize: 40),
          receivedMessageBodyTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          receivedMessageCaptionTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.333,
          ),
          receivedMessageDocumentIconColor: theme.colorScheme.primary,
          receivedMessageLinkDescriptionTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.428,
          ),
          receivedMessageLinkTitleTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            height: 1.375,
          ),
          secondaryColor: theme.cardColor,
          seenIcon: null,
          sendButtonIcon: null,
          sendingIcon: null,
          sentEmojiMessageTextStyle: const TextStyle(fontSize: 40),
          sentMessageBodyTextStyle: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          sentMessageCaptionTextStyle: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.333,
          ),
          sentMessageDocumentIconColor: theme.colorScheme.onPrimary,
          sentMessageLinkDescriptionTextStyle: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.428,
          ),
          sentMessageLinkTitleTextStyle: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            height: 1.375,
          ),
          statusIconPadding: const EdgeInsets.symmetric(horizontal: 4),
          userAvatarImageBackgroundColor: Colors.transparent,
          userAvatarNameColors: [theme.colorScheme.primary],
          userAvatarTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            height: 1.333,
          ),
          userNameTextStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            height: 1.333,
          ),
        );
}
