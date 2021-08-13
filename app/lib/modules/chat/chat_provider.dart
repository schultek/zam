import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/firebase/doc_provider.dart';

final channelsProvider = StreamProvider<List<ChannelInfo>>((ref) => ref
    .watch(moduleDocProvider('chat'))
    .collection('channels')
    .where('members', arrayContains: ref.watch(userIdProvider))
    .snapshots()
    .map((s) => s.toList()));

final channelsToJoinProvider = StreamProvider<List<ChannelInfo>>((ref) => ref
    .watch(moduleDocProvider('chat'))
    .collection('channels')
    .where('isOpen', isEqualTo: true)
    .snapshots()
    .map((s) => s.toList<ChannelInfo>())
    .map((c) => c.where((c) => ref.watch(channelsProvider).data?.value.every((cc) => cc.id != c.id) ?? true).toList()));

final channelMessagesProvider = StreamProvider.family((ref, String id) => ref
    .watch(moduleDocProvider('chat'))
    .collection("channels/$id/messages")
    .orderBy('sentAt', descending: true)
    .snapshots()
    .map((s) => s.docs.map((doc) => Mapper.fromValue<ChatMessage>(doc.toMap())).toList()));

final chatLogicProvider = Provider((ref) => ChatLogic(ref));

class ChatLogic {
  final ProviderReference ref;
  final DocumentReference chat;
  ChatLogic(this.ref) : chat = ref.watch(moduleDocProvider('chat'));

  Future<ChannelInfo> addChannel(String name, {bool isOpen = true, List<String> members = const []}) async {
    var doc = await chat.collection("channels").add({
      "name": name,
      "isOpen": isOpen,
      "members": members,
    });
    return Mapper.fromValue<ChannelInfo>((await doc.get()).toMap());
  }

  Future<void> delete(String id) async {
    await chat.collection("channels").doc(id).delete();
  }

  void send(String channelId, String text) {
    chat.collection("channels/$channelId/messages").add({
      "sender": ref.read(userIdProvider),
      "text": text,
      "sentAt": DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> joinChannel(ChannelInfo channel) async {
    await chat.collection("channels").doc(channel.id).update({
      "members": FieldValue.arrayUnion([ref.read(userIdProvider)]),
    });
  }

  Future<void> addMembers(String id, List<String> members) async {
    await chat.collection("channels").doc(id).update({
      "members": FieldValue.arrayUnion(members),
    });
  }
}

@MappableClass()
class ChannelInfo {
  final String name;
  final String id;
  final bool isOpen;
  final List<String> members;

  ChannelInfo({required this.id, required this.name, this.isOpen = true, this.members = const []});

  StreamProvider<List<ChatMessage>> get messages => channelMessagesProvider(id);
}

@MappableClass()
class ChatMessage {
  final String sender;
  final String text;
  final DateTime sentAt;

  ChatMessage({required this.sender, required this.text, required this.sentAt});
}
