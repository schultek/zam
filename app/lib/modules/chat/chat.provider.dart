part of chat_module;

final channelsProvider = StreamProvider<List<ChannelInfo>>((ref) => ref
    .watch(moduleDocProvider('chat'))
    .collection('channels')
    .where('members', arrayContains: ref.watch(userIdProvider))
    .snapshotsMapped<ChannelInfo>());

final channelProvider =
    Provider.family((ref, String id) => ref.watch(channelsProvider).asData?.value.where((c) => c.id == id).firstOrNull);

final channelsToJoinProvider = StreamProvider<List<ChannelInfo>>((ref) => ref
    .watch(moduleDocProvider('chat'))
    .collection('channels')
    .where('isOpen', isEqualTo: true)
    .snapshotsMapped<ChannelInfo>()
    .map((c) =>
        c.where((c) => ref.watch(channelsProvider).asData?.value.every((cc) => cc.id != c.id) ?? true).toList()));

final channelMessagesProvider = StreamProvider.family((ref, String id) => ref
    .watch(moduleDocProvider('chat'))
    .collection('channels/$id/messages')
    .orderBy('sentAt', descending: true)
    .snapshots()
    .map((s) => s.docs.map((doc) => Mapper.fromValue<ChatMessage>(doc.toMap())).toList()));

final chatApiProvider = Provider((ref) => ref.watch(apiProvider).chat);
final chatLogicProvider = Provider((ref) => ChatLogic(ref));

class ChatLogic {
  final Ref ref;
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

  Future<void> updateChannel(String channelId, Map<String, dynamic> data) async {
    await chat.collection('channels').doc(channelId).update(data);
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

  Future<void> send(String channelId, String text) async {
    var msgDoc = await chat
        .collection('channels/$channelId/messages')
        .add(ChatTextMessage(sender: ref.read(userIdProvider)!, text: text, sentAt: DateTime.now()).toMap());
    var channelName = ref.read(channelProvider(channelId))?.name;
    var userName =
        ref.read(groupUserByIdProvider(ref.read(userIdProvider) ?? ''))?.nickname ?? ref.read(l10nProvider).anonymous;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: msgDoc.id.hashCode,
        channelKey: 'basic_channel',
        groupKey: 'jufa',
        summary: 'hello summary',
        title: channelName ?? ref.read(l10nProvider).message,
        body: '$userName: $text',
        // notificationLayout: NotificationLayout.Messaging,
      ),
      actionButtons: [
        NotificationActionButton(key: 'close', label: 'Close', buttonType: ActionButtonType.Default),
        NotificationActionButton(key: 'reply', label: 'Reply', buttonType: ActionButtonType.InputField),
      ],
    );

    // ref.read(chatApiProvider).sendNotification(ChatNotification(
    //       ref.read(selectedGroupIdProvider)!,
    //       channelId,
    //       msgDoc.id,
    //       channelName ?? ref.read(l10nProvider).message,
    //       '$userName: $text',
    //     ));
  }

  Future<void> sendImage(String channelId, XFile res) async {
    var file = File(res.path);
    var size = file.lengthSync();
    var name = res.name;

    try {
      var uri = await ref
          .read(groupsLogicProvider) //
          .uploadFile('chat/images/$name', await file.readAsBytes());

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
      var uri = await ref
          .read(groupsLogicProvider) //
          .uploadFile('chat/files/${resFile.name}', await file.readAsBytes());
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
