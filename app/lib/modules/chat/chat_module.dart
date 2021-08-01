import '../../core/module/module.dart';
import 'chat_page.dart';

@Module()
class ChatModule {
  ModuleData moduleData;
  ChatModule(this.moduleData);

  @ModuleItem(id: "chat")
  ContentSegment getChatPage() {
    return ContentSegment(
      size: SegmentSize.Wide,
      allow: const [SegmentAllow.FullScreen],
      builder: (context) => ChatPage(moduleData),
    );
  }
}
