import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/user_provider.dart';
import '../../providers/firebase/doc_provider.dart';

final channelsProvider = StreamProvider((ref) => ref
    .watch(moduleDocProvider('chat'))
    .collection('channels')
    .snapshots()
    .map((s) => s.docs.map((doc) => ChannelInfo(id: doc.id, name: doc.get("name") as String)).toList()));

final channelMessagesProvider = StreamProvider.family((ref, String id) => ref
    .watch(moduleDocProvider('chat'))
    .collection("channels/$id/messages")
    .snapshots()
    .map((s) => s.docs
        .map((doc) => ChatMessage(
            sender: doc.get("sender") as String,
            text: doc.get("text") as String,
            sentAt: DateTime.parse(doc.get("sentAt") as String)))
        .toList()));

final chatLogicProvider = Provider((ref) => ChatLogic(ref));

class ChatLogic {
  final ProviderReference ref;
  final DocumentReference chat;
  ChatLogic(this.ref) : chat = ref.watch(moduleDocProvider('chat'));

  void addChannel(String name) {
    chat.collection("channels").add({"name": name});
  }

  void delete(String id) {
    chat.collection("channels").doc(id).delete();
  }

  void send(String channelId, String text) {
    chat.collection("channels/$channelId/messages").add({
      "sender": ref.read(userIdProvider),
      "text": text,
      "sentAt": DateTime.now().toUtc().toIso8601String(),
    });
  }
}

class ChannelInfo {
  final String name;
  final String id;

  ChannelInfo({required this.id, required this.name});

  StreamProvider<List<ChatMessage>> get messages => channelMessagesProvider(id);
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime sentAt;

  ChatMessage({required this.sender, required this.text, required this.sentAt});
}
