part of chat_module;

@MappableClass()
class ChannelInfo {
  final String name;
  final String id;
  final bool isOpen;
  final List<String> members;

  ChannelInfo({required this.id, required this.name, this.isOpen = true, this.members = const []});

  StreamProvider<List<ChatMessage>> get messages => channelMessagesProvider(id);
}

@MappableClass(discriminatorKey: 'type')
class ChatMessage {
  final String sender;
  final String text;
  final DateTime sentAt;

  ChatMessage({required this.sender, required this.text, required this.sentAt});
}

@MappableClass(discriminatorValue: 'text')
class ChatTextMessage extends ChatMessage {
  ChatTextMessage({required String sender, required String text, required DateTime sentAt})
      : super(sender: sender, text: text, sentAt: sentAt);
}

@MappableClass(discriminatorValue: 'image')
class ChatImageMessage extends ChatMessage {
  final String uri;
  final int size;

  ChatImageMessage({
    required this.uri,
    required this.size,
    required String sender,
    required String text,
    required DateTime sentAt,
  }) : super(sender: sender, text: text, sentAt: sentAt);
}

@MappableClass(discriminatorValue: 'file')
class ChatFileMessage extends ChatMessage {
  final String uri;
  final int size;

  ChatFileMessage({
    required this.uri,
    required this.size,
    required String sender,
    required String text,
    required DateTime sentAt,
  }) : super(sender: sender, text: text, sentAt: sentAt);
}
