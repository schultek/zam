import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../chat.module.dart';
import '../widgets/attachment_bottom_sheet.dart';
import 'channel/channel_info_page.dart';
import 'channel/chat_theme.dart';

class ChannelPage extends StatefulWidget {
  final String id;
  const ChannelPage(this.id, {Key? key}) : super(key: key);

  static Route route(String id) {
    return MaterialPageRoute(builder: (context) => ChannelPage(id));
  }

  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  bool _isAttachmentUploading = false;

  Future<void> _handleFileSelection() async {
    var result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _setAttachmentUploading(true);
      await context.read(chatLogicProvider).sendFile(widget.id, result);
      _setAttachmentUploading(false);
    }
  }

  Future<void> _handleImageSelection() async {
    var result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      await context.read(chatLogicProvider).sendImage(widget.id, result);
      _setAttachmentUploading(false);
    }
  }

  // void _handleMessageTap(types.Message message) async {
  //   if (message is types.FileMessage) {
  //     var localPath = message.uri;
  //
  //     if (message.uri.startsWith('http')) {
  //       final client = http.Client();
  //       final request = await client.get(Uri.parse(message.uri));
  //       final bytes = request.bodyBytes;
  //       final documentsDir = (await getApplicationDocumentsDirectory()).path;
  //       localPath = '$documentsDir/${message.name}';
  //
  //       if (!File(localPath).existsSync()) {
  //         final file = File(localPath);
  //         await file.writeAsBytes(bytes);
  //       }
  //     }
  //
  //     await OpenFile.open(localPath);
  //   }
  // }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    print('PREVIEW FETCHED $previewData');
  }

  void _handleSendPressed(types.PartialText message) {
    context.read(chatLogicProvider).send(widget.id, message.text);
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var channel = ref.watch(channelProvider(widget.id));
        return Scaffold(
          appBar: AppBar(
            title: Text('# ${channel?.name}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: channel != null
                    ? () async {
                        var shouldLeave = await Navigator.of(context).push(ChannelInfoPage.route(channel));
                        if (shouldLeave == true) {
                          await context.read(chatLogicProvider).leaveChannel(widget.id);
                          Navigator.of(context).pop();
                        }
                      }
                    : null,
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SafeArea(
                  child: Consumer(
                    builder: (context, ref, _) {
                      List<ChatMessage> messages =
                          channel != null ? ref.watch(channel.messages).asData?.value ?? [] : [];
                      var group = ref.watch(selectedGroupProvider)!;

                      return Chat(
                        theme: CustomChatTheme(context.theme),
                        showUserAvatars: true,
                        showUserNames: true,
                        messages: messages.map((m) {
                          if (m is ChatImageMessage) {
                            return types.ImageMessage(
                              author: types.User(
                                id: m.sender,
                                imageUrl: group.users[m.sender]?.profileUrl,
                                firstName: group.users[m.sender]?.nickname ?? context.tr.anonymous,
                              ),
                              id: m.uri,
                              uri: m.uri,
                              name: m.uri,
                              size: m.size,
                            );
                          } else if (m is ChatFileMessage) {
                            return types.FileMessage(
                              author: types.User(
                                id: m.sender,
                                imageUrl: group.users[m.sender]?.profileUrl,
                                firstName: group.users[m.sender]?.nickname ?? context.tr.anonymous,
                              ),
                              id: m.uri,
                              uri: m.uri,
                              name: m.uri,
                              size: m.size,
                            );
                          } else {
                            return types.TextMessage(
                              author: types.User(
                                id: m.sender,
                                imageUrl: group.users[m.sender]?.profileUrl,
                                firstName: group.users[m.sender]?.nickname ?? context.tr.anonymous,
                              ),
                              id: m.text,
                              text: m.text,
                              createdAt: m.sentAt.millisecondsSinceEpoch,
                            );
                          }
                        }).toList(),
                        onSendPressed: _handleSendPressed,
                        user: types.User(
                          id: context.read(userIdProvider)!,
                        ),
                        isAttachmentUploading: _isAttachmentUploading,
                        onAttachmentPressed: () async {
                          var option = await AttachmentBottomSheet.open(context);
                          switch (option) {
                            case AttachmentOption.image:
                              _handleImageSelection();
                              break;
                            case AttachmentOption.file:
                              _handleFileSelection();
                              break;
                            default:
                              break;
                          }
                        },
                        // onMessageTap: _handleMessageTap,
                        onPreviewDataFetched: _handlePreviewDataFetched,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
