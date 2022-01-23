import 'package:flutter/material.dart';

import '../../../helpers/extensions.dart';
import '../widgets/channel_list.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.chat),
      ),
      body: const ChannelList(),
    );
  }
}
