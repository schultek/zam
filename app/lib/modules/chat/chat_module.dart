import '../../core/module/module.dart';
import 'pages/chat_page.dart';

@Module('chat')
class ChatModule {
  @ModuleItem('chat')
  PageSegment getChatPage() {
    return PageSegment(
      builder: (context) => ChatPage(),
    );
  }
}
