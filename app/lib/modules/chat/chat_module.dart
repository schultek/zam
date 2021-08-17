import '../../core/module/module.dart';
import 'chat_page.dart';

@Module('chat')
class ChatModule {
  @ModuleItem('chat')
  PageSegment getChatPage() {
    return PageSegment(
      builder: (context) => ChatPage(),
    );
  }
}
