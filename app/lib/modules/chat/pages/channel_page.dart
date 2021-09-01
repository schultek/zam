import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/themes/themes.dart';
import '../../../providers/auth/user_provider.dart';
import '../../../providers/trips/selected_trip_provider.dart';
import '../chat_provider.dart';
import '../widgets/attachment_bottom_sheet.dart';
import 'channel/channel_info_page.dart';

class ChannelPage extends StatefulWidget {
  final ChannelInfo channel;
  const ChannelPage(this.channel) : super();

  static Route route(ChannelInfo channel) {
    return MaterialPageRoute(builder: (context) => ChannelPage(channel));
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
      await context.read(chatLogicProvider).sendFile(widget.channel.id, result);
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
      await context.read(chatLogicProvider).sendImage(widget.channel.id, result);
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
    context.read(chatLogicProvider).send(widget.channel.id, message.text);
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor = context.getFillColor();
    return Scaffold(
      appBar: AppBar(
        title: Text('# ${widget.channel.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () async {
              var shouldLeave = await Navigator.of(context).push(ChannelInfoPage.route(widget.channel));
              if (shouldLeave == true) {
                await context.read(chatLogicProvider).leaveChannel(widget.channel.id);
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FillColor(
              preference: ColorPreference(contrast: Contrast.low),
              builder: (context, fillColor) => SafeArea(
                child: Consumer(
                  builder: (context, watch, _) {
                    var messages = watch(widget.channel.messages).data?.value ?? [];
                    var trip = watch(selectedTripProvider)!;

                    return Chat(
                      theme: DarkChatTheme(
                        backgroundColor: backgroundColor,
                        primaryColor: Colors.red,
                        attachmentButtonIcon: const Icon(Icons.link),
                        secondaryColor: fillColor,
                        inputBackgroundColor: fillColor,
                      ),
                      showUserAvatars: true,
                      showUserNames: true,
                      messages: messages.map((m) {
                        if (m is ChatImageMessage) {
                          return types.ImageMessage(
                            author: types.User(
                              id: m.sender,
                              imageUrl: trip.users[m.sender]?.profileUrl,
                              firstName: trip.users[m.sender]?.nickname ?? 'Anonym',
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
                              imageUrl: trip.users[m.sender]?.profileUrl,
                              firstName: trip.users[m.sender]?.nickname ?? 'Anonym',
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
                              imageUrl: trip.users[m.sender]?.profileUrl,
                              firstName: trip.users[m.sender]?.nickname ?? 'Anonym',
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
          ),
        ],
      ),
    );
  }
}
