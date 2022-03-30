part of chat_module;

class ChannelsPageElement with ElementBuilderMixin<PageElement> {
  @override
  FutureOr<PageElement?> build(ModuleContext module) {
    return PageElement(
      module: module,
      builder: (context) {
        if (WidgetSelector.existsIn(context)) {
          return ThemedSurface(
            builder: (context, color) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: color,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.chat, size: MediaQuery.of(context).size.width / 2),
            ),
          );
        }
        return const ChannelList();
      },
    );
  }
}
