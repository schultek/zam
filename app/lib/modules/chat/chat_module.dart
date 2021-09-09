import 'package:flutter/material.dart';

import '../../core/module/module.dart';
import '../../core/widgets/widget_selector.dart';
import 'pages/chat_page.dart';

@Module('chat')
class ChatModule {
  @ModuleItem('chat')
  PageSegment getChatPage() {
    return PageSegment(
      builder: (context) {
        if (WidgetSelector.existsIn(context)) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: context.getTextColor(),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.chat, size: MediaQuery.of(context).size.width / 2),
          );
        }
        return ChatPage();
      },
    );
  }
}
