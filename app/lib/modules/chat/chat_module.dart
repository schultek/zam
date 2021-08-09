import '../../core/module/module.dart';
import 'chat_page.dart';

@Module()
class ChatModule {
  @ModuleItem(id: "chat")
  PageSegment getChatPage() {
    return PageSegment(
      builder: (context) => ChatPage(),
    );
  }
}
