import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' show XFile;

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
    .collection('channels/$id/messages')
    .orderBy('sentAt', descending: true)
    .snapshots()
    .map((s) => s.docs.map((doc) => Mapper.fromValue<ChatMessage>(doc.toMap())).toList()));

final chatLogicProvider = Provider((ref) => ChatLogic(ref));

class ChatLogic {
  final ProviderReference ref;
  final DocumentReference chat;
  ChatLogic(this.ref) : chat = ref.watch(moduleDocProvider('chat'));

  Future<ChannelInfo> addChannel(String name, {bool isOpen = true, List<String> members = const []}) async {
    var doc = await chat.collection('channels').add({
      'name': name,
      'isOpen': isOpen,
      'members': members,
    });
    return Mapper.fromValue<ChannelInfo>((await doc.get()).toMap());
  }

  Future<void> delete(String id) async {
    await chat.collection('channels').doc(id).delete();
  }

  void send(String channelId, String text) {
    chat.collection('channels/$channelId/messages').add(ChatTextMessage(
          sender: ref.read(userIdProvider)!,
          text: text,
          sentAt: DateTime.now(),
        ).toMap());
  }

  Future<void> joinChannel(ChannelInfo channel) async {
    await chat.collection('channels').doc(channel.id).update({
      'members': FieldValue.arrayUnion([ref.read(userIdProvider)]),
    });
  }

  Future<void> leaveChannel(String channelId) async {
    await chat.collection('channels').doc(channelId).update({
      'members': FieldValue.arrayRemove([ref.read(userIdProvider)]),
    });
  }

  Future<void> addMembers(String id, List<String> members) async {
    await chat.collection('channels').doc(id).update({
      'members': FieldValue.arrayUnion(members),
    });
  }

  Future<void> sendImage(String channelId, XFile res) async {
    var file = File(res.path);
    var size = file.lengthSync();
    var name = res.name;

    try {
      var reference = FirebaseStorage.instance.ref('chat/images/$name');
      await reference.putFile(file);
      var uri = await reference.getDownloadURL();

      chat.collection('channels/$channelId/messages').add(ChatImageMessage(
            sender: ref.read(userIdProvider)!,
            text: '',
            sentAt: DateTime.now(),
            uri: uri,
            size: size,
          ).toMap());
    } on FirebaseException catch (e) {
      print('ERROR ON SENDING IMAGE $e');
      return;
    }
  }

  Future<void> sendFile(String channelId, FilePickerResult res) async {
    var resFile = res.files.single;
    var file = File(resFile.path!);

    try {
      var reference = FirebaseStorage.instance.ref('chat/files/${resFile.name}');
      await reference.putFile(file);
      var uri = await reference.getDownloadURL();
      // lookupMimeType(filePath ?? '')
      chat.collection('channels/$channelId/messages').add(ChatFileMessage(
            sender: ref.read(userIdProvider)!,
            text: '',
            sentAt: DateTime.now(),
            uri: uri,
            size: resFile.size,
          ).toMap());
    } on FirebaseException catch (e) {
      print('ERROR ON SENDING FILE $e');
      return;
    }
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
